From: Pedro Teixeira <finas@aeiou.pt>
Subject: Re: strange problem with raid6 read errors on active non-degraded
 array
Date: Wed, 02 Jul 2014 12:54:34 +0100
Message-ID: <20140702125434.Horde.abbwKfYRo99Ts-L6UvsCEIA@webmail.aeiou.pt>
References: <20140702103241.Horde.iempNvYRo99Ts9G5Op7ionA@webmail.aeiou.pt>
 <20140702204502.6b538fa8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed	DelSp=Yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140702204502.6b538fa8@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

cpu is a phenom x6, 8gb ram. controller is LSI 9201-i16. hdd's are =20
seagate sshd ST1000DX001.

So I run the "dd if=3D/dev/md0 of=3D/dev/null=C2=A0 bs=3D4096" and it f=
ailed on =20
alot of places. I had to restart the command several times with the =20
skip parameter set to a couple of blocks after the last block error. =20
It run for about 1.5TB of the total 13TB of the volume.
The md volume didn't drop any drive when running this.

dmesg showed:

[ 1678.478156] Buffer I/O error on device md0, logical block 196012546
[ 1678.478314] Buffer I/O error on device md0, logical block 196012547
[ 1678.478462] Buffer I/O error on device md0, logical block 196012548
[ 1678.478737] Buffer I/O error on device md0, logical block 196012549
[ 1678.479077] Buffer I/O error on device md0, logical block 196012550
[ 1678.479415] Buffer I/O error on device md0, logical block 196012551
[ 1678.479754] Buffer I/O error on device md0, logical block 196012552
[ 1678.480082] Buffer I/O error on device md0, logical block 196012553
[ 1678.480679] Buffer I/O error on device md0, logical block 196012630
[ 1678.480811] Buffer I/O error on device md0, logical block 196012758
[ 2305.139382] quiet_error: 369 callbacks suppressed
[ 2305.139385] Buffer I/O error on device md0, logical block 196012759
[ 2310.592687] Buffer I/O error on device md0, logical block 196012760
[ 2313.135470] Buffer I/O error on device md0, logical block 196012761
[ 2315.971196] Buffer I/O error on device md0, logical block 196012762
[ 2319.013647] Buffer I/O error on device md0, logical block 196012763
[ 2321.125008] Buffer I/O error on device md0, logical block 196012764
[ 2323.774654] Buffer I/O error on device md0, logical block 196012765
[ 2327.439527] Buffer I/O error on device md0, logical block 196012766
[ 2329.399068] Buffer I/O error on device md0, logical block 196012767
[ 2331.389823] Buffer I/O error on device md0, logical block 196012768
[ 2334.166786] Buffer I/O error on device md0, logical block 196012769
[ 2337.817145] Buffer I/O error on device md0, logical block 196012770
[ 2340.713005] Buffer I/O error on device md0, logical block 196012771
[ 2342.594948] Buffer I/O error on device md0, logical block 196012772
[ 2344.678599] Buffer I/O error on device md0, logical block 196012773
[ 2347.150423] Buffer I/O error on device md0, logical block 196012774
[ 2349.433777] Buffer I/O error on device md0, logical block 196012775
[ 2351.559728] Buffer I/O error on device md0, logical block 196012776
[ 2353.650886] Buffer I/O error on device md0, logical block 196012777
[ 2385.719365] Buffer I/O error on device md0, logical block 196012778
[ 2388.937566] Buffer I/O error on device md0, logical block 196012779
[ 2391.831046] Buffer I/O error on device md0, logical block 196012780
[ 2393.971170] Buffer I/O error on device md0, logical block 196012781
[ 2396.118172] Buffer I/O error on device md0, logical block 196012782
[ 2399.717491] Buffer I/O error on device md0, logical block 196012783
[ 2401.913373] Buffer I/O error on device md0, logical block 196012784
[ 2403.892253] Buffer I/O error on device md0, logical block 196012785
[ 2405.796383] Buffer I/O error on device md0, logical block 196012786
[ 2408.171017] Buffer I/O error on device md0, logical block 196012787
[ 2410.233107] Buffer I/O error on device md0, logical block 196012788
[ 2413.184341] Buffer I/O error on device md0, logical block 196012789
[ 2416.396825] Buffer I/O error on device md0, logical block 196012790
[ 2420.734772] Buffer I/O error on device md0, logical block 196012890
[ 2426.320297] Buffer I/O error on device md0, logical block 196013570
[ 2426.320397] Buffer I/O error on device md0, logical block 196013571
[ 2426.320504] Buffer I/O error on device md0, logical block 196013572
[ 2426.320595] Buffer I/O error on device md0, logical block 196013573
[ 2426.320686] Buffer I/O error on device md0, logical block 196013574
[ 2426.320778] Buffer I/O error on device md0, logical block 196013575
[ 2426.320877] Buffer I/O error on device md0, logical block 196013576
[ 2426.321024] Buffer I/O error on device md0, logical block 196013577
[ 2426.321193] Buffer I/O error on device md0, logical block 196013578
[ 2436.240507] quiet_error: 119 callbacks suppressed
[ 2436.240509] Buffer I/O error on device md0, logical block 196012900
[ 2440.078873] Buffer I/O error on device md0, logical block 196012910
[ 2442.323624] Buffer I/O error on device md0, logical block 196012920
[ 2445.852897] Buffer I/O error on device md0, logical block 196013570
[ 2454.009848] Buffer I/O error on device md0, logical block 196013570
[ 2456.810436] Buffer I/O error on device md0, logical block 196013570
[ 2461.672818] Buffer I/O error on device md0, logical block 196014336
[ 2461.672901] Buffer I/O error on device md0, logical block 196014464
[ 2461.672985] Buffer I/O error on device md0, logical block 196014337
[ 2461.673109] Buffer I/O error on device md0, logical block 196014465
[ 2461.695280] Buffer I/O error on device md0, logical block 196014592
[ 2461.695371] Buffer I/O error on device md0, logical block 196014720
[ 2461.695458] Buffer I/O error on device md0, logical block 196014593
[ 2461.695548] Buffer I/O error on device md0, logical block 196014721
[ 2461.695633] Buffer I/O error on device md0, logical block 196014336
[ 2465.937036] Buffer I/O error on device md0, logical block 196125442
[ 2538.797979] quiet_error: 252 callbacks suppressed
[ 2538.797982] Buffer I/O error on device md0, logical block 217780096
[ 2538.798084] Buffer I/O error on device md0, logical block 217780097
[ 2538.798163] Buffer I/O error on device md0, logical block 217780098
[ 2538.798240] Buffer I/O error on device md0, logical block 217780099
[ 2538.798321] Buffer I/O error on device md0, logical block 217780100
[ 2538.798404] Buffer I/O error on device md0, logical block 217780101
[ 2538.798486] Buffer I/O error on device md0, logical block 217780102
[ 2538.798569] Buffer I/O error on device md0, logical block 217780103
[ 2538.798681] Buffer I/O error on device md0, logical block 217780104
[ 2538.798812] Buffer I/O error on device md0, logical block 217780105
[ 2582.229715] quiet_error: 607 callbacks suppressed
[ 2582.229717] Buffer I/O error on device md0, logical block 217780106
[ 2584.667289] Buffer I/O error on device md0, logical block 217780107
[ 2590.211304] Buffer I/O error on device md0, logical block 228358304
[ 2590.211388] Buffer I/O error on device md0, logical block 228358432
[ 2590.211467] Buffer I/O error on device md0, logical block 228358560
[ 2590.211555] Buffer I/O error on device md0, logical block 228358305
[ 2590.211628] Buffer I/O error on device md0, logical block 228358433
[ 2590.211712] Buffer I/O error on device md0, logical block 228358561
[ 2590.211792] Buffer I/O error on device md0, logical block 228358306
[ 2590.211871] Buffer I/O error on device md0, logical block 228358434
[ 2590.211945] Buffer I/O error on device md0, logical block 228358562
[ 2590.212025] Buffer I/O error on device md0, logical block 228358307
[ 2652.455446] quiet_error: 375 callbacks suppressed
[ 2652.455449] Buffer I/O error on device md0, logical block 260370751
[ 2652.455541] Buffer I/O error on device md0, logical block 260370752
[ 2652.455618] Buffer I/O error on device md0, logical block 260370753
[ 2652.455694] Buffer I/O error on device md0, logical block 260370754
[ 2652.455779] Buffer I/O error on device md0, logical block 260370755
[ 2652.455853] Buffer I/O error on device md0, logical block 260370756
[ 2652.455930] Buffer I/O error on device md0, logical block 260370757
[ 2652.456003] Buffer I/O error on device md0, logical block 260370758
[ 2652.456090] Buffer I/O error on device md0, logical block 260370759
[ 2652.456166] Buffer I/O error on device md0, logical block 260370760
[ 2695.663954] quiet_error: 56 callbacks suppressed
[ 2695.663957] Buffer I/O error on device md0, logical block 262508480
[ 2695.664039] Buffer I/O error on device md0, logical block 262508608
[ 2695.664113] Buffer I/O error on device md0, logical block 262508736
[ 2695.664197] Buffer I/O error on device md0, logical block 262508481
[ 2695.664264] Buffer I/O error on device md0, logical block 262508609
[ 2695.664344] Buffer I/O error on device md0, logical block 262508737
[ 2695.664417] Buffer I/O error on device md0, logical block 262508482
[ 2695.664489] Buffer I/O error on device md0, logical block 262508610
[ 2695.664557] Buffer I/O error on device md0, logical block 262508738
[ 2695.664632] Buffer I/O error on device md0, logical block 262508483
[ 2980.623591] quiet_error: 312 callbacks suppressed
[ 2980.623595] Buffer I/O error on device md0, logical block 370515910
[ 2980.623676] Buffer I/O error on device md0, logical block 370516038
[ 2980.623761] Buffer I/O error on device md0, logical block 370515911
[ 2980.623828] Buffer I/O error on device md0, logical block 370516039
[ 2980.623903] Buffer I/O error on device md0, logical block 370515912
[ 2980.623970] Buffer I/O error on device md0, logical block 370516040
[ 2980.624046] Buffer I/O error on device md0, logical block 370515913
[ 2980.624119] Buffer I/O error on device md0, logical block 370516041
[ 2980.624191] Buffer I/O error on device md0, logical block 370515914
[ 2980.624262] Buffer I/O error on device md0, logical block 370516042
[ 3005.209442] quiet_error: 281 callbacks suppressed
[ 3005.209444] Buffer I/O error on device md0, logical block 370516043
[ 3010.575774] Buffer I/O error on device md0, logical block 372582176
[ 3010.575854] Buffer I/O error on device md0, logical block 372582304
[ 3010.575927] Buffer I/O error on device md0, logical block 372582432
[ 3010.576004] Buffer I/O error on device md0, logical block 372582177
[ 3010.576082] Buffer I/O error on device md0, logical block 372582305
[ 3010.576147] Buffer I/O error on device md0, logical block 372582433
[ 3010.576232] Buffer I/O error on device md0, logical block 372582178
[ 3010.576298] Buffer I/O error on device md0, logical block 372582306
[ 3010.576361] Buffer I/O error on device md0, logical block 372582434
[ 3024.205000] quiet_error: 472 callbacks suppressed
[ 3024.205003] Buffer I/O error on device md0, logical block 375180000
[ 3024.205082] Buffer I/O error on device md0, logical block 375180128
[ 3024.205154] Buffer I/O error on device md0, logical block 375180256
[ 3024.205229] Buffer I/O error on device md0, logical block 375180001
[ 3024.205308] Buffer I/O error on device md0, logical block 375180129
[ 3024.205374] Buffer I/O error on device md0, logical block 375180257
[ 3024.205441] Buffer I/O error on device md0, logical block 375180002
[ 3024.205509] Buffer I/O error on device md0, logical block 375180130
[ 3024.205581] Buffer I/O error on device md0, logical block 375180258
[ 3024.205655] Buffer I/O error on device md0, logical block 375180003
[ 3182.726623] quiet_error: 183 callbacks suppressed
[ 3182.726626] Buffer I/O error on device md0, logical block 434495873
[ 3182.726708] Buffer I/O error on device md0, logical block 434495874
[ 3182.726787] Buffer I/O error on device md0, logical block 434495875
[ 3182.726857] Buffer I/O error on device md0, logical block 434495876
[ 3182.726927] Buffer I/O error on device md0, logical block 434495877
[ 3182.727036] Buffer I/O error on device md0, logical block 434495878
[ 3182.727129] Buffer I/O error on device md0, logical block 434495879
[ 3182.727210] Buffer I/O error on device md0, logical block 434495880
[ 3182.727292] Buffer I/O error on device md0, logical block 434495881
[ 3182.727374] Buffer I/O error on device md0, logical block 434495882
[ 3201.149784] quiet_error: 118 callbacks suppressed
[ 3201.149786] Buffer I/O error on device md0, logical block 434495883
[ 3243.707353] Buffer I/O error on device md0, logical block 458225568
[ 3243.707439] Buffer I/O error on device md0, logical block 458225569
[ 3243.707526] Buffer I/O error on device md0, logical block 458225570
[ 3243.707600] Buffer I/O error on device md0, logical block 458225571
[ 3243.707675] Buffer I/O error on device md0, logical block 458225572
[ 3243.707748] Buffer I/O error on device md0, logical block 458225573
[ 3243.707825] Buffer I/O error on device md0, logical block 458225574
[ 3243.707903] Buffer I/O error on device md0, logical block 458225575
[ 3243.707975] Buffer I/O error on device md0, logical block 458225576
[ 3410.602968] quiet_error: 139 callbacks suppressed
[ 3410.602971] Buffer I/O error on device md0, logical block 490875483
[ 3410.603049] Buffer I/O error on device md0, logical block 490875611
[ 3410.603126] Buffer I/O error on device md0, logical block 490875484
[ 3410.603204] Buffer I/O error on device md0, logical block 490875612
[ 3410.603279] Buffer I/O error on device md0, logical block 490875485
[ 3410.603349] Buffer I/O error on device md0, logical block 490875613
[ 3410.603424] Buffer I/O error on device md0, logical block 490875486
[ 3410.603509] Buffer I/O error on device md0, logical block 490875614
[ 3410.603592] Buffer I/O error on device md0, logical block 490875487
[ 3410.603663] Buffer I/O error on device md0, logical block 490875615


The command "mdadm --examine-badblocks /dev/sd[bcdefghijklmnopqr] >>  =20
raid.b" before and after running the "dd" command returned no changes:


Bad-blocks on /dev/sdb:
            112269328 for 512 sectors
            112269840 for 512 sectors
            112271376 for 512 sectors
            112271888 for 512 sectors
            112272400 for 512 sectors
            112272912 for 512 sectors
            112273424 for 512 sectors
            112273936 for 512 sectors
            112333840 for 512 sectors
            112334352 for 512 sectors
            112337680 for 128 sectors
            130752768 for 512 sectors
            130753280 for 512 sectors
            130755840 for 512 sectors
            130756352 for 512 sectors
            130757120 for 384 sectors
            149045752 for 512 sectors
            149046264 for 512 sectors
            212193536 for 512 sectors
            212194048 for 512 sectors
            248914952 for 512 sectors
            248915464 for 512 sectors
            262105344 for 512 sectors
            262105856 for 512 sectors
            273867480 for 512 sectors
            273867992 for 512 sectors
Bad-blocks list is empty in /dev/sdc
Bad-blocks list is empty in /dev/sdd
Bad-blocks on /dev/sde:
            114228480 for 512 sectors
            114228992 for 512 sectors
Bad-blocks on /dev/sdf:
            248545288 for 512 sectors
            248545800 for 512 sectors
            487421952 for 512 sectors
            487422464 for 512 sectors
            487422976 for 128 sectors
Bad-blocks list is empty in /dev/sdg
Bad-blocks on /dev/sdh:
            280763096 for 512 sectors
            280763608 for 512 sectors
Bad-blocks list is empty in /dev/sdi
Bad-blocks list is empty in /dev/sdj
Bad-blocks on /dev/sdk:
            124707840 for 512 sectors
            124708352 for 512 sectors
            124708864 for 512 sectors
            124709376 for 512 sectors
            124712192 for 384 sectors
            130771840 for 256 sectors
            130803968 for 512 sectors
            130804480 for 512 sectors
            130808960 for 256 sectors
            130852224 for 256 sectors
            130852608 for 256 sectors
            130853120 for 256 sectors
            130859520 for 256 sectors
            150267392 for 512 sectors
            150267904 for 512 sectors
            211985968 for 512 sectors
            211986480 for 512 sectors
            212037552 for 256 sectors
            212051504 for 512 sectors
            212052016 for 512 sectors
            213166336 for 512 sectors
            213166848 for 512 sectors
            213167360 for 512 sectors
            213167872 for 512 sectors
            213177600 for 512 sectors
            213178112 for 512 sectors
            214650624 for 512 sectors
            214651136 for 512 sectors
            249476104 for 512 sectors
            249476616 for 512 sectors
            262317312 for 512 sectors
            262317824 for 512 sectors
            262318464 for 512 sectors
            262318976 for 256 sectors
            262321408 for 512 sectors
            262321920 for 512 sectors
            714478672 for 512 sectors
            714479184 for 512 sectors
            714754128 for 512 sectors
            714754640 for 512 sectors
            714755152 for 512 sectors
            714755664 for 512 sectors
            935584432 for 512 sectors
            935584944 for 512 sectors
            940173568 for 512 sectors
            940174080 for 512 sectors
            976792224 for 512 sectors
            976792736 for 512 sectors
            976793248 for 512 sectors
            976793760 for 512 sectors
            980668064 for 512 sectors
            980668576 for 512 sectors
            980669088 for 512 sectors
            980669600 for 512 sectors
Bad-blocks on /dev/sdl:
            112269328 for 512 sectors
            112269840 for 512 sectors
            112271376 for 512 sectors
            112271376 for 512 sectors
            112271888 for 512 sectors
            112272400 for 512 sectors
            112272912 for 512 sectors
            112273424 for 512 sectors
            112273936 for 512 sectors
            112333840 for 512 sectors
            112334352 for 512 sectors
            112337680 for 128 sectors
            114228480 for 512 sectors
            114228992 for 512 sectors
            124707840 for 512 sectors
            124708352 for 512 sectors
            124708864 for 512 sectors
            124709376 for 512 sectors
            124712192 for 384 sectors
            130752768 for 512 sectors
            130753280 for 512 sectors
            130755840 for 512 sectors
            130756352 for 512 sectors
            130757120 for 384 sectors
            130771840 for 256 sectors
            130803968 for 512 sectors
            130804480 for 512 sectors
            130808960 for 256 sectors
            130852224 for 256 sectors
            130852608 for 256 sectors
            130853120 for 256 sectors
            130859520 for 256 sectors
            149045752 for 512 sectors
            149046264 for 512 sectors
            150267392 for 512 sectors
            150267904 for 512 sectors
            211985968 for 512 sectors
            211986480 for 512 sectors
            211996592 for 128 sectors
            212037552 for 256 sectors
            212051504 for 512 sectors
            212052016 for 512 sectors
            212193536 for 512 sectors
            212194048 for 512 sectors
            213166336 for 512 sectors
            213166848 for 512 sectors
            213167360 for 512 sectors
            213167872 for 512 sectors
            213177600 for 512 sectors
            213178112 for 512 sectors
            214650624 for 512 sectors
            214651136 for 512 sectors
            248545288 for 512 sectors
            248545800 for 512 sectors
            248914952 for 512 sectors
            248915464 for 512 sectors
            249476104 for 512 sectors
            249476616 for 512 sectors
            262105344 for 512 sectors
            262105856 for 512 sectors
            262317312 for 512 sectors
            262317824 for 512 sectors
            262318464 for 512 sectors
            262318976 for 256 sectors
            262321408 for 512 sectors
            262321920 for 512 sectors
            273867480 for 512 sectors
            273867992 for 512 sectors
            280763096 for 512 sectors
            280763608 for 512 sectors
            487421952 for 512 sectors
            487422464 for 512 sectors
            487422976 for 128 sectors
            714478672 for 512 sectors
            714479184 for 512 sectors
            714754128 for 512 sectors
            714754640 for 512 sectors
            714755152 for 512 sectors
            714755664 for 512 sectors
            935584432 for 512 sectors
            935584944 for 512 sectors
            940173568 for 512 sectors
            940174080 for 512 sectors
            976792224 for 512 sectors
            976792736 for 512 sectors
            976793248 for 512 sectors
            976793760 for 512 sectors
            980668064 for 512 sectors
            980668576 for 512 sectors
            980669088 for 512 sectors
            980669600 for 512 sectors
Bad-blocks on /dev/sdm:
            112269328 for 512 sectors
            112269840 for 512 sectors
            112271376 for 512 sectors
            112271888 for 512 sectors
            112272400 for 512 sectors
            112272912 for 512 sectors
            112273424 for 512 sectors
            112273936 for 512 sectors
            112333840 for 512 sectors
            112334352 for 512 sectors
            112337680 for 128 sectors
            114228480 for 512 sectors
            114228992 for 512 sectors
            124707840 for 512 sectors
       124708352 for 512 sectors
            124708864 for 512 sectors
            124709376 for 512 sectors
            124712192 for 384 sectors
            130752768 for 512 sectors
            130753280 for 512 sectors
            130755840 for 512 sectors
            130756352 for 512 sectors
            130757120 for 384 sectors
            130771840 for 256 sectors
            130803968 for 512 sectors
            130804480 for 512 sectors
            130808960 for 256 sectors
            130852224 for 256 sectors
            130852608 for 256 sectors
            130853120 for 256 sectors
            130859520 for 256 sectors
            149045752 for 512 sectors
            149046264 for 512 sectors
            150267392 for 512 sectors
            150267904 for 512 sectors
            211985968 for 512 sectors
            211986480 for 512 sectors
            211996592 for 128 sectors
            212037552 for 256 sectors
            212051504 for 512 sectors
            212052016 for 512 sectors
            212193536 for 512 sectors
            212194048 for 512 sectors
            213166336 for 512 sectors
            213166848 for 512 sectors
            213167360 for 512 sectors
            213167872 for 512 sectors
            213177600 for 512 sectors
            213178112 for 512 sectors
            214650624 for 512 sectors
            214651136 for 512 sectors
            248545288 for 512 sectors
            248545800 for 512 sectors
            248914952 for 512 sectors
            248915464 for 512 sectors
            249476104 for 512 sectors
            249476616 for 512 sectors
            262105344 for 512 sectors
            262105856 for 512 sectors
            262317312 for 512 sectors
            262317824 for 512 sectors
            262318464 for 512 sectors
            262318976 for 256 sectors
            262321408 for 512 sectors
            262321920 for 512 sectors
  273867480 for 512 sectors
            273867992 for 512 sectors
            280763096 for 512 sectors
            280763608 for 512 sectors
            487421952 for 512 sectors
            487422464 for 512 sectors
            487422976 for 128 sectors
            714478672 for 512 sectors
            714479184 for 512 sectors
            714754128 for 512 sectors
            714754640 for 512 sectors
            714755152 for 512 sectors
            714755664 for 512 sectors
            935584432 for 512 sectors
            935584944 for 512 sectors
            940173568 for 512 sectors
            940174080 for 512 sectors
            976792224 for 512 sectors
            976792736 for 512 sectors
            976793248 for 512 sectors
            976793760 for 512 sectors
            980668064 for 512 sectors
            980668576 for 512 sectors
            980669088 for 512 sectors
            980669600 for 512 sectors
Bad-blocks on /dev/sdn:
            112269328 for 512 sectors
            112269840 for 512 sectors
            112271376 for 512 sectors
            112271888 for 512 sectors
            112272400 for 512 sectors
            112272912 for 512 sectors
            112273424 for 512 sectors
            112273936 for 512 sectors
            112333840 for 512 sectors
            112334352 for 512 sectors
            112337680 for 128 sectors
            114228480 for 512 sectors
            114228992 for 512 sectors
            124707840 for 512 sectors
            124708352 for 512 sectors
            124708864 for 512 sectors
            124709376 for 512 sectors
            124712192 for 384 sectors
            130752768 for 512 sectors
            130753280 for 512 sectors
            130755840 for 512 sectors
            130756352 for 512 sectors
            130757120 for 384 sectors
            130771840 for 256 sectors
            130803968 for 512 sectors
    130804480 for 512 sectors
            130808960 for 256 sectors
            130852224 for 256 sectors
            130852608 for 256 sectors
            130853120 for 256 sectors
            130859520 for 256 sectors
            149045752 for 512 sectors
            149046264 for 512 sectors
            150267392 for 512 sectors
            150267904 for 512 sectors
            211985968 for 512 sectors
            211986480 for 512 sectors
            211996592 for 128 sectors
            212037552 for 256 sectors
            212051504 for 512 sectors
            212052016 for 512 sectors
            212193536 for 512 sectors
            212194048 for 512 sectors
            213166336 for 512 sectors
            213166848 for 512 sectors
            213167360 for 512 sectors
            213167872 for 512 sectors
            213177600 for 512 sectors
            213178112 for 512 sectors
            214650624 for 512 sectors
            214651136 for 512 sectors
            248545288 for 512 sectors
            248545800 for 512 sectors
            248914952 for 512 sectors
            248915464 for 512 sectors
            249476104 for 512 sectors
            249476616 for 512 sectors
            262105344 for 512 sectors
            262105856 for 512 sectors
            262317312 for 512 sectors
            262317824 for 512 sectors
            262318464 for 512 sectors
            262318976 for 256 sectors
            262321408 for 512 sectors
            262321920 for 512 sectors
            273867480 for 512 sectors
            273867992 for 512 sectors
            280763096 for 512 sectors
            280763608 for 512 sectors
            487421952 for 512 sectors
            487422464 for 512 sectors
            487422976 for 128 sectors
            714478672 for 512 sectors
            714479184 for 512 sectors
            714754128 for 512 sectors
            714754640 for 512 sectors
  714755152 for 512 sectors
            714755664 for 512 sectors
            935584432 for 512 sectors
            935584944 for 512 sectors
            940173568 for 512 sectors
            940174080 for 512 sectors
            976792224 for 512 sectors
            976792736 for 512 sectors
            976793248 for 512 sectors
            976793760 for 512 sectors
            980668064 for 512 sectors
            980668576 for 512 sectors
            980669088 for 512 sectors
            980669600 for 512 sectors
Bad-blocks on /dev/sdo:
            112269328 for 512 sectors
            112269840 for 512 sectors
            112271376 for 512 sectors
            112271888 for 512 sectors
            112272400 for 512 sectors
            112272912 for 512 sectors
            112273424 for 512 sectors
            112273936 for 512 sectors
            112333840 for 512 sectors
            112334352 for 512 sectors
            112337680 for 128 sectors
            114228480 for 512 sectors
            114228992 for 512 sectors
            124707840 for 512 sectors
            124708352 for 512 sectors
            124708864 for 512 sectors
            124709376 for 512 sectors
            124712192 for 384 sectors
            130752768 for 512 sectors
            130753280 for 512 sectors
            130755840 for 512 sectors
            130756352 for 512 sectors
            130757120 for 384 sectors
            130771840 for 256 sectors
            130803968 for 512 sectors
            130804480 for 512 sectors
            130808960 for 256 sectors
            130852224 for 256 sectors
            130852608 for 256 sectors
            130853120 for 256 sectors
            130859520 for 256 sectors
            149045752 for 512 sectors
            149046264 for 512 sectors
            150267392 for 512 sectors
            150267904 for 512 sectors
            211985968 for 512 sectors
            211986480 for 512 sectors
           211996592 for 128 sectors
            212037552 for 256 sectors
            212051504 for 512 sectors
            212052016 for 512 sectors
            212193536 for 512 sectors
            212194048 for 512 sectors
            213166336 for 512 sectors
            213166848 for 512 sectors
            213167360 for 512 sectors
            213167872 for 512 sectors
            213177600 for 512 sectors
            213178112 for 512 sectors
            214650624 for 512 sectors
            214651136 for 512 sectors
            248545288 for 512 sectors
            248545800 for 512 sectors
            248914952 for 512 sectors
            248915464 for 512 sectors
            249476104 for 512 sectors
            249476616 for 512 sectors
            262105344 for 512 sectors
            262105856 for 512 sectors
            262317312 for 512 sectors
            262317824 for 512 sectors
            262318464 for 512 sectors
            262318976 for 256 sectors
            262321408 for 512 sectors
            262321920 for 512 sectors
            273867480 for 512 sectors
            273867992 for 512 sectors
            280763096 for 512 sectors
            280763608 for 512 sectors
            487421952 for 512 sectors
            487422464 for 512 sectors
            487422976 for 128 sectors
            714478672 for 512 sectors
            714479184 for 512 sectors
            714754128 for 512 sectors
            714754640 for 512 sectors
            714755152 for 512 sectors
            714755664 for 512 sectors
            935584432 for 512 sectors
            935584944 for 512 sectors
            940173568 for 512 sectors
            940174080 for 512 sectors
            976792224 for 512 sectors
            976792736 for 512 sectors
            976793248 for 512 sectors
            976793760 for 512 sectors
            980668064 for 512 sectors
            980668576 for 512 sectors
            980669088 for 512 sectors
            980669600 for 512 sectors
Bad-blocks list is empty in /dev/sdp
Bad-blocks on /dev/sdq:
            211996592 for 128 sectors















_______________________________________________________________________=
_________
Mensagem enviada atrav=C3=A9s do email gr=C3=A1tis AEIOU
http://www.aeiou.pt
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
