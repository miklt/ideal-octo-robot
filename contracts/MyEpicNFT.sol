pragma solidity 0.8.0;

// We need some util functions for strings.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import {Base64} from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
    // So, we make a baseSvg variable here that all our NFTs can use.
    string line1 = "<tspan x='50%' dy='.6em'>";
    string line2 = "<tspan x='50%' dy='1.2em'>";
    string line3 = "<tspan x='50%' dy='1.2em'>";
    string endline = "</tspan>";
    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='30%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    // I create three arrays, each with their own theme of random words.

    // Pick some random funny words, names of anime characters, foods you like, whatever!
    string[] firstWords = [
        "mountain",
        "evening",
        "autumn",
        "summer",
        "dunes",
        "spring",
        "hillside",
        "desert",
        "Christmas",
        "beach",
        "morning",
        "winter",
        "afternoon",
        "forest",
        "savannah",
        "creek",
        "snow",
        "river"
    ];
    string[] secondWords = [
        "biting ",
        "cold ",
        "bright ",
        "rainy ",
        "damp ",
        "snowy ",
        "windy ",
        "warm ",
        "sunny ",
        "freezing ",
        "chilly ",
        "icy ",
        "bushy ",
        "magical ",
        "dull "
    ];
    string[] thirdWords = [
        "friend ",
        "goldfish ",
        "panda ",
        "pencil ",
        "husband ",
        "giraffe ",
        "wolf ",
        "pot ",
        "biscuit ",
        "lobster ",
        "chocolate ",
        "bottle ",
        "boyfriend ",
        "pond ",
        "hamster ",
        "vampire ",
        "petal ",
        "lorry "
    ];
    string[] fourthWords = [
        "wolf",
        "cheetah",
        "zombie",
        "snake",
        "snail",
        "giraffe",
        "frog",
        "spider",
        "chimpanzee",
        "deer",
        "shark",
        "kangaroo",
        "fly",
        "sheep",
        "salt",
        "hammer",
        "cow",
        "scorpion"
    ];
    string[] fifthWords = [
        "passionate ",
        "potable ",
        "grumpy ",
        "hot ",
        "smart ",
        "furry ",
        "attractive ",
        "pale ",
        "fierce ",
        "kind ",
        "clever ",
        "glorious ",
        "intense ",
        "fancy ",
        "weak ",
        "major ",
        "interesting ",
        "creepy "
    ];
    string[] sixthWords = [
        "looks",
        "frightens",
        "hoots",
        "roars",
        "cuddles",
        "stands",
        "squeaks",
        "hides",
        "crawls",
        "trots",
        "skips",
        "hunts",
        "sings",
        "waits",
        "slithers",
        "wallows",
        "drools",
        "chirps"
    ];
    string[] lastConnectors = [
        "into the ",
        "by the ",
        "a ",
        "over the ",
        "inside the "
    ];
    event NewEpicNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract. Woah!");
    }

    // I create a function to randomly pick a word from each array.
    function pickRandomFirstWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        // I seed the random generator. More on this in the lesson.
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );
        // Squash the # between 0 and the length of the array to avoid going out of bounds.
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId)))
        );
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function pickRandomFourthWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        rand = rand % fourthWords.length;
        return fourthWords[rand];
    }

    function pickRandomFifthWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        rand = rand % fifthWords.length;
        return fifthWords[rand];
    }

    function pickRandomSixthWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        rand = rand % sixthWords.length;
        return sixthWords[rand];
    }

    function pickRandomLastConnector(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        rand = rand % lastConnectors.length;
        return lastConnectors[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function append(
        string memory a,
        string memory b,
        string memory c,
        string memory d,
        string memory e
    ) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b, c, d, e));
    }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();

        // We go and randomly grab one word from each of the three arrays.
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory fourth = pickRandomFourthWord(newItemId);
        string memory fifth = pickRandomFifthWord(newItemId);
        string memory sixth = pickRandomSixthWord(newItemId);
        string memory lastConnector = pickRandomLastConnector(newItemId);
        string memory l1 = append(line1, second, first, endline, "");
        string memory l2 = append(line2, fifth, third, sixth, endline);
        string memory l3 = append(line3, lastConnector, fourth, endline, "");
        // second first
        //fifth third sixth
        // fourth

        // I concatenate it all together, and then close the <text> and <svg> tags.
        string memory finalSvg = string(
            abi.encodePacked(baseSvg, l1, l2, l3, "</text></svg>")
        );
        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        append(fifth, third, sixth, "", ""),
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );
        // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);

        // Update your URI!!!
        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );
        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}
