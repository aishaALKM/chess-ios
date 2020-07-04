import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, ChessDelegate {
    
    
    
    
    
    
    @IBOutlet weak var promoteToQueenButton: UIButton!
    @IBOutlet weak var promoteToRookButton: UIButton!
    @IBOutlet weak var promoteToKnightButton: UIButton!
    @IBOutlet weak var promoteToBishopButton: UIButton!
    
    @IBOutlet weak var boardView: BoardView!
    
    
    var chessBrain = ChessBrain()
    var peerID: MCPeerID!
    var session: MCSession!
//    var advertiserAssistant: MCAdvertiserAssistant!
    var nearbyServiceAdvertiser: MCNearbyServiceAdvertiser!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID)
        session.delegate = self
        
        chessBrain.reset()
        
        boardView.piecesBoxShadow = chessBrain.piecesBox
        boardView.setNeedsDisplay()
        boardView.chessDelegate = self
        
        boardDeploy()
    }
    
    @IBAction func advertise(_ sender: Any) {
        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "dabaos-chess")
        nearbyServiceAdvertiser.delegate = self
        nearbyServiceAdvertiser.startAdvertisingPeer()
    }
    
    @IBAction func join(_ sender: Any) {
        let browser = MCBrowserViewController(serviceType: "dabaos-chess", session: session)
        browser.delegate = self
        present(browser, animated: true)
    }
    
    func movePiece(frX: Int, frY: Int, toX: Int, toY: Int) {
        
        guard let movingPiece = chessBrain.pieceAt(x: frX, y: frY) else {
            return
        }
        
        chessBrain.movePiece(frX: frX, frY: frY, toX: toX, toY: toY)
        boardView.piecesBoxShadow = chessBrain.piecesBox
        boardView.setNeedsDisplay()
    }

    func getMovingPiece(x: Int, y: Int) -> ChessPiece? {
        return chessBrain.pieceAt(x: x, y: y)
    }
    
    func boardDeploy() {
        let bottonGap: CGFloat = 20
        let buttonLong: CGFloat = 176
    }
}

extension ViewController: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("connected: \(peerID.displayName)")
        case .connecting:
            print("connecting:  \(peerID.displayName)...")
        case .notConnected:
            print("not-connected! (\(peerID.displayName))")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
}

extension ViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
}

extension ViewController: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
    
    
}
