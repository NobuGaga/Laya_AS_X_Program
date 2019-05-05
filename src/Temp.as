// import {GameMain} from './base/GameMain.js'
// import {ResLoader} from './utils/ResLoader.js'
// import {MainBoard} from "./base/MainBoard";
// import {UserUtils} from "./utils/UserUtils";
// import {GlobalData} from "./base/GlobalData";
// import {GameEvent} from "./utils/GameEvent";
// import {LayoutUtils} from "./utils/LayoutUtils";

// GameMain.init();
// Laya.loader.load("res/atlas/loading.atlas", Laya.Handler.create(this, function (e) {
//     let resManager = ResLoader.getInstance();
//     let loading = new ui.view.gameLoadingUI();
//     Laya.stage.addChild(loading);
//     let sp_mask = loading.sp_mask;
//     sp_mask.optimizeScrollRect = true;
//     resManager.loaded((e) => {
//         let mainBoard = MainBoard.getInstance();
//         let user = UserUtils.getInstance();
//         user.getWxUser({
//             sucFn: () => {
//                 console.log('登陆成功v1.0.0');
//                 Laya.stage.addChild(LayoutUtils.getInstance().map.get("gameStartUI"));
//                 Laya.stage.removeChild(loading);
//                 mainBoard.initMainBoard();
//                 GameEvent.getInstance().bindListenEvent();
//                 GameEvent.getInstance().remarkGameTime();  
//             }, errFn: () => {
//                 alert('登陆失败');
//             }
//         });

//     }, (e) => {
//         let process = parseInt(e * 100);
//         loading.progress_text.text = process + '%';
//         sp_mask.scrollRect = new Laya.Rectangle(0, 0, 5.2 * process, 24);
//     });
// }));

// export class ResLoader {

//     static getInstance() {
//         return ResLoader.instance ? ResLoader.instance : ResLoader.instance = new ResLoader();
//     }

//     constructor() {}
// }