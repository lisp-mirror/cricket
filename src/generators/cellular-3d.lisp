(in-package #:cl-user)

(defpackage #:coherent-noise.generators.cellular-3d
  (:local-nicknames
   (#:int #:coherent-noise.internal)
   (#:rng #:seedable-rng)
   (#:u #:golden-utils))
  (:use #:cl)
  (:export #:cellular-3d))

(in-package #:coherent-noise.generators.cellular-3d)

(u:define-constant +random+
    (let ((data #(-0.7292736885d0 -0.6618439697d0 0.1735581948d0 0d0 0.790292081d0 -0.5480887466d0
                  -0.2739291014d0 0d0 0.7217578935d0 0.6226212466d0 -0.3023380997d0 0d0 0.565683137d0
                  -0.8208298145d0 -0.0790000257d0 0d0 0.760049034d0 -0.5555979497d0 -0.3370999617d0
                  0d0 0.3713945616d0 0.5011264475d0 0.7816254623d0 0d0 -0.1277062463d0
                  -0.4254438999d0 0.8959289049d0 0d0 -0.2881560924d0 -0.5815838982d0 0.7607405838d0
                  0d0 0.5849561111d0 -0.662820239d0 -0.4674352136d0 0d0 0.3307171178d0 0.0391653737d0
                  0.94291689d0 0d0 0.8712121778d0 -0.4113374369d0 -0.2679381538d0 0d0 0.580981015d0
                  0.7021915846d0 0.4115677815d0 0d0 0.503756873d0 0.6330056931d0 -0.5878203852d0 0d0
                  0.4493712205d0 0.601390195d0 0.6606022552d0 0d0 -0.6878403724d0 0.09018890807d0
                  -0.7202371714d0 0d0 0.5958956522d0 -0.6469350577d0 0.475797649d0 0d0
                  -0.5127052122d0 0.1946921978d0 0.8361987284d0 0d0 -0.9911507142d0 -0.05410276466d0
                  -0.1212153153d0 0d0 0.2149721042d0 0.9720882117d0 -0.09397607749d0 0d0
                  -0.7518650936d0 -0.5428057603d0 0.3742469607d0 0d0 0.5237068895d0 0.8516377189d0
                  -0.02107817834d0 0d0 0.6333504779d0 0.1926167129d0 -0.7495104896d0 0d0
                  -0.06788241606d0 0.3998305789d0 0.9140719259d0 0d0 0.5538628599d0 -0.4729896695d0
                  -0.6852128902d0 0d0 -0.7261455366d0 -0.5911990757d0 0.3509933228d0 0d0
                  -0.9229274737d0 -0.1782808786d0 0.3412049336d0 0d0 -0.6968815002d0 0.6511274338d0
                  0.3006480328d0 0d0 0.9608044783d0 -0.2098363234d0 -0.1811724921d0 0d0
                  0.06817146062d0 -0.9743405129d0 0.2145069156d0 0d0 -0.3577285196d0 -0.6697087264d0
                  -0.6507845481d0 0d0 -0.1868621131d0 0.7648617052d0 -0.6164974636d0 0d0
                  -0.6541697588d0 0.3967914832d0 0.6439087246d0 0d0 0.6993340405d0 -0.6164538506d0
                  0.3618239211d0 0d0 -0.1546665739d0 0.6291283928d0 0.7617583057d0 0d0
                  -0.6841612949d0 -0.2580482182d0 0.6821542638d0 0d0 0.5383980957d0 0.4258654885d0
                  0.7271630328d0 0d0 -0.5026987823d0 -0.7939832935d0 -0.3418836993d0 0d0
                  0.3202971715d0 0.2834415347d0 0.9039195862d0 0d0 0.8683227101d0 -0.0003762656404d0
                  -0.4959995258d0 0d0 0.791120031d0 -0.08511045745d0 0.6057105799d0 0d0
                  -0.04011016052d0 -0.4397248749d0 0.8972364289d0 0d0 0.9145119872d0 0.3579346169d0
                  -0.1885487608d0 0d0 -0.9612039066d0 -0.2756484276d0 0.01024666929d0 0d0
                  0.6510361721d0 -0.2877799159d0 -0.7023778346d0 0d0 -0.2041786351d0 0.7365237271d0
                  0.644859585d0 0d0 -0.7718263711d0 0.3790626912d0 0.5104855816d0 0d0 -0.3060082741d0
                  -0.7692987727d0 0.5608371729d0 0d0 0.454007341d0 -0.5024843065d0 0.7357899537d0 0d0
                  0.4816795475d0 0.6021208291d0 -0.6367380315d0 0d0 0.6961980369d0 -0.3222197429d0
                  0.641469197d0 0d0 -0.6532160499d0 -0.6781148932d0 0.3368515753d0 0d0 0.5089301236d0
                  -0.6154662304d0 -0.6018234363d0 0d0 -0.1635919754d0 -0.9133604627d0 -0.372840892d0
                  0d0 0.52408019d0 -0.8437664109d0 0.1157505864d0 0d0 0.5902587356d0 0.4983817807d0
                  -0.6349883666d0 0d0 0.5863227872d0 0.494764745d0 0.6414307729d0 0d0 0.6779335087d0
                  0.2341345225d0 0.6968408593d0 0d0 0.7177054546d0 -0.6858979348d0 0.120178631d0 0d0
                  -0.5328819713d0 -0.5205125012d0 0.6671608058d0 0d0 -0.8654874251d0 -0.0700727088d0
                  -0.4960053754d0 0d0 -0.2861810166d0 0.7952089234d0 0.5345495242d0 0d0
                  -0.04849529634d0 0.9810836427d0 -0.1874115585d0 0d0 -0.6358521667d0 0.6058348682d0
                  0.4781800233d0 0d0 0.6254794696d0 -0.2861619734d0 0.7258696564d0 0d0
                  -0.2585259868d0 0.5061949264d0 0.8227581726d0 0d0 0.02136306781d0 0.5064016808d0
                  -0.8620330371d0 0d0 0.200111773d0 0.8599263484d0 0.4695550591d0 0d0 0.4743561372d0
                  0.6014985084d0 -0.6427953014d0 0d0 0.6622993731d0 -0.5202474575d0 -0.5391679918d0
                  0d0 0.08084972818d0 -0.6532720452d0 0.7527940996d0 0d0 -0.6893687501d0
                  0.0592860349d0 0.7219805347d0 0d0 -0.1121887082d0 -0.9673185067d0 0.2273952515d0
                  0d0 0.7344116094d0 0.5979668656d0 -0.3210532909d0 0d0 0.5789393465d0
                  -0.2488849713d0 0.7764570201d0 0d0 0.6988182827d0 0.3557169806d0 0.6205791146d0 0d0
                  -0.8636845529d0 -0.2748771249d0 -0.4224826141d0 0d0 0.4247027957d0 -0.4640880967d0
                  0.777335046d0 0d0 0.5257722489d0 -0.8427017621d0 0.1158329937d0 0d0 0.9343830603d0
                  0.316302472d0 -0.1639543925d0 0d0 -0.1016836419d0 -0.8057303073d0 -0.5834887393d0
                  0d0 -0.6529238969d0 0.50602126d0 -0.5635892736d0 0d0 -0.2465286165d0
                  -0.9668205684d0 -0.06694497494d0 0d0 -0.9776897119d0 -0.2099250524d0
                  0.007368825344d0 0d0 0.7736893337d0 0.5734244712d0 0.2694238123d0 0d0
                  -0.6095087895d0 0.4995678998d0 0.6155736747d0 0d0 0.5794535482d0 0.7434546771d0
                  0.3339292269d0 0d0 -0.8226211154d0 0.08142581855d0 0.5627293636d0 0d0
                  -0.510385483d0 0.4703667658d0 0.7199039967d0 0d0 -0.5764971849d0 -0.07231656274d0
                  -0.8138926898d0 0d0 0.7250628871d0 0.3949971505d0 -0.5641463116d0 0d0
                  -0.1525424005d0 0.4860840828d0 0.8604958341d0 0d0 0.5550976208d0 -0.4957820792d0
                  0.667882296d0 0d0 -0.1883614327d0 0.9145869398d0 0.357841725d0 0d0 0.7625556724d0
                  -0.5414408243d0 0.3540489801d0 0d0 -0.5870231946d0 0.3226498013d0 -0.7424963803d0
                  0d0 0.3051124198d0 0.2262544068d0 -0.9250488391d0 0d0 0.6379576059d0 0.577242424d0
                  -0.5097070502d0 0d0 -0.5966775796d0 0.1454852398d0 0.7891830656d0 0d0
                  0.658330573d0 0.6555487542d0 -0.3699414651d0 0d0 0.7434892426d0 0.2351084581d0
                  0.6260573129d0 0d0 0.5562114096d0 0.8264360377d0 -0.0873632843d0 0d0
                  -0.3028940016d0 -0.8251527185d0 0.4768419182d0 0d0 0.1129343818d0 -0.985888439d0
                  0.1235710781d0 0d0 0.5937652891d0 -0.5896813806d0 0.5474656618d0 0d0
                  0.6757964092d0 -0.5835758614d0 -0.4502648413d0 0d0 0.7242302609d0 -0.1152719764d0
                  0.6798550586d0 0d0 -0.9511914166d0 0.0753623979d0 -0.2992580792d0 0d0
                  0.2539470961d0 -0.1886339355d0 0.9486454084d0 0d0 0.571433621d0 -0.1679450851d0
                  -0.8032795685d0 0d0 -0.06778234979d0 0.3978269256d0 0.9149531629d0 0d0
                  0.6074972649d0 0.733060024d0 -0.3058922593d0 0d0 -0.5435478392d0 0.1675822484d0
                  0.8224791405d0 0d0 -0.5876678086d0 -0.3380045064d0 -0.7351186982d0 0d0
                  -0.7967562402d0 0.04097822706d0 -0.6029098428d0 0d0 0.1996350917d0 0.8706294745d0
                  0.4496111079d0 0d0 -0.02787660336d0 -0.9106232682d0 -0.4122962022d0 0d0
                  -0.7797625996d0 -0.6257634692d0 0.01975775581d0 0d0 0.5211232846d0 0.7401644346d0
                  0.4249554471d0 0d0 0.8575424857d0 0.4053272873d0 0.3167501783d0 0d0
                  0.1045223322d0 0.8390195772d0 -0.5339674439d0 0d0 0.3501822831d0 0.9242524096d0
                  -0.1520850155d0 0d0 0.1987849858d0 0.07647613266d0 0.9770547224d0 0d0
                  0.7845996363d0 0.6066256811d0 -0.1280964233d0 0d0 0.09006737436d0 -0.9750989929d0
                  0.2026569073d0 0d0 -0.8274343547d0 -0.542299559d0 0.1458203587d0 0d0
                  -0.3485797732d0 0.415802277d0 0.840000362d0 0d0 -0.2471778936d0 -0.7304819962d0
                  -0.6366310879d0 0d0 0.3700154943d0 0.8577948156d0 0.3567584454d0 0d0
                  0.5913394901d0 -0.548311967d0 -0.5913303597d0 0d0 0.1204873514d0 -0.7626472379d0
                  -0.6354935001d0 0d0 0.616959265d0 0.03079647928d0 0.7863922953d0 0d0
                  0.1258156836d0 -0.6640829889d0 -0.7369967419d0 0d0 0.6477565124d0 -0.1740147258d0
                  -0.7417077429d0 0d0 0.6217889313d0 -0.7804430448d0 -0.06547655076d0 0d0
                  0.6589943422d0 -0.6096987708d0 0.4404473475d0 0d0 -0.2689837504d0 -0.6732403169d0
                  -0.6887635427d0 0d0 0.3849775103d0 0.5676542638d0 0.7277093879d0 0d0
                  0.5754444408d0 0.8110471154d0 -0.1051963504d0 0d0 0.9141593684d0 0.3832947817d0
                  0.131900567d0 0d0 -0.107925319d0 0.9245493968d0 0.3654593525d0 0d0 0.377977089d0
                  0.3043148782d0 0.8743716458d0 0d0 -0.2142885215d0 -0.8259286236d0 0.5214617324d0
                  0d0 0.5802544474d0 0.4148098596d0 -0.7008834116d0 0d0 -0.1982660881d0
                  0.8567161266d0 0.4761596756d0 0d0 -0.03381553704d0 0.3773180787d0 -0.9254661404d0
                  0d0 0.6867922841d0 -0.6656597827d0 0.2919133642d0 0d0 0.7731742607d0
                  -0.2875793547d0 -0.5652430251d0 0d0 0.09655941928d0 0.9193708367d0 -0.3813575004d0
                  0d0 0.2715702457d0 0.9577909544d0 -0.09426605581d0 0d0 0.2451015704d0
                  -0.6917998565d0 -0.6792188003d0 0d0 0.977700782d0 -0.1753855374d0 0.1155036542d0
                  0d0 -0.5224739938d0 0.8521606816d0 0.02903615945d0 0d0 -0.7734880599d0
                  -0.5261292347d0 0.3534179531d0 0d0 0.7134492443d0 0.269547243d0 0.6467878011d0 0d0
                  0.1644037271d0 0.5105846203d0 -0.8439637196d0 0d0 0.6494635788d0 0.05585611296d0
                  0.7583384168d0 0d0 -0.4711970882d0 0.5017280509d0 -0.7254255765d0 0d0
                  -0.6335764307d0 -0.2381686273d0 -0.7361091029d0 0d0 0.9021533097d0 -0.270947803d0
                  -0.3357181763d0 0d0 -0.3793711033d0 0.872258117d0 0.3086152025d0 0d0
                  -0.6855598966d0 -0.3250143309d0 0.6514394162d0 0d0 0.2900942212d0 0.7799057743d0
                  -0.5546100667d0 0d0 -0.2098319339d0 0.85037073d0 0.4825351604d0 0d0 0.4592603758d0
                  0.6598504336d0 -0.5947077538d0 0d0 0.8715945488d0 0.09616365406d0 -0.4807031248d0
                  0d0 -0.6776666319d0 0.7118504878d0 -0.1844907016d0 0d0 0.7044377633d0
                  0.312427597d0 0.637304036d0 0d0 -0.7052318886d0 -0.2401093292d0 -0.6670798253d0
                  0d0 0.081921007d0 -0.7207336136d0 -0.6883545647d0 0d0 -0.6993680906d0
                  -0.5875763221d0 0.4069869034d0 0d0 -0.1281454481d0 0.6419895885d0 0.7559286424d0
                  0d0 -0.6337388239d0 -0.6785471501d0 -0.3714146849d0 0d0 0.5565051903d0
                  -0.2168887573d0 -0.8020356851d0 0d0 0.5791554484d0 0.7244372011d0 -0.3738578718d0
                  0d0 0.1175779076d0 -0.7096451073d0 0.6946792478d0 0d0 -0.6134619607d0
                  0.1323631078d0 0.7785527795d0 0d0 0.6984635305d0 -0.02980516237d0 -0.715024719d0
                  0d0 0.8318082963d0 -0.3930171956d0 0.3919597455d0 0d0 0.1469576422d0
                  0.05541651717d0 -0.9875892167d0 0d0 0.708868575d0 -0.2690503865d0 0.6520101478d0
                  0d0 0.2726053183d0 0.67369766d0 -0.68688995d0 0d0 -0.6591295371d0 0.3035458599d0
                  -0.6880466294d0 0d0 0.4815131379d0 -0.7528270071d0 0.4487723203d0 0d0
                  0.9430009463d0 0.1675647412d0 -0.2875261255d0 0d0 0.434802957d0 0.7695304522d0
                  -0.4677277752d0 0d0 0.3931996188d0 0.594473625d0 0.7014236729d0 0d0 0.7254336655d0
                  0.603925654d0 0.3301814672d0 0d0 0.7590235227d0 -0.6506083235d0 0.02433313207d0
                  0d0 -0.8552768592d0 -0.3430042733d0 0.3883935666d0 0d0 -0.6139746835d0
                  0.6981725247d0 0.3682257648d0 0d0 -0.7465905486d0 -0.5752009504d0 0.3342849376d0
                  0d0 0.5730065677d0 0.810555537d0 -0.1210916791d0 0d0 -0.9225877367d0
                  -0.3475211012d0 -0.167514036d0 0d0 0.7105816789d0 -0.4719692027d0 -0.5218416899d0
                  0d0 -0.08564609717d0 0.3583001386d0 0.929669703d0 0d0 -0.8279697606d0
                  -0.2043157126d0 0.5222271202d0 0d0 0.427944023d0 0.278165994d0 0.8599346446d0 0d0
                  0.5399079671d0 -0.7857120652d0 -0.3019204161d0 0d0 0.5678404253d0 -0.5495413974d0
                  -0.6128307303d0 0d0 -0.9896071041d0 0.1365639107d0 0.04503418428d0 0d0
                  -0.6154342638d0 -0.6440875597d0 0.4543037336d0 0d0 0.1074204368d0 0.7946340692d0
                  0.5975094525d0 0d0 -0.3595449969d0 -0.8885529948d0 0.28495784d0 0d0
                  -0.2180405296d0 0.1529888965d0 0.9638738118d0 0d0 -0.7277432317d0 -0.6164050508d0
                  0.3007234646d0 0d0 0.7249729114d0 -0.00669719484d0 0.6887448187d0 0d0
                  -0.5553659455d0 0.5336586252d0 0.6377908264d0 0d0 0.5137558015d0 0.7976208196d0
                  -0.3160000073d0 0d0 0.3794024848d0 0.9245608561d0 -0.03522751494d0 0d0
                  0.8229248658d0 0.2745365933d0 -0.4974176556d0 0d0 -0.5404114394d0 0.6091141441d0
                  0.5804613989d0 0d0 0.8036581901d0 -0.2703029469d0 0.5301601931d0 0d0
                  0.6044318879d0 0.6832968393d0 0.4095943388d0 0d0 0.06389988817d0 0.9658208605d0
                  -0.2512108074d0 0d0 0.1087113286d0 0.7402471173d0 0.6634877936d0 0d0
                  -0.713427712d0 -0.6926784018d0 0.1059128479d0 0d0 0.6458897819d0 0.5724548511d0
                  -0.5050958653d0 0d0 -0.6553931414d0 0.7381471625d0 0.159995615d0 0d0
                  0.3910961323d0 0.9188871375d0 -0.05186755998d0 0d0 -0.4879022471d0
                  -0.5904376907d0 0.6429111375d0 0d0 0.6014790094d0 0.7707441366d0 -0.2101820095d0
                  0d0 -0.5677173047d0 0.7511360995d0 0.3368851762d0 0d0 0.7858573506d0 0.226674665d0
                  0.5753666838d0 0d0 -0.4520345543d0 -0.604222686d0 -0.6561857263d0 0d0
                  0.002272116345d0 0.4132844051d0 -0.9105991643d0 0d0 -0.5815751419d0
                  -0.5162925989d0 0.6286591339d0 0d0 0.03703704785d0 0.8273785755d0 0.5604221175d0
                  0d0 -0.5119692504d0 0.7953543429d0 -0.3244980058d0 0d0 -0.2682417366d0
                  -0.9572290247d0 -0.1084387619d0 0d0 0.2322482736d0 -0.9679131102d0
                  -0.09594243324d0 0d0 0.3554328906d0 -0.8881505545d0 0.2913006227d0 0d0
                  0.7346520519d0 -0.4371373164d0 0.5188422971d0 0d0 0.9985120116d0 0.04659011161d0
                  -0.02833944577d0 0d0 -0.3727687496d0 -0.9082481361d0 0.1900757285d0 0d0
                  0.91737377d0 -0.3483642108d0 0.1925298489d0 0d0 0.2714911074d0 0.4147529736d0
                  -0.8684886582d0 0d0 0.5131763485d0 -0.7116334161d0 0.4798207128d0 0d0
                  -0.8737353606d0 0.18886992d0 -0.4482350644d0 0d0 0.8460043821d0 -0.3725217914d0
                  0.3814499973d0 0d0 0.8978727456d0 -0.1780209141d0 -0.4026575304d0 0d0
                  0.2178065647d0 -0.9698322841d0 -0.1094789531d0 0d0 -0.1518031304d0 -0.7788918132d0
                  -0.6085091231d0 0d0 0.2600384876d0 -0.4755398075d0 -0.8403819825d0 0d0
                  0.572313509d0 -0.7474340931d0 -0.3373418503d0 0d0 -0.7174141009d0 0.1699017182d0
                  -0.6756111411d0 0d0 -0.684180784d0 0.02145707593d0 -0.7289967412d0 0d0
                  -0.2007447902d0 0.06555605789d0 -0.9774476623d0 0d0 -0.1148803697d0
                  -0.8044887315d0 0.5827524187d0 0d0 -0.7870349638d0 0.03447489231d0 0.6159443543d0
                  0d0 -0.2015596421d0 0.6859872284d0 0.6991389226d0 0d0 -0.08581082512d0
                  -0.10920836d0 -0.9903080513d0 0d0 0.5532693395d0 0.7325250401d0 -0.396610771d0 0d0
                  0.1842489331d0 -0.9777375055d0 -0.1004076743d0 0d0 0.0775473789d0 -0.9111505856d0
                  0.4047110257d0 0d0 0.1399838409d0 0.7601631212d0 -0.6344734459d0 0d0
                  0.4484419361d0 -0.845289248d0 0.2904925424d0 0d0)))
      (make-array 1024 :element-type 'int::f50 :initial-contents data))
  :test #'equalp)

(defstruct (cellular-3d
            (:include int::sampler)
            (:constructor %cellular-3d)
            (:conc-name "")
            (:predicate nil)
            (:copier nil))
  (seed 0 :type u:ub32)
  (distance-method :euclidean :type (member :euclidean :euclidean-squared :manhattan :hybrid))
  (output-type :min :type (member :value :min :max :+ :- :* :/))
  (jitter 1d0 :type u:f64))

(defun cellular-3d (&key seed (distance-method :euclidean) (output-type :min) (jitter 1d0))
  (u:mvlet ((rng seed (int::make-rng seed)))
    (%cellular-3d :rng rng
                  :seed seed
                  :distance-method distance-method
                  :output-type output-type
                  :jitter jitter)))

(defmacro with-distance (distance-method)
  `(dotimes (xi 3)
     (let ((yp yp-base))
       (dotimes (yi 3)
         (let ((zp zp-base))
           (dotimes (zi 3)
             (let* ((hash (in-range (* (logxor seed xp yp zp) 668265261)))
                    (index (logand hash 1023))
                    (vx (+ (- (+ xr xi) x) (* (aref +random+ index) jitter)))
                    (vy (+ (- (+ yr yi) y) (* (aref +random+ (logior index 1)) jitter)))
                    (vz (+ (- (+ zr zi) z) (* (aref +random+ (logior index 2)) jitter)))
                    (d ,(ecase distance-method
                          (:euclidean
                           `(+ (expt vx 2) (expt vy 2) (expt vz 2)))
                          (:manhattan
                           `(+ (abs vx) (abs vy) (abs vz)))
                          (:hybrid
                           `(+ (abs vx) (abs vy) (abs vz) (expt vx 2) (expt vy 2) (expt vz 2))))))
               (setf max (max (min max d) min)
                     zp (in-range (+ zp int::+prime-z+)))
               (when (< d min)
                 (setf min d
                       closest-hash hash))))
           (setf yp (in-range (+ yp int::+prime-y+)))))
       (setf xp (in-range (+ xp int::+prime-x+))))))

(defmethod int::sample ((sampler cellular-3d) x &optional (y 0d0) (z 0d0) (w 0d0))
  (declare (ignore w)
           (optimize speed)
           (int::f50 x y z w))
  (flet ((in-range (x)
           (logand x #.(1- (expt 2 32)))))
    (declare (inline in-range))
    (let* ((seed (seed sampler))
           (distance-method (distance-method sampler))
           (output-type (output-type sampler))
           (xr (1- (round x)))
           (yr (1- (round y)))
           (zr (1- (round z)))
           (min most-positive-double-float)
           (max most-positive-double-float)
           (closest-hash 0)
           (jitter (* 0.39614353 (jitter sampler)))
           (xp (in-range (* xr int::+prime-x+)))
           (yp-base (in-range (* yr int::+prime-y+)))
           (zp-base (in-range (* zr int::+prime-z+))))
      (declare (u:f64 min max))
      (ecase distance-method
        ((:euclidean :euclidean-squared)
         (with-distance :euclidean))
        (:manhattan
         (with-distance :manhattan))
        (:hybrid
         (with-distance :hybrid)))
      (when (and (eq distance-method :euclidean)
                 (not (eq output-type :value)))
        (setf min (sqrt min))
        (unless (eq output-type :min)
          (setf max (sqrt (abs max)))))
      ;; TODO: The domain remapping here is kind of hacky and not exact, due to the algorithm. It
      ;; may be best to rewrite cellular noise at some point or use a solver to figure out the
      ;; actual domain.
      (ecase output-type
        (:value (float (1- (* closest-hash (/ 2147483648.0))) 1f0))
        (:min (float (1- (* min 2)) 1f0))
        (:max (float (1- (* max 2)) 1f0))
        (:+ (float (1- (+ min max)) 1f0))
        (:- (float (1- (* (- max min) 2)) 1f0))
        (:* (float (1- (* min max 2)) 1f0))
        (:/ (float (1- (/ min max 0.5)) 1f0))))))
