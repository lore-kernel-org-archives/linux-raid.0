From: Ethan Wilson <ethan.wilson@shiftmail.org>
Subject: Why MD often doesn't correct read errors?
Date: Thu, 02 Oct 2014 11:11:18 +0200
Message-ID: <542D16B6.8030103@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello all,
I am testing a system with a failing disk.
This is an MD raid5 with bitmap, disks are over LSI SAS. A pretty normal 
setup.

I can show very long dmesgs in which most read errors are apparently not 
corrected. However upper layers such as the filesystem do not complain 
either, e.g. the filesystem does not go readonly, and no "read error" 
received from userspace. So everything actually works, but I can't 
understand why!?

Here is one piece of dmesg in which only at [2204.845894] some errors 
get corrected by MD, so I see at least 3 errors before that (at time 
729, 1207, 2071) which are apparently ignored by everything:

[  289.360928] EXT4-fs (dm-0): mounted filesystem with ordered data 
mode. Opts: (null)
[  729.141449] sd 6:0:33:0: [sdah] Unhandled sense code
[  729.141460] sd 6:0:33:0: [sdah]
[  729.141463] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  729.141466] sd 6:0:33:0: [sdah]
[  729.141467] Sense Key : Medium Error [current]
[  729.141471] Info fld=0xcba7e3c
[  729.141473] sd 6:0:33:0: [sdah]
[  729.141476] Add. Sense: Unrecovered read error
[  729.141478] sd 6:0:33:0: [sdah] CDB:
[  729.141480] Read(10): 28 00 0c ba 7e 00 00 00 a0 00
[  729.141488] end_request: critical medium error, dev sdah, sector 
213548604
[  781.088413] perf samples too long (2510 > 2500), lowering 
kernel.perf_event_max_sample_rate to 50000
[ 1207.475752] sd 6:0:33:0: [sdah] Unhandled sense code
[ 1207.475761] sd 6:0:33:0: [sdah]
[ 1207.475762] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 1207.475764] sd 6:0:33:0: [sdah]
[ 1207.475765] Sense Key : Medium Error [current]
[ 1207.475767] Info fld=0xd2d89d2
[ 1207.475769] sd 6:0:33:0: [sdah]
[ 1207.475770] Add. Sense: Unrecovered read error
[ 1207.475772] sd 6:0:33:0: [sdah] CDB:
[ 1207.475773] Read(10): 28 00 0d 2d 88 c0 00 01 98 00
[ 1207.475778] end_request: critical medium error, dev sdah, sector 
221088210
[ 2071.445584] sd 6:0:33:0: [sdah] Unhandled sense code
[ 2071.445596] sd 6:0:33:0: [sdah]
[ 2071.445599] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 2071.445601] sd 6:0:33:0: [sdah]
[ 2071.445603] Sense Key : Medium Error [current]
[ 2071.445607] Info fld=0xc8fd800
[ 2071.445612] sd 6:0:33:0: [sdah]
[ 2071.445614] Add. Sense: Unrecovered read error
[ 2071.445615] sd 6:0:33:0: [sdah] CDB:
[ 2071.445617] Read(10): 28 00 0c 8f d8 00 00 01 c8 00
[ 2071.445622] end_request: critical medium error, dev sdah, sector 
210753536
[ 2201.018508] sd 6:0:33:0: [sdah] Unhandled sense code
[ 2201.018522] sd 6:0:33:0: [sdah]
[ 2201.018525] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 2201.018528] sd 6:0:33:0: [sdah]
[ 2201.018530] Sense Key : Medium Error [current]
[ 2201.018534] Info fld=0xc8fb450
[ 2201.018537] sd 6:0:33:0: [sdah]
[ 2201.018546] Add. Sense: Unrecovered read error
[ 2201.018551] sd 6:0:33:0: [sdah] CDB:
[ 2201.018552] Read(10): 28 00 0c 8f b4 48 00 00 38 00
[ 2201.018561] end_request: critical medium error, dev sdah, sector 
210744400
[ 2203.651727] sd 6:0:33:0: [sdah] Unhandled sense code
[ 2203.651740] sd 6:0:33:0: [sdah]
[ 2203.651743] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[ 2203.651745] sd 6:0:33:0: [sdah]
[ 2203.651747] Sense Key : Medium Error [current]
[ 2203.651752] Info fld=0xc8fb450
[ 2203.651754] sd 6:0:33:0: [sdah]
[ 2203.651756] Add. Sense: Unrecovered read error
[ 2203.651759] sd 6:0:33:0: [sdah] CDB:
[ 2203.651761] Read(10): 28 00 0c 8f b4 50 00 00 30 00
[ 2203.651769] end_request: critical medium error, dev sdah, sector 
210744400
[ 2204.845894] md/raid:md201: read error corrected (8 sectors at 996432 
on sdah2)
[ 2204.845912] md/raid:md201: read error corrected (8 sectors at 996440 
on sdah2)
[ 2204.845915] md/raid:md201: read error corrected (8 sectors at 996448 
on sdah2)
[ 2204.845918] md/raid:md201: read error corrected (8 sectors at 996456 
on sdah2)
[ 2204.845920] md/raid:md201: read error corrected (8 sectors at 996464 
on sdah2)
[ 2204.845923] md/raid:md201: read error corrected (8 sectors at 996472 
on sdah2)


Here is a time in which they get corrected a bit more often, but as you 
can see most are still skipped:

[97939.727497] sd 6:0:33:0: [sdah] Unhandled sense code
[97939.727512] sd 6:0:33:0: [sdah]
[97939.727515] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[97939.727518] sd 6:0:33:0: [sdah]
[97939.727520] Sense Key : Medium Error [current]
[97939.727524] Info fld=0xd439400
[97939.727526] sd 6:0:33:0: [sdah]
[97939.727529] Add. Sense: Unrecovered read error
[97939.727531] sd 6:0:33:0: [sdah] CDB:
[97939.727533] Read(10): 28 00 0d 43 94 00 00 00 28 00
[97939.727541] end_request: critical medium error, dev sdah, sector 
222532608
[97942.216365] sd 6:0:33:0: [sdah] Unhandled sense code
[97942.216378] sd 6:0:33:0: [sdah]
[97942.216381] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[97942.216382] sd 6:0:33:0: [sdah]
[97942.216384] Sense Key : Medium Error [current]
[97942.216387] Info fld=0xd439400
[97942.216388] sd 6:0:33:0: [sdah]
[97942.216390] Add. Sense: Unrecovered read error
[97942.216391] sd 6:0:33:0: [sdah] CDB:
[97942.216393] Read(10): 28 00 0d 43 94 00 00 00 28 00
[97942.216398] end_request: critical medium error, dev sdah, sector 
222532608
[97942.625805] md/raid:md201: read error corrected (8 sectors at 
12784640 on sdah2)
[97942.625884] md/raid:md201: read error corrected (8 sectors at 
12784648 on sdah2)
[97942.625887] md/raid:md201: read error corrected (8 sectors at 
12784656 on sdah2)
[97942.625888] md/raid:md201: read error corrected (8 sectors at 
12784664 on sdah2)
[97942.625890] md/raid:md201: read error corrected (8 sectors at 
12784672 on sdah2)
[98112.230660] sd 6:0:33:0: [sdah] Unhandled sense code
[98112.230687] sd 6:0:33:0: [sdah]
[98112.230690] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[98112.230692] sd 6:0:33:0: [sdah]
[98112.230694] Sense Key : Medium Error [current]
[98112.230698] Info fld=0xcbaca40
[98112.230700] sd 6:0:33:0: [sdah]
[98112.230703] Add. Sense: Unrecovered read error
[98112.230705] sd 6:0:33:0: [sdah] CDB:
[98112.230707] Read(10): 28 00 0c ba ca 40 00 00 08 00
[98112.230715] end_request: critical medium error, dev sdah, sector 
213568064
[99107.714394] sd 6:0:33:0: [sdah] Unhandled sense code
[99107.714443] sd 6:0:33:0: [sdah]
[99107.714444] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[99107.714446] sd 6:0:33:0: [sdah]
[99107.714447] Sense Key : Medium Error [current]
[99107.714450] Info fld=0xcba46c8
[99107.714451] sd 6:0:33:0: [sdah]
[99107.714453] Add. Sense: Unrecovered read error
[99107.714455] sd 6:0:33:0: [sdah] CDB:
[99107.714456] Read(10): 28 00 0c ba 46 c0 00 00 20 00
[99107.714461] end_request: critical medium error, dev sdah, sector 
213534408
[99110.123110] sd 6:0:33:0: [sdah] Unhandled sense code
[99110.123167] sd 6:0:33:0: [sdah]
[99110.123170] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[99110.123173] sd 6:0:33:0: [sdah]
[99110.123175] Sense Key : Medium Error [current]
[99110.123179] Info fld=0xcba46c8
[99110.123181] sd 6:0:33:0: [sdah]
[99110.123184] Add. Sense: Unrecovered read error
[99110.123187] sd 6:0:33:0: [sdah] CDB:
[99110.123189] Read(10): 28 00 0c ba 46 c0 00 00 20 00
[99110.123197] end_request: critical medium error, dev sdah, sector 
213534408
[99111.169398] md/raid:md201: read error corrected (8 sectors at 3786440 
on sdah2)
[99111.169404] md/raid:md201: read error corrected (8 sectors at 3786448 
on sdah2)
[99111.169406] md/raid:md201: read error corrected (8 sectors at 3786456 
on sdah2)
[101221.285568] mpt2sas0: _scsih_sas_broadcast_primitive_event: enter: 
phy number(1), width(16)
[101221.288095] mpt2sas0: _scsih_sas_broadcast_primitive_event: enter: 
phy number(1), width(16)
[101221.290937] mpt2sas0: _scsih_sas_broadcast_primitive_event: enter: 
phy number(1), width(16)
[101221.293768] mpt2sas0: _scsih_sas_broadcast_primitive_event: enter: 
phy number(1), width(16)
[101491.327771] sd 6:0:33:0: [sdah] Unhandled sense code
[101491.327813] sd 6:0:33:0: [sdah]
[101491.327815] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[101491.327817] sd 6:0:33:0: [sdah]
[101491.327819] Sense Key : Medium Error [current]
[101491.327822] Info fld=0xd2d7c1c
[101491.327824] sd 6:0:33:0: [sdah]
[101491.327826] Add. Sense: Unrecovered read error
[101491.327828] sd 6:0:33:0: [sdah] CDB:
[101491.327830] Read(10): 28 00 0d 2d 7c 18 00 00 08 00
[101491.327836] end_request: critical medium error, dev sdah, sector 
221084700
[112965.864443] sd 6:0:33:0: [sdah] Unhandled sense code
[112965.864469] sd 6:0:33:0: [sdah]
[112965.864471] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[112965.864474] sd 6:0:33:0: [sdah]
[112965.864476] Sense Key : Medium Error [current]
[112965.864480] Info fld=0xc8e1cb1
[112968.322232] sd 6:0:33:0: [sdah]
[112968.322233] Add. Sense: Unrecovered read error
[112968.322235] sd 6:0:33:0: [sdah] CDB:
[112968.322236] Read(10): 28 00 0c 8e 1c 00 00 00 d8 00
[112968.322241] end_request: critical medium error, dev sdah, sector 
210640049
[112969.127941] md/raid:md201: read error corrected (8 sectors at 892080 
on sdah2)
[112969.127952] md/raid:md201: read error corrected (8 sectors at 892088 
on sdah2)
[112969.127954] md/raid:md201: read error corrected (8 sectors at 892096 
on sdah2)
[112969.127955] md/raid:md201: read error corrected (8 sectors at 892104 
on sdah2)
[112969.127957] md/raid:md201: read error corrected (8 sectors at 892112 
on sdah2)
[113352.100011] sd 6:0:33:0: [sdah] Unhandled sense code
[113352.100068] sd 6:0:33:0: [sdah]
[113352.100071] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[113352.100074] sd 6:0:33:0: [sdah]
[113352.100076] Sense Key : Medium Error [current]
[113352.100080] Info fld=0xc8e8448
[113352.100083] sd 6:0:33:0: [sdah]
[113352.100086] Add. Sense: Unrecovered read error
[113352.100088] sd 6:0:33:0: [sdah] CDB:
[113352.100090] Read(10): 28 00 0c 8e 84 30 00 00 38 00
[113352.100099] end_request: critical medium error, dev sdah, sector 
210666568
[113354.850395] sd 6:0:33:0: [sdah] Unhandled sense code
[113354.850404] sd 6:0:33:0: [sdah]
[113354.850406] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[113354.850408] sd 6:0:33:0: [sdah]
[113354.850409] Sense Key : Medium Error [current]
[113354.850412] Info fld=0xc8e8448
[113354.850414] sd 6:0:33:0: [sdah]
[113354.850416] Add. Sense: Unrecovered read error
[113354.850417] sd 6:0:33:0: [sdah] CDB:
[113354.850419] Read(10): 28 00 0c 8e 84 30 00 00 38 00
[113354.850424] end_request: critical medium error, dev sdah, sector 
210666568
[113355.387298] md/raid:md201: read error corrected (8 sectors at 918600 
on sdah2)
[113355.387303] md/raid:md201: read error corrected (8 sectors at 918608 
on sdah2)
[113355.387305] md/raid:md201: read error corrected (8 sectors at 918616 
on sdah2)
[113355.387307] md/raid:md201: read error corrected (8 sectors at 918624 
on sdah2)

As I wrote above, no error is noticed by userspace, so it actually 
works, but I don't know why!?

Thanks for info
EW

