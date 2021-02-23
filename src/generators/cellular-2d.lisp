(in-package #:cl-user)

(defpackage #:coherent-noise.generators.cellular-2d
  (:local-nicknames
   (#:gen #:coherent-noise.generators)
   (#:int #:coherent-noise.internal)
   (#:rng #:seedable-rng)
   (#:u #:golden-utils))
  (:use #:cl))

(in-package #:coherent-noise.generators.cellular-2d)

(u:define-constant +random+
    (let ((data #(-0.2700222198d0 -0.9628540911d0 0.3863092627d0 -0.9223693152d0 0.04444859006d0
                  -0.999011673d0 -0.5992523158d0 -0.8005602176d0 -0.7819280288d0 0.6233687174d0
                  0.9464672271d0 0.3227999196d0 -0.6514146797d0 0.7587218957d0 0.9378472289d0
                  0.347048376d0 -0.8497875957d0 -0.5271252623d0 -0.879042592d0 0.4767432447d0
                  0.892300288d0 -0.4514423508d0 -0.379844434d0 -0.9250503802d0 -0.9951650832d0
                  0.0982163789d0 0.7724397808d0 0.6350880136d0 0.7573283322d0 -0.6530343002d0
                  -0.9928004525d0 -0.119780055d0 -0.0532665713d0 0.9985803285d0 0.9754253726d0
                  -0.2203300762d0 -0.7665018163d0 0.6422421394d0 0.991636706d0 0.1290606184d0
                  -0.994696838d0 0.1028503788d0 -0.5379205513d0 -0.84299554d0 0.5022815471d0
                  -0.8647041387d0 0.4559821461d0 -0.8899889226d0 0.8659131224d0 -0.5001944266d0
                  0.0879458407d0 -0.9961252577d0 -0.5051684983d0 0.8630207346d0 0.7753185226d0
                  -0.6315704146d0 -0.6921944612d0 0.7217110418d0 -0.5191659449d0 -0.8546734591d0
                  0.8978622882d0 -0.4402764035d0 -0.1706774107d0 0.9853269617d0 -0.9353430106d0
                  -0.3537420705d0 -0.9992404798d0 0.03896746794d0 -0.2882064021d0 0.9575683108d0
                  -0.9663811329d0 0.2571137995d0 -0.8759714238d0 -0.4823630009d0 -0.8303123018d0
                  -0.5572983775d0 0.05110133755d0 -0.9986934731d0 -0.8558373281d0 -0.5172450752d0
                  0.09887025282d0 0.9951003332d0 0.9189016087d0 0.3944867976d0 -0.2439375892d0
                  -0.9697909324d0 -0.8121409387d0 -0.5834613061d0 -0.9910431363d0 0.1335421355d0
                  0.8492423985d0 -0.5280031709d0 -0.9717838994d0 -0.2358729591d0 0.9949457207d0
                  0.1004142068d0 0.6241065508d0 -0.7813392434d0 0.662910307d0 0.7486988212d0
                  -0.7197418176d0 0.6942418282d0 -0.8143370775d0 -0.5803922158d0 0.104521054d0
                  -0.9945226741d0 -0.1065926113d0 -0.9943027784d0 0.445799684d0 -0.8951327509d0
                  0.105547406d0 0.9944142724d0 -0.992790267d0 0.1198644477d0 -0.8334366408d0
                  0.552615025d0 0.9115561563d0 -0.4111755999d0 0.8285544909d0 -0.5599084351d0
                  0.7217097654d0 -0.6921957921d0 0.4940492677d0 -0.8694339084d0 -0.3652321272d0
                  0.9309164803d0 -0.9696606758d0 0.2444548501d0 0.08925509731d0 -0.996008799d0
                  0.5354071276d0 -0.8445941083d0 -0.1053576186d0 0.9944343981d0 -0.9890284586d0
                  0.1477251101d0 0.004856104961d0 0.9999882091d0 0.9885598478d0 0.1508291331d0
                  0.9286129562d0 -0.3710498316d0 -0.5832393863d0 -0.8123003252d0 0.3015207509d0
                  0.9534596146d0 0.9575110528d0 0.2883965738d0 0.9715802154d0 -0.2367105511d0
                  0.229981792d0 0.9731949318d0 0.955763816d0 -0.2941352207d0 0.740956116d0
                  0.6715534485d0 -0.9971513787d0 -0.07542630764d0 0.6905710663d0 -0.7232645452d0
                  -0.290713703d0 -0.9568100872d0 0.5912777791d0 -0.8064679708d0 -0.9454592212d0
                  -0.325740481d0 0.6664455681d0 0.74555369d0 0.6236134912d0 0.7817328275d0
                  0.9126993851d0 -0.4086316587d0 -0.8191762011d0 0.5735419353d0 0.8812745759d0
                  -0.4726046147d0 0.9953313627d0 0.09651672651d0 0.9855650846d0 -0.1692969699d0
                  -0.8495980887d0 0.5274306472d0 0.6174853946d0 -0.7865823463d0 0.8508156371d0
                  0.52546432d0 0.9985032451d0 -0.05469249926d0 0.1971371563d0 -0.9803759185d0
                  0.6607855748d0 -0.7505747292d0 -0.03097494063d0 0.9995201614d0 -0.6731660801d0
                  0.739491331d0 -0.7195018362d0 -0.6944905383d0 0.9727511689d0 0.2318515979d0
                  0.9997059088d0 -0.0242506907d0 0.4421787429d0 -0.8969269532d0 0.9981350961d0
                  -0.061043673d0 -0.9173660799d0 -0.3980445648d0 -0.8150056635d0 -0.5794529907d0
                  -0.8789331304d0 0.4769450202d0 0.0158605829d0 0.999874213d0 -0.8095464474d0
                  0.5870558317d0 -0.9165898907d0 -0.3998286786d0 -0.8023542565d0 0.5968480938d0
                  -0.5176737917d0 0.8555780767d0 -0.8154407307d0 -0.5788405779d0 0.4022010347d0
                  -0.9155513791d0 -0.9052556868d0 -0.4248672045d0 0.7317445619d0 0.6815789728d0
                  -0.5647632201d0 -0.8252529947d0 -0.8403276335d0 -0.5420788397d0 -0.9314281527d0
                  0.363925262d0 0.5238198472d0 0.8518290719d0 0.7432803869d0 -0.6689800195d0
                  -0.985371561d0 -0.1704197369d0 0.4601468731d0 0.88784281d0 0.825855404d0
                  0.5638819483d0 0.6182366099d0 0.7859920446d0 0.8331502863d0 -0.553046653d0
                  0.1500307506d0 0.9886813308d0 -0.662330369d0 -0.7492119075d0 -0.668598664d0
                  0.743623444d0 0.7025606278d0 0.7116238924d0 -0.5419389763d0 -0.8404178401d0
                  -0.3388616456d0 0.9408362159d0 0.8331530315d0 0.5530425174d0 -0.2989720662d0
                  -0.9542618632d0 0.2638522993d0 0.9645630949d0 0.124108739d0 -0.9922686234d0
                  -0.7282649308d0 -0.6852956957d0 0.6962500149d0 0.7177993569d0 -0.9183535368d0
                  0.3957610156d0 -0.6326102274d0 -0.7744703352d0 -0.9331891859d0 -0.359385508d0
                  -0.1153779357d0 -0.9933216659d0 0.9514974788d0 -0.3076565421d0 -0.08987977445d0
                  -0.9959526224d0 0.6678496916d0 0.7442961705d0 0.7952400393d0 -0.6062947138d0
                  -0.6462007402d0 -0.7631674805d0 -0.2733598753d0 0.9619118351d0 0.9669590226d0
                  -0.254931851d0 -0.9792894595d0 0.2024651934d0 -0.5369502995d0 -0.8436138784d0
                  -0.270036471d0 -0.9628500944d0 -0.6400277131d0 0.7683518247d0 -0.7854537493d0
                  -0.6189203566d0 0.06005905383d0 -0.9981948257d0 -0.02455770378d0 0.9996984141d0
                  -0.65983623d0 0.751409442d0 -0.6253894466d0 -0.7803127835d0 -0.6210408851d0
                  -0.7837781695d0 0.8348888491d0 0.5504185768d0 -0.1592275245d0 0.9872419133d0
                  0.8367622488d0 0.5475663786d0 -0.8675753916d0 -0.4973056806d0 -0.2022662628d0
                  -0.9793305667d0 0.9399189937d0 0.3413975472d0 0.9877404807d0 -0.1561049093d0
                  -0.9034455656d0 0.4287028224d0 0.1269804218d0 -0.9919052235d0 -0.3819600854d0
                  0.924178821d0 0.9754625894d0 0.2201652486d0 -0.3204015856d0 -0.9472818081d0
                  -0.9874760884d0 0.1577687387d0 0.02535348474d0 -0.9996785487d0 0.4835130794d0
                  -0.8753371362d0 -0.2850799925d0 -0.9585037287d0 -0.06805516006d0 -0.99768156d0
                  -0.7885244045d0 -0.6150034663d0 0.3185392127d0 -0.9479096845d0 0.8880043089d0
                  0.4598351306d0 0.6476921488d0 -0.7619021462d0 0.9820241299d0 0.1887554194d0
                  0.9357275128d0 -0.3527237187d0 -0.8894895414d0 0.4569555293d0 0.7922791302d0
                  0.6101588153d0 0.7483818261d0 0.6632681526d0 -0.7288929755d0 -0.6846276581d0
                  0.8729032783d0 -0.4878932944d0 0.8288345784d0 0.5594937369d0 0.08074567077d0
                  0.9967347374d0 0.9799148216d0 -0.1994165048d0 -0.580730673d0 -0.8140957471d0
                  -0.4700049791d0 -0.8826637636d0 0.2409492979d0 0.9705377045d0 0.9437816757d0
                  -0.3305694308d0 -0.8927998638d0 -0.4504535528d0 -0.8069622304d0 0.5906030467d0
                  0.06258973166d0 0.9980393407d0 -0.9312597469d0 0.3643559849d0 0.5777449785d0
                  0.8162173362d0 -0.3360095855d0 -0.941858566d0 0.697932075d0 -0.7161639607d0
                  -0.002008157227d0 -0.9999979837d0 -0.1827294312d0 -0.9831632392d0 -0.6523911722d0
                  0.7578824173d0 -0.4302626911d0 -0.9027037258d0 -0.9985126289d0 -0.05452091251d0
                  -0.01028102172d0 -0.9999471489d0 -0.4946071129d0 0.8691166802d0 -0.2999350194d0
                  0.9539596344d0 0.8165471961d0 0.5772786819d0 0.2697460475d0 0.962931498d0
                  -0.7306287391d0 -0.6827749597d0 -0.7590952064d0 -0.6509796216d0 -0.907053853d0
                  0.4210146171d0 -0.5104861064d0 -0.8598860013d0 0.8613350597d0 0.5080373165d0
                  0.5007881595d0 -0.8655698812d0 -0.654158152d0 0.7563577938d0 -0.8382755311d0
                  -0.545246856d0 0.6940070834d0 0.7199681717d0 0.06950936031d0 0.9975812994d0
                  0.1702942185d0 -0.9853932612d0 0.2695973274d0 0.9629731466d0 0.5519612192d0
                  -0.8338697815d0 0.225657487d0 -0.9742067022d0 0.4215262855d0 -0.9068161835d0
                  0.4881873305d0 -0.8727388672d0 -0.3683854996d0 -0.9296731273d0 -0.9825390578d0
                  0.1860564427d0 0.81256471d0 0.5828709909d0 0.3196460933d0 -0.9475370046d0
                  0.9570913859d0 0.2897862643d0 -0.6876655497d0 -0.7260276109d0 -0.9988770922d0
                  -0.047376731d0 -0.1250179027d0 0.992154486d0 -0.8280133617d0 0.560708367d0
                  0.9324863769d0 -0.3612051451d0 0.6394653183d0 0.7688199442d0 -0.01623847064d0
                  -0.9998681473d0 -0.9955014666d0 -0.09474613458d0 -0.81453315d0 0.580117012d0
                  0.4037327978d0 -0.9148769469d0 0.9944263371d0 0.1054336766d0 -0.1624711654d0
                  0.9867132919d0 -0.9949487814d0 -0.100383875d0 -0.6995302564d0 0.7146029809d0
                  0.5263414922d0 -0.85027327d0 -0.5395221479d0 0.841971408d0 0.6579370318d0
                  0.7530729462d0 0.01426758847d0 -0.9998982128d0 -0.6734383991d0 0.7392433447d0
                  0.639412098d0 -0.7688642071d0 0.9211571421d0 0.3891908523d0 -0.146637214d0
                  -0.9891903394d0 -0.782318098d0 0.6228791163d0 -0.5039610839d0 -0.8637263605d0
                  -0.7743120191d0 -0.6328039957d0)))
      (make-array 512 :element-type 'int::f50 :initial-contents data))
  :test #'equalp)

(defstruct (cellular-2d
            (:include int:sampler)
            (:conc-name "")
            (:predicate nil)
            (:copier nil))
  (seed 0 :type u:ub32)
  (distance-method :euclidean
   :type (member :manhattan :euclidean :euclidean-squared :chebyshev :minkowski4))
  (output-type :f1 :type (member :value :f1 :f2 :f1+f2 :f2-f1 :f1*f2 :f1/f2))
  (jitter 1d0 :type u:f64))

(defun gen:cellular-2d (&key seed (distance-method :euclidean) (output-type :f1) (jitter 1d0))
  (unless (member distance-method '(:manhattan :euclidean :euclidean-squared :chevyshev
                                    :minkowski4))
    (error 'int:invalid-cellular-distance-method
           :sampler-type 'cellular-2d
           :distance-method distance-method
           :valid-distance-methods '(:manhattan :euclidean :euclidean-squared :chevyshev
                                     :minkowski4)))
  (unless (member output-type '(:value :f1 :f2 :f1+f2 :f2-f1 :f1*f2 :f1/f2))
    (error 'int:invalid-cellular-output-type
           :sampler-type 'cellular-2d
           :output-type output-type
           :valid-output-types '(:value :f1 :f2 :f1+f2 :f2-f1 :f1*f2 :f1/f2)))
  (unless (realp jitter)
    (error 'int:invalid-real-argument
           :sampler-type 'cellular-2d
           :argument :jitter
           :value jitter))
  (u:mvlet ((rng seed (int::make-rng seed)))
    (make-cellular-2d :rng rng
                      :seed seed
                      :distance-method distance-method
                      :output-type output-type
                      :jitter (float jitter 1d0))))

(defmethod int:sample ((sampler cellular-2d) x &optional (y 0d0) (z 0d0) (w 0d0))
  (declare (ignore z w)
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
           (min most-positive-double-float)
           (max most-positive-double-float)
           (closest-hash 0)
           (jitter (* 0.43701595 (jitter sampler)))
           (xp (in-range (* xr int::+prime-x+)))
           (yp-base (in-range (* yr int::+prime-y+))))
      (declare (u:f64 min max))
      (dotimes (xi 3)
        (let ((xri (- (+ xr xi) x))
              (yp yp-base))
          (dotimes (yi 3)
            (let* ((hash (in-range (* (logxor seed xp yp) 668265261)))
                   (index (logand hash 511))
                   (vx (+ xri (* (aref +random+ index) jitter)))
                   (vy (+ (- (+ yr yi) y) (* (aref +random+ (logior index 1)) jitter)))
                   (d (ecase distance-method
                        (:manhattan
                         (+ (abs vx) (abs vy)))
                        (:euclidean
                         (sqrt (+ (* vx vx) (* vy vy))))
                        (:euclidean-squared
                         (+ (* vx vx) (* vy vy)))
                        (:chebyshev
                         (max (abs vx) (abs vy)))
                        (:minkowski4
                         (the (double-float 0d0)
                              (expt (the (double-float 0d0)
                                         (+ (* vx vx vx vx)
                                            (* vy vy vy vy)))
                                    0.25d0))))))
              (setf max (max (min max d) min)
                    yp (in-range (+ yp int::+prime-y+)))
              (when (< d min)
                (setf min d
                      closest-hash hash))))
          (setf xp (in-range (+ xp int::+prime-x+)))))
      (ecase output-type
        (:value (float (1- (* closest-hash (/ 2147483648.0))) 1f0))
        (:f1 (float (1- min) 1f0))
        (:f2 (float (1- max) 1f0))
        (:f1+f2 (float (1- (* (+ min max) 0.5)) 1f0))
        (:f2-f1 (float (- max min 1) 1f0))
        (:f1*f2 (float (1- (* min max 0.5)) 1f0))
        (:f1/f2 (float (1- (/ min max)) 1f0))))))
