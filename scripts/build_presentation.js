const pptxgen = require('pptxgenjs');
const pptx = new pptxgen();
pptx.layout = 'LAYOUT_WIDE';
pptx.author = 'M.Tech Project';
pptx.subject = 'Flutter iOS Task Manager using Back4App BaaS';
pptx.title = 'M.Tech Task Manager - Flutter iOS + Back4App';
pptx.company = 'Academic Project';
pptx.lang = 'en-IN';
pptx.theme = {
  headFontFace: 'Aptos Display',
  bodyFontFace: 'Aptos',
  lang: 'en-US'
};
pptx.defineSlideMaster({
  title: 'MASTER',
  background: { color: 'F7F8FC' },
  objects: [
    { rect: { x: 0, y: 0, w: 13.333, h: 0.12, fill: { color: '3157D5' }, line: { color: '3157D5' } } },
    { text: { text: 'SE ZG585 • M.Tech Project', options: { x: 0.55, y: 7.13, w: 4.0, h: 0.18, fontFace: 'Aptos', fontSize: 9, color: '7B8297', margin: 0 } } },
    { text: { text: 'Flutter iOS + Back4App', options: { x: 9.4, y: 7.13, w: 3.35, h: 0.18, fontFace: 'Aptos', fontSize: 9, color: '7B8297', align: 'right', margin: 0 } } }
  ],
  slideNumber: { x: 12.82, y: 7.08, color: '7B8297', fontSize: 9 }
});

const C = { navy:'191F2D', muted:'667085', blue:'3157D5', light:'EBEFFD', border:'E3E6EF', white:'FFFFFF', green:'2C9A74', red:'C9484F', purple:'754EBD', bg:'F7F8FC' };
const ROOT='/mnt/data/MTech_Task_Manager_iOS';
function title(slide, kicker, heading, sub='') {
  slide.addText(kicker.toUpperCase(), {x:0.7,y:0.48,w:3.7,h:0.28,fontSize:11,bold:true,color:C.blue,charSpacing:1.2,margin:0});
  slide.addText(heading, {x:0.7,y:0.84,w:11.8,h:0.65,fontSize:28,bold:true,color:C.navy,margin:0,breakLine:false});
  if (sub) slide.addText(sub,{x:0.7,y:1.52,w:11.7,h:0.45,fontSize:14,color:C.muted,margin:0});
}
function pill(slide,x,y,w,text,fill=C.light,color=C.blue) {
  slide.addShape(pptx.ShapeType.roundRect,{x,y,w,h:0.36,rectRadius:0.08,fill:{color:fill},line:{color:fill}});
  slide.addText(text,{x:x+0.08,y:y+0.07,w:w-0.16,h:0.18,fontSize:10,bold:true,color,align:'center',margin:0});
}
function card(slide,x,y,w,h,opts={}) {
  slide.addShape(pptx.ShapeType.roundRect,{x,y,w,h,rectRadius:0.08,fill:{color:opts.fill||C.white},line:{color:opts.line||C.border,width:1}});
}
function bulletList(slide, items, x,y,w,fs=17, gap=0.54) {
  items.forEach((t,i)=>{
    slide.addShape(pptx.ShapeType.ellipse,{x,y:y+i*gap+0.08,w:0.12,h:0.12,fill:{color:C.blue},line:{color:C.blue}});
    slide.addText(t,{x:x+0.22,y:y+i*gap,w:w-0.22,h:0.35,fontSize:fs,color:C.navy,margin:0,breakLine:false});
  });
}
function addArrow(slide,x1,y1,x2,y2,label='') {
  slide.addShape(pptx.ShapeType.line,{x:x1,y:y1,w:x2-x1,h:y2-y1,line:{color:'9AA3B5',width:2,beginArrowType:'none',endArrowType:'triangle'}});
  if(label) slide.addText(label,{x:(x1+x2)/2-0.55,y:(y1+y2)/2-0.18,w:1.1,h:0.26,fontSize:10,color:C.muted,align:'center',margin:0,fill:{color:C.bg,transparency:10}});
}

// 1
{
 const s=pptx.addSlide('MASTER');
 s.background={color:C.bg};
 s.addShape(pptx.ShapeType.roundRect,{x:0.75,y:0.85,w:0.78,h:0.78,rectRadius:0.12,fill:{color:C.blue},line:{color:C.blue}});
 s.addText('✓',{x:0.75,y:0.95,w:0.78,h:0.45,fontSize:31,bold:true,color:C.white,align:'center',margin:0});
 s.addText('TASK MANAGER',{x:0.75,y:1.92,w:4.2,h:0.36,fontSize:12,bold:true,color:C.blue,charSpacing:2.2,margin:0});
 s.addText('Flutter iOS CRUD App\nwith Back4App BaaS',{x:0.75,y:2.36,w:6.5,h:1.38,fontSize:34,bold:true,color:C.navy,margin:0,breakLine:false});
 s.addText('M.Tech • SE ZG585 Assignment Project',{x:0.75,y:3.93,w:5.8,h:0.36,fontSize:18,color:C.muted,margin:0});
 pill(s,0.75,4.52,1.35,'FLUTTER'); pill(s,2.22,4.52,1.20,'iOS'); pill(s,3.55,4.52,1.55,'BACK4APP'); pill(s,5.23,4.52,1.45,'LIVE SYNC');
 s.addText('Student: Angshuman Pal',{x:0.75,y:5.35,w:3.6,h:0.3,fontSize:15,bold:true,color:C.navy,margin:0});
 s.addText('BITS ID: [ADD YOUR BITS ID BEFORE SUBMISSION]',{x:0.75,y:5.76,w:5.2,h:0.3,fontSize:12,color:C.muted,margin:0});
 s.addImage({path:`${ROOT}/assets/screenshots/02_dashboard_mockup.png`,x:8.72,y:0.55,w:3.35,h:6.55});
}

// 2
{
 const s=pptx.addSlide('MASTER'); title(s,'Assignment fit','What the project delivers','The implementation maps directly to the requested Flutter + Back4App task-manager flow.');
 const items=[
  ['User Authentication','Register and login with student email through Parse _User.','person'],
  ['Complete CRUD','Create, read, update and delete Task objects in Back4App.','crud'],
  ['Real-time Ready','Parse Live Query + live-list widget for dynamic updates.','sync'],
  ['Secure Logout','Parse session logout returns the user to the login screen.','logout'],
  ['Submission Ready','README, setup guide, screenshots, video script and PPT.','repo']
 ];
 items.forEach((it,i)=>{
   const y=2.18+i*0.9; card(s,0.85,y,11.55,0.68);
   s.addShape(pptx.ShapeType.ellipse,{x:1.05,y:y+0.14,w:0.38,h:0.38,fill:{color:i===2?'EAF7F2':C.light},line:{color:i===2?C.green:C.blue}});
   s.addText(String(i+1),{x:1.05,y:y+0.20,w:0.38,h:0.2,fontSize:11,bold:true,color:i===2?C.green:C.blue,align:'center',margin:0});
   s.addText(it[0],{x:1.63,y:y+0.13,w:2.35,h:0.26,fontSize:15,bold:true,color:C.navy,margin:0});
   s.addText(it[1],{x:4.0,y:y+0.13,w:7.9,h:0.32,fontSize:13,color:C.muted,margin:0});
 });
}

// 3 architecture
{
 const s=pptx.addSlide('MASTER'); title(s,'Architecture','BaaS architecture — no custom server required','Flutter talks to Back4App through the Parse Flutter SDK; Back4App owns authentication, data and real-time events.');
 const nodes=[
   {x:0.95,y:2.5,w:2.55,h:2.15,t:'iOS Flutter App',sub:'Screens • Forms • Dashboard\nValidation • Session Gate',fill:'FFFFFF'},
   {x:4.2,y:2.5,w:2.55,h:2.15,t:'Parse Flutter SDK',sub:'Auth APIs • Queries\nObject CRUD • Live Query',fill:'F4F6FE'},
   {x:7.45,y:2.1,w:4.55,h:2.95,t:'Back4App BaaS',sub:'_User authentication\nTask cloud database\nSessions + object ACLs\nLive Query WebSocket',fill:'FFFFFF'}
 ];
 nodes.forEach((n,i)=>{card(s,n.x,n.y,n.w,n.h,{fill:n.fill}); s.addText(n.t,{x:n.x+0.22,y:n.y+0.28,w:n.w-0.44,h:0.35,fontSize:19,bold:true,color:i===1?C.blue:C.navy,align:'center',margin:0}); s.addText(n.sub,{x:n.x+0.25,y:n.y+0.86,w:n.w-0.5,h:0.9,fontSize:14,color:C.muted,align:'center',valign:'mid',margin:0,breakLine:false});});
 addArrow(s,3.5,3.58,4.2,3.58,'SDK'); addArrow(s,6.75,3.58,7.45,3.58,'HTTPS / WSS');
 s.addShape(pptx.ShapeType.roundRect,{x:7.85,y:5.33,w:3.75,h:0.75,rectRadius:0.08,fill:{color:'EAF7F2'},line:{color:'CFEBDD'}});
 s.addText('Owner-only ACL protects each Task object',{x:8.05,y:5.55,w:3.35,h:0.27,fontSize:13,bold:true,color:C.green,align:'center',margin:0});
}

// 4 auth
{
 const s=pptx.addSlide('MASTER'); title(s,'Authentication','Student registration, login and session restoration');
 s.addImage({path:`${ROOT}/assets/screenshots/01_login_mockup.png`,x:0.82,y:1.95,w:2.62,h:4.95});
 const steps=[
   ['1','Register','Email is normalized and sent to Parse _User with the password and displayName.'],
   ['2','Login','Parse validates username/password and persists the current session.'],
   ['3','Auth Gate','On app launch, the saved current user decides whether Login or Home is shown.'],
   ['4','Logout','Parse logout invalidates/removes the current session and returns to Login.']
 ];
 steps.forEach((a,i)=>{const y=2.06+i*1.08; s.addShape(pptx.ShapeType.ellipse,{x:4.05,y:y,w:0.48,h:0.48,fill:{color:C.blue},line:{color:C.blue}}); s.addText(a[0],{x:4.05,y:y+0.11,w:0.48,h:0.2,fontSize:11,bold:true,color:C.white,align:'center',margin:0}); s.addText(a[1],{x:4.75,y:y-0.02,w:2.2,h:0.3,fontSize:17,bold:true,color:C.navy,margin:0}); s.addText(a[2],{x:4.75,y:y+0.35,w:6.75,h:0.5,fontSize:13,color:C.muted,margin:0});});
 pill(s,4.05,6.45,3.0,'NO CUSTOM AUTH SERVER','EAF7F2',C.green);
}

// 5 CRUD
{
 const s=pptx.addSlide('MASTER'); title(s,'Task management','Create • Read • Update • Delete','A service layer keeps Parse operations out of the UI and makes the flow easy to explain in a viva.');
 s.addImage({path:`${ROOT}/assets/screenshots/03_create_task_mockup.png`,x:0.7,y:2.0,w:2.55,h:4.85});
 const ops=[
   {t:'CREATE',c:C.green,d:'TaskService.createTask() saves title, description, priority, due date, owner fields and ACL.'},
   {t:'READ',c:C.blue,d:'ParseLiveListWidget executes an owner-scoped query sorted by updatedAt.'},
   {t:'UPDATE',c:C.purple,d:'Edit form and completion toggle save changes back to the same ParseObject.'},
   {t:'DELETE',c:C.red,d:'Delete action asks for confirmation, then removes the Parse object from Back4App.'}
 ];
 ops.forEach((o,i)=>{const y=2.05+i*1.08; card(s,3.75,y,8.35,0.82); s.addText(o.t,{x:4.0,y:y+0.2,w:1.1,h:0.24,fontSize:13,bold:true,color:o.c,margin:0}); s.addText(o.d,{x:5.18,y:y+0.13,w:6.5,h:0.45,fontSize:13,color:C.navy,margin:0});});
 s.addText('Extra usability: search • All/Active/Done filter • priority • due date • dashboard counters',{x:3.75,y:6.47,w:8.35,h:0.38,fontSize:12,bold:true,color:C.muted,align:'center',margin:0});
}

// 6 realtime security
{
 const s=pptx.addSlide('MASTER'); title(s,'Cloud & security','Real-time sync without exposing privileged credentials');
 s.addImage({path:`${ROOT}/assets/screenshots/04_back4app_database_mockup.png`,x:0.76,y:2.0,w:6.1,h:3.82});
 card(s,7.25,2.0,5.15,1.42,{fill:'F4F6FE'}); s.addText('Live Query',{x:7.55,y:2.28,w:1.8,h:0.3,fontSize:18,bold:true,color:C.blue,margin:0}); s.addText('Back4App pushes matching create/update/delete events over WebSocket after Live Query is enabled for Task.',{x:7.55,y:2.73,w:4.3,h:0.55,fontSize:13,color:C.navy,margin:0});
 card(s,7.25,3.72,5.15,1.42,{fill:'EAF7F2',line:'D4EDE4'}); s.addText('Object ACL',{x:7.55,y:4.0,w:1.8,h:0.3,fontSize:18,bold:true,color:C.green,margin:0}); s.addText('Each Task receives ParseACL(owner: owner), so ordinary client access is restricted to its owner.',{x:7.55,y:4.45,w:4.3,h:0.55,fontSize:13,color:C.navy,margin:0});
 card(s,7.25,5.44,5.15,1.02,{fill:'FFF7F7',line:'F2DCDD'}); s.addText('Master Key never goes in the mobile app.',{x:7.55,y:5.78,w:4.3,h:0.28,fontSize:14,bold:true,color:C.red,align:'center',margin:0});
}

// 7 demo
{
 const s=pptx.addSlide('MASTER'); title(s,'Video demo','A clean two-minute recording path','This sequence covers every operation explicitly requested in the assignment video.');
 const flow=['Register / Login','Create task','Show task / cloud row','Edit + complete','Delete','Logout'];
 flow.forEach((f,i)=>{
   const x=0.78+i*2.05; s.addShape(pptx.ShapeType.ellipse,{x,y:2.35,w:0.72,h:0.72,fill:{color:i===5?C.green:C.blue},line:{color:i===5?C.green:C.blue}}); s.addText(String(i+1),{x,y:2.56,w:0.72,h:0.22,fontSize:13,bold:true,color:C.white,align:'center',margin:0}); s.addText(f,{x:x-0.3,y:3.23,w:1.32,h:0.5,fontSize:12,bold:true,color:C.navy,align:'center',margin:0}); if(i<5)addArrow(s,x+0.76,2.71,x+1.72,2.71,'');
 });
 card(s,0.9,4.25,11.5,1.45,{fill:C.white}); s.addText('Recording tip',{x:1.25,y:4.55,w:1.4,h:0.3,fontSize:17,bold:true,color:C.blue,margin:0}); s.addText('Keep the iPhone Simulator and the Back4App Database tab ready before recording. Use the included docs/VIDEO_SCRIPT_2_MIN.md so the CRUD sequence stays concise.',{x:2.75,y:4.48,w:8.95,h:0.52,fontSize:14,color:C.navy,margin:0});
 pill(s,4.82,6.13,3.7,'LOGIN → C → R → U → D → LOGOUT');
}

// 8 learnings
{
 const s=pptx.addSlide('MASTER'); title(s,'Outcome','Key learnings and submission package');
 bulletList(s,[
   'Integrated Flutter with Back4App Parse Server instead of building a custom backend.',
   'Implemented authentication, sessions, cloud CRUD, ACL authorization and Live Query.',
   'Structured the app into presentation, model and service layers for maintainability.',
   'Prepared the repository for GitHub with credential-safe runtime configuration.',
   'Built an iOS-first demo path suitable for iPhone Simulator and assignment recording.'
 ],0.95,2.1,7.1,15,0.7);
 card(s,8.5,2.05,3.75,3.95,{fill:'FFFFFF'}); s.addText('Included deliverables',{x:8.85,y:2.4,w:3.05,h:0.35,fontSize:18,bold:true,color:C.navy,align:'center',margin:0});
 const ds=['Source code','README + setup','Video script','PPT','Mock screenshots','Viva Q&A'];
 ds.forEach((d,i)=>{pill(s,9.0,3.08+i*0.47,2.75,'✓  '+d,i%2===0?'F4F6FE':'EAF7F2',i%2===0?C.blue:C.green);});
 s.addText('Before submission: add your BITS ID and replace mockups with actual simulator screenshots if required.',{x:0.95,y:6.15,w:7.1,h:0.55,fontSize:13,bold:true,color:C.red,margin:0});
}

pptx.writeFile({ fileName: `${ROOT}/MTech_Task_Manager_Presentation.pptx` });
