import "IterableMappingCMC.sol";

contract Registry {
    IterableMappingCMC.itmap data;

    event AssetAdded(address contractAddress); // useful for testing

    /// @notice addAsset(address) to add a new ChannelManagerContract to channelManagerContracts
    /// with the assetAddress as key.
    /// @dev Add a new ChannelManagerContract to channelManagerContracts if assetAddress
    /// does not already exist.
    /// @param assetAddress (address) the address of the asset
    /// @return nothing, but updates the collection of ChannelManagerContracts.
    function addAsset(address assetAddress) returns (address contractAddress) {
        // only allow unique addresses
        if (IterableMappingCMC.contains(data, assetAddress)) throw;
        ChannelManagerContract c = new ChannelManagerContract(assetAddress);
        IterableMappingCMC.insert(data, assetAddress, c);
        contractAddress = address(c);
        AssetAdded(address(c)); // useful for testing
    }

    /// @notice channelManagerByAsset(address) to get the ChannelManagerContract
    /// of the given assetAddress.
    /// @dev Get the ChannelManagerContract of a given assetAddress.
    /// @param assetAddress (address) the asset address.
    /// @return asAdr (address) the address belonging of an assetAddress.
    function channelManagerByAsset(address assetAddress) returns (address conAdr) {
        // if assetAddress does not exist, throw
        if (IterableMappingCMC.contains(data, assetAddress) == false) throw;
        uint index = IterableMappingCMC.atIndex(data, assetAddress);
        var(key, value) = IterableMappingCMC.iterate_get(data, index - 1);
        conAdr = address(value);
    }

    /// @notice assetAddresses() to get all assetAddresses in the collection.
    /// @dev Get all assetAddresses in the collection.
    /// @return assetAddress (address[]) an array of all assetAddresses
    function assetAddresses() returns (address[] assetAddresses) {
        assetAddresses = new address[](data.size);
        for (var i = IterableMappingCMC.iterate_start(data); IterableMappingCMC.iterate_valid(data, i); i = IterableMappingCMC.iterate_next(data, i)) {
            var (key, value) = IterableMappingCMC.iterate_get(data, i);
            assetAddresses[i] = key;
        }
    }

    // empty function to handle wrong calls
    function () { throw; }
}
