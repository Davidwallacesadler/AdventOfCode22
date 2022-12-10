import UIKit

// MARK: - Day 2

let dayTwoDataFileURL = Bundle.main.url(forResource: "Input", withExtension: "txt")
let rpsStrategyGuideData = try String(contentsOf: dayTwoDataFileURL!)
let strategyGuideMoveLines: [String] = rpsStrategyGuideData.components(separatedBy: "\n")

struct RockPaperScissorsGame {

    init(opponentMoveString: String, myMoveString: String) {
        self.opponentMove = Move.from(character: opponentMoveString)
        self.myMove = Move.from(character: myMoveString)
    }

    init(opponentMoveString: String, outcomeString: String) {
        let opponentMove = Move.from(character: opponentMoveString)
        self.opponentMove = opponentMove
        let gameOutcome = Outcome.from(character: outcomeString)
        self.myMove = Move.from(opponentMove: opponentMove, outcome: gameOutcome)
    }

    let myMove: Move
    let opponentMove: Move

    func getMyScoreValue() -> Int {
        let outcomeValue = getGameOutcome().rawValue
        let myMoveValue = myMove.rawValue
        return outcomeValue + myMoveValue
    }

    func getGameOutcome() -> Outcome {
        if myMove == opponentMove {
            return .tie
        }
        switch opponentMove {
        case .rock:
            if myMove == .paper {
                return .win
            }

        case .paper:
            if myMove == .scissors {
                return .win
            }

        case .scissors:
            if myMove == .rock {
                return .win
            }
        }
        return .lose
    }

    enum Move: Int {
        case rock = 1, paper, scissors

        static func from(character: String) -> Self {
            switch character {
            case "A", "X":
                return .rock
            case "B", "Y":
                return .paper
            case "C", "Z":
                return .scissors
            default:
                return .rock
            }
        }

        static func from(opponentMove: Self, outcome: Outcome) -> Self {
            if outcome == .tie {
                return opponentMove
            }
            switch opponentMove {
            case .rock:
                if outcome == .win {
                    return .paper
                }
                return .scissors
            case .paper:
                if outcome == .win {
                    return .scissors
                }
                return .rock
            case .scissors:
                if outcome == .win {
                    return .rock
                }
                return .paper
            }
        }
    }

    enum Outcome: Int {
        case lose = 0,
             tie = 3,
             win = 6

        static func from(character: String) -> Self {
            switch character {
            case "X":
                return .lose
            case "Y":
                return .tie
            case "Z":
                return .win
            default:
                return .tie
            }
        }
    }
}

// Part 1: assuming X,Y,Z are moves
let rockPaperScissorGames: [RockPaperScissorsGame] = strategyGuideMoveLines.compactMap { gameText in
    let gameMoveChars = gameText.components(separatedBy: " ")
    let opponentMoveChar = gameMoveChars.first
    let myMoveChar = gameMoveChars.last
    guard let opponent = opponentMoveChar,
          let mine = myMoveChar,
          !opponent.isEmpty && !mine.isEmpty else { return nil }
    return RockPaperScissorsGame(opponentMoveString: opponent, myMoveString: mine)
}

let myTotalScoreOverAllGames = rockPaperScissorGames.reduce(into: 0, { $0 += $1.getMyScoreValue() })
print(myTotalScoreOverAllGames)

// Part 2: assuming X,Y,Z are outcomes
let rockPaperScissorGames2: [RockPaperScissorsGame] = strategyGuideMoveLines.compactMap { gameText in
    let gameMoveChars = gameText.components(separatedBy: " ")
    let opponentMoveChar = gameMoveChars.first
    let outcomeChar = gameMoveChars.last
    guard let opponent = opponentMoveChar,
          let outcome = outcomeChar,
          !opponent.isEmpty && !outcome.isEmpty else { return nil }
    return RockPaperScissorsGame(opponentMoveString: opponent, outcomeString: outcome)
}

let myTotalScoreOverAllGames2 = rockPaperScissorGames2.reduce(into: 0, { $0 += $1.getMyScoreValue() })
print(myTotalScoreOverAllGames2)
