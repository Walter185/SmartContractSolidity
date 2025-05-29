// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Subasta con aumento mínimo del 5%, reembolsos parciales, extensión dinámica y comisión del 2%
contract SubastaKipu {
    address public owner;
    address public highestBidder;
    uint public highestBid;
    uint public initialPrice;
    uint public startTime;
    uint public duration;
    uint public extensionTime;
    bool public subastaActiva;

    mapping(address => uint) public bids;
    address[] public participantes;
    string public prize;
    bool public prizeClaimed;

    event NuevaOferta(address postor, uint monto);
    event SubastaFinalizada(address ganador, uint monto);
    event DepositoDevuelto(address postor, uint monto);
    event ExcesoRetirado(address postor, uint monto);

    constructor(
        uint _initialPrice,
        uint _extensionTime,
        uint _duration
    ) {
        owner = msg.sender;
        initialPrice = _initialPrice;
        extensionTime = _extensionTime;
        duration = _duration;
        startTime = block.timestamp;
        subastaActiva = true;
        highestBid = _initialPrice;
    }

    modifier soloDuranteSubasta() {
        require(subastaActiva && block.timestamp <= startTime + duration, "La subasta ha finalizado");
        _;
    }

    modifier soloOwner() {
        require(msg.sender == owner, "Solo el owner puede ejecutar esto");
        _;
    }

    function pujar() external payable soloDuranteSubasta {
        require(
            msg.value >= highestBid + (highestBid * 5) / 100,
            "La oferta debe ser al menos un 5% mayor que la anterior"
        );

        if (bids[msg.sender] == 0) {
            participantes.push(msg.sender);
        }

        bids[msg.sender] += msg.value;
        highestBid = msg.value;
        highestBidder = msg.sender;

        if ((startTime + duration - block.timestamp) <= 600) {
            duration += extensionTime;
        }

        emit NuevaOferta(msg.sender, msg.value);
    }

    function definirPremio(string memory _prize) external soloOwner {
        prize = _prize;
    }

    function transferirPremioAlGanador() public soloOwner {
        require(!prizeClaimed, "El premio ya fue entregado");
        require(!subastaActiva, "La subasta aun esta activa");
        require(highestBidder != address(0), "No hay ganador");

        prizeClaimed = true;
    }

    function finalizarSubasta() external {
        require(block.timestamp > startTime + duration, "La subasta aun esta activa");
        require(subastaActiva, "La subasta ya ha finalizado");

        subastaActiva = false;
        payable(owner).transfer(highestBid);
        transferirPremioAlGanador();

        for (uint i = 0; i < participantes.length; i++) {
            address participante = participantes[i];
            if (participante != highestBidder && bids[participante] > 0) {
                uint monto = bids[participante];
                uint comision = (monto * 2) / 100;
                uint devolucion = monto - comision;
                bids[participante] = 0;
                payable(participante).transfer(devolucion);
                emit DepositoDevuelto(participante, devolucion);
            }
        }

        emit SubastaFinalizada(highestBidder, highestBid);
    }

    function retirarExceso() external soloDuranteSubasta {
        require(msg.sender != highestBidder, "El ganador no puede retirar exceso durante la subasta");
        uint oferta = highestBid;
        uint actual = bids[msg.sender];
        require(actual > 0, "No hay fondos para retirar");

        uint exceso = 0;
        if (actual > oferta) {
            exceso = actual - oferta;
            bids[msg.sender] -= exceso;
            payable(msg.sender).transfer(exceso);
            emit ExcesoRetirado(msg.sender, exceso);
        }
    }

    function obtenerGanador() external view returns (address, uint) {
        return (highestBidder, highestBid);
    }

    function mostrarOferta(address postor) external view returns (uint) {
        return bids[postor];
    }

    function verTodasLasOfertas() external view returns (address[] memory, uint[] memory) {
        uint[] memory montos = new uint[](participantes.length);
        for (uint i = 0; i < participantes.length; i++) {
            montos[i] = bids[participantes[i]];
        }
        return (participantes, montos);
    }
}
