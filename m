From: Brian Candler <B.Candler@pobox.com>
Subject: RAID6 rebuild stuck
Date: Mon, 1 Oct 2012 12:29:46 +0100
Message-ID: <20121001112946.GB27455@nsrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Platform: ubuntu 10.10, kernel 2.6.35-30-server (yes I know it's old -
update to 12.04 is scheduled)

RAID6 array md1 was running as degraded with two failed disks, sdg and sdk. 
I did a dd write of zeros across both disks, which was successful, so
re-introduced them into the array.  I also enabled scterc, which hadn't been
enabled before.

However some hours into the rebuild, sdg failed again. Now the RAID rebuild
has stuck at the following point:

  cat /proc/mdstat
  ...
  md1 : active raid6 sdk[6] sdg[5](F) sdm[0] sdf[2] sdl[1]
        8790786048 blocks super 1.0 level 6, 16384k chunk, algorithm 2 [5/3] [UUU__]
        [================>....]  recovery = 82.1% (2408361728/2930262016) finish=2976485.1min speed=2K/sec

If I repeat cat /proc/mdstat, even after several minutes, the values do not
increment.

The last ~400 lines of dmesg are below. Key items are:

22440448.503388 - sde added to md0 (this array is now fine)
22440458.737931 - sdg added to md1
22440460.941412 - sdk added to md1
22542378.442924 - sdg started to fail, corrected read errors
22581985.862037 - sdg kicked out, uncorrectable errors
22581986.111914 - "recovery done"!!

So mdstat says that recovery is ongoing, when clearly it isn't. I'm not sure
what I should do next.  Should I just hot-swap sdg, or should I reboot to
clear the stuck /proc/mdstat status?

Thanks,

Brian.

[22383576.611801] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22383576.611817] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22383576.611830] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22383576.611843] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22383576.611856] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22383576.611867] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22383576.612049] sd 6:0:6:0: [sdg] Unhandled sense code
[22383576.612059] sd 6:0:6:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[22383576.612068] sd 6:0:6:0: [sdg] Sense Key : Medium Error [current] 
[22383576.612079] Info fld=0x5cde847d
[22383576.612084] sd 6:0:6:0: [sdg] Add. Sense: Unrecovered read error
[22383576.612093] sd 6:0:6:0: [sdg] CDB: Read(10): 28 00 5c de 84 00 00 04 00 00
[22383576.612112] end_request: I/O error, dev sdg, sector 1558086656
[22440448.503388] md: bind<sde>
[22440448.531727] RAID conf printout:
[22440448.531735]  --- level:6 rd:5 wd:4
[22440448.531742]  disk 0, o:1, dev:sda
[22440448.531748]  disk 1, o:1, dev:sdh
[22440448.531752]  disk 2, o:1, dev:sdb
[22440448.531756]  disk 3, o:1, dev:sdc
[22440448.531760]  disk 4, o:1, dev:sde
[22440448.531936] md: recovery of RAID array md0
[22440448.531945] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[22440448.531952] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[22440448.532030] md: using 128k window, over a total of 2930262016 blocks.
[22440458.737931] md: bind<sdg>
[22440458.787997] RAID conf printout:
[22440458.788006]  --- level:6 rd:5 wd:3
[22440458.788012]  disk 0, o:1, dev:sdm
[22440458.788017]  disk 1, o:1, dev:sdl
[22440458.788022]  disk 2, o:1, dev:sdf
[22440458.788026]  disk 3, o:1, dev:sdg
[22440458.788226] md: recovery of RAID array md1
[22440458.788237] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[22440458.788243] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[22440458.788301] md: using 128k window, over a total of 2930262016 blocks.
[22440460.941412] md: bind<sdk>
[22510058.255395] md: md0: recovery done.
[22510058.283847] RAID conf printout:
[22510058.283857]  --- level:6 rd:5 wd:5
[22510058.283864]  disk 0, o:1, dev:sda
[22510058.283870]  disk 1, o:1, dev:sdh
[22510058.283874]  disk 2, o:1, dev:sdb
[22510058.283879]  disk 3, o:1, dev:sdc
[22510058.283883]  disk 4, o:1, dev:sde
[22522476.742626] md: md1: recovery done.
[22522476.850179] RAID conf printout:
[22522476.850185]  --- level:6 rd:5 wd:4
[22522476.850188]  disk 0, o:1, dev:sdm
[22522476.850190]  disk 1, o:1, dev:sdl
[22522476.850192]  disk 2, o:1, dev:sdf
[22522476.850193]  disk 3, o:1, dev:sdg
[22522476.858669] RAID conf printout:
[22522476.858679]  --- level:6 rd:5 wd:4
[22522476.858686]  disk 0, o:1, dev:sdm
[22522476.858691]  disk 1, o:1, dev:sdl
[22522476.858695]  disk 2, o:1, dev:sdf
[22522476.858700]  disk 3, o:1, dev:sdg
[22522476.858704]  disk 4, o:1, dev:sdk
[22522476.858909] md: recovery of RAID array md1
[22522476.858917] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[22522476.858924] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[22522476.858999] md: using 128k window, over a total of 2930262016 blocks.
[22542378.442924] sd 6:0:6:0: [sdg] Unhandled sense code
[22542378.442935] sd 6:0:6:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[22542378.442945] sd 6:0:6:0: [sdg] Sense Key : Medium Error [current] 
[22542378.442956] Info fld=0x5cb49cab
[22542378.442960] sd 6:0:6:0: [sdg] Add. Sense: Unrecovered read error
[22542378.442969] sd 6:0:6:0: [sdg] CDB: Read(10): 28 00 5c b4 9c 58 00 00 a8 00
[22542378.442988] end_request: I/O error, dev sdg, sector 1555340376
[22542384.592322] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542384.592336] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542384.592346] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542384.592355] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542384.592364] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542384.592373] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542384.592382] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542384.592391] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542384.592521] sd 6:0:6:0: [sdg] Unhandled sense code
[22542384.592533] sd 6:0:6:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[22542384.592543] sd 6:0:6:0: [sdg] Sense Key : Medium Error [current] 
[22542384.592554] Info fld=0x5cb4a619
[22542384.592558] sd 6:0:6:0: [sdg] Add. Sense: Unrecovered read error
[22542384.592568] sd 6:0:6:0: [sdg] CDB: Read(10): 28 00 5c b4 a6 00 00 01 00 00
[22542384.592586] end_request: I/O error, dev sdg, sector 1555342848
[22542385.224348] md/raid:md1: read error corrected (8 sectors at 1555340376 on sdg)
[22542385.224359] md/raid:md1: read error corrected (8 sectors at 1555340384 on sdg)
[22542385.224367] md/raid:md1: read error corrected (8 sectors at 1555340392 on sdg)
[22542385.224374] md/raid:md1: read error corrected (8 sectors at 1555340400 on sdg)
[22542385.224381] md/raid:md1: read error corrected (8 sectors at 1555340408 on sdg)
[22542385.224387] md/raid:md1: read error corrected (8 sectors at 1555340416 on sdg)
[22542385.224394] md/raid:md1: read error corrected (8 sectors at 1555340424 on sdg)
[22542385.224401] md/raid:md1: read error corrected (8 sectors at 1555340432 on sdg)
[22542385.224407] md/raid:md1: read error corrected (8 sectors at 1555340440 on sdg)
[22542385.224414] md/raid:md1: read error corrected (8 sectors at 1555340448 on sdg)
[22542395.724610] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542395.724623] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542395.724633] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542395.724642] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542395.724651] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542395.724660] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542395.724670] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542395.724679] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542395.724690] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542395.724848] sd 6:0:6:0: [sdg] Unhandled sense code
[22542395.724859] sd 6:0:6:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[22542395.724868] sd 6:0:6:0: [sdg] Sense Key : Medium Error [current] 
[22542395.724880] Info fld=0x5cb564f6
[22542395.724884] sd 6:0:6:0: [sdg] Add. Sense: Unrecovered read error
[22542395.724894] sd 6:0:6:0: [sdg] CDB: Read(10): 28 00 5c b5 64 40 00 00 c0 00
[22542395.724912] end_request: I/O error, dev sdg, sector 1555391552
[22542397.690128] raid5_end_read_request: 43 callbacks suppressed
[22542397.690134] md/raid:md1: read error corrected (8 sectors at 1555391552 on sdg)
[22542397.690138] md/raid:md1: read error corrected (8 sectors at 1555391560 on sdg)
[22542397.690141] md/raid:md1: read error corrected (8 sectors at 1555391568 on sdg)
[22542397.690143] md/raid:md1: read error corrected (8 sectors at 1555391576 on sdg)
[22542397.690145] md/raid:md1: read error corrected (8 sectors at 1555391584 on sdg)
[22542397.690148] md/raid:md1: read error corrected (8 sectors at 1555391592 on sdg)
[22542397.690150] md/raid:md1: read error corrected (8 sectors at 1555391600 on sdg)
[22542397.690153] md/raid:md1: read error corrected (8 sectors at 1555391608 on sdg)
[22542397.690155] md/raid:md1: read error corrected (8 sectors at 1555391616 on sdg)
[22542397.690158] md/raid:md1: read error corrected (8 sectors at 1555391624 on sdg)
[22542437.870581] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542437.870594] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542437.870604] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542437.870615] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542437.870624] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542437.870633] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542437.870642] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542437.870652] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542437.870661] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542437.870669] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542437.870752] sd 6:0:6:0: [sdg] Unhandled sense code
[22542437.870762] sd 6:0:6:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[22542437.870771] sd 6:0:6:0: [sdg] Sense Key : Medium Error [current] 
[22542437.870782] Info fld=0x5cde8e01
[22542437.870787] sd 6:0:6:0: [sdg] Add. Sense: Unrecovered read error
[22542437.870796] sd 6:0:6:0: [sdg] CDB: Read(10): 28 00 5c de 8e 00 00 00 28 00
[22542437.870814] end_request: I/O error, dev sdg, sector 1558089216
[22542443.036738] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542443.036752] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542443.036763] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542443.036772] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542443.036781] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542443.036790] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542443.036799] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542443.036807] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542443.036815] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542443.036953] sd 6:0:6:0: [sdg] Unhandled sense code
[22542443.036964] sd 6:0:6:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[22542443.036973] sd 6:0:6:0: [sdg] Sense Key : Medium Error [current] 
[22542443.036985] Info fld=0x5cde8e32
[22542443.036989] sd 6:0:6:0: [sdg] Add. Sense: Unrecovered read error
[22542443.036999] sd 6:0:6:0: [sdg] CDB: Read(10): 28 00 5c de 8e 30 00 00 d0 00
[22542443.037017] end_request: I/O error, dev sdg, sector 1558089264
[22542449.577886] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542449.577899] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542449.577909] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542449.577918] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542449.577927] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542449.577937] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542449.577944] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542449.577953] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542449.577962] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22542449.578102] sd 6:0:6:0: [sdg] Unhandled sense code
[22542449.578113] sd 6:0:6:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[22542449.578122] sd 6:0:6:0: [sdg] Sense Key : Medium Error [current] 
[22542449.578133] Info fld=0x5cde8fa0
[22542449.578138] sd 6:0:6:0: [sdg] Add. Sense: Unrecovered read error
[22542449.578147] sd 6:0:6:0: [sdg] CDB: Read(10): 28 00 5c de 8f 00 00 01 00 00
[22542449.578165] end_request: I/O error, dev sdg, sector 1558089472
[22542451.795604] raid5_end_read_request: 14 callbacks suppressed
[22542451.795614] md/raid:md1: read error corrected (8 sectors at 1558089216 on sdg)
[22542451.795621] md/raid:md1: read error corrected (8 sectors at 1558089224 on sdg)
[22542451.795628] md/raid:md1: read error corrected (8 sectors at 1558089232 on sdg)
[22542451.795635] md/raid:md1: read error corrected (8 sectors at 1558089240 on sdg)
[22542451.795641] md/raid:md1: read error corrected (8 sectors at 1558089248 on sdg)
[22542452.292777] md/raid:md1: read error corrected (8 sectors at 1558089264 on sdg)
[22542452.292791] md/raid:md1: read error corrected (8 sectors at 1558089272 on sdg)
[22542452.292794] md/raid:md1: read error corrected (8 sectors at 1558089280 on sdg)
[22542452.292797] md/raid:md1: read error corrected (8 sectors at 1558089288 on sdg)
[22542452.292799] md/raid:md1: read error corrected (8 sectors at 1558089296 on sdg)
[22543017.531581] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22543017.531596] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22543017.531607] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22543017.531616] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22543017.531669] sd 6:0:6:0: [sdg] Unhandled sense code
[22543017.531679] sd 6:0:6:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[22543017.531689] sd 6:0:6:0: [sdg] Sense Key : Medium Error [current] 
[22543017.531700] Info fld=0x5f53cf52
[22543017.531704] sd 6:0:6:0: [sdg] Add. Sense: Unrecovered read error
[22543017.531714] sd 6:0:6:0: [sdg] CDB: Read(10): 28 00 5f 53 cf 38 00 00 c8 00
[22543017.531732] end_request: I/O error, dev sdg, sector 1599328056
[22543019.313666] raid5_end_read_request: 53 callbacks suppressed
[22543019.313676] md/raid:md1: read error corrected (8 sectors at 1599328056 on sdg)
[22543019.313690] md/raid:md1: read error corrected (8 sectors at 1599328064 on sdg)
[22543019.313697] md/raid:md1: read error corrected (8 sectors at 1599328072 on sdg)
[22543019.313704] md/raid:md1: read error corrected (8 sectors at 1599328080 on sdg)
[22543019.313710] md/raid:md1: read error corrected (8 sectors at 1599328088 on sdg)
[22543019.313717] md/raid:md1: read error corrected (8 sectors at 1599328096 on sdg)
[22543019.313723] md/raid:md1: read error corrected (8 sectors at 1599328104 on sdg)
[22543019.313730] md/raid:md1: read error corrected (8 sectors at 1599328112 on sdg)
[22543019.313736] md/raid:md1: read error corrected (8 sectors at 1599328120 on sdg)
[22543019.313742] md/raid:md1: read error corrected (8 sectors at 1599328128 on sdg)
[22562645.245880] ADDRCONF(NETDEV_UP): eth5: link is not ready
[22562647.040118] ixgbe: eth5 NIC Link is Up 10 Gbps, Flow Control: RX/TX
[22562647.045381] ADDRCONF(NETDEV_CHANGE): eth5: link becomes ready
[22562657.900033] eth5: no IPv6 routers present
[22575844.106752] sd 6:0:6:0: [sdg] Unhandled sense code
[22575844.106759] sd 6:0:6:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[22575844.106763] sd 6:0:6:0: [sdg] Sense Key : Medium Error [current] [descriptor]
[22575844.106767] Descriptor sense data with sense descriptors (in hex):
[22575844.106769]         72 03 11 00 00 00 00 0c 00 0a 80 00 00 00 00 01 
[22575844.106776]         00 fa a3 6f 
[22575844.106779] sd 6:0:6:0: [sdg] Add. Sense: Unrecovered read error
[22575844.106783] sd 6:0:6:0: [sdg] CDB: Read(16): 88 00 00 00 00 01 00 fa a3 00 00 00 01 00 00 00
[22575844.106792] end_request: I/O error, dev sdg, sector 4311393024
[22575845.334051] raid5_end_read_request: 15 callbacks suppressed
[22575845.334056] md/raid:md1: read error corrected (8 sectors at 4311393024 on sdg)
[22575845.334065] md/raid:md1: read error corrected (8 sectors at 4311393032 on sdg)
[22575845.334068] md/raid:md1: read error corrected (8 sectors at 4311393040 on sdg)
[22575845.477470] md/raid:md1: read error corrected (8 sectors at 4311393048 on sdg)
[22575845.477481] md/raid:md1: read error corrected (8 sectors at 4311393056 on sdg)
[22575845.477484] md/raid:md1: read error corrected (8 sectors at 4311393064 on sdg)
[22575845.477487] md/raid:md1: read error corrected (8 sectors at 4311393072 on sdg)
[22575845.477490] md/raid:md1: read error corrected (8 sectors at 4311393080 on sdg)
[22575845.477499] md/raid:md1: read error corrected (8 sectors at 4311393088 on sdg)
[22575845.477503] md/raid:md1: read error corrected (8 sectors at 4311393096 on sdg)
[22575854.105793] sd 6:0:6:0: [sdg] Unhandled sense code
[22575854.105799] sd 6:0:6:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[22575854.105803] sd 6:0:6:0: [sdg] Sense Key : Medium Error [current] [descriptor]
[22575854.105808] Descriptor sense data with sense descriptors (in hex):
[22575854.105810]         72 03 11 00 00 00 00 0c 00 0a 80 00 00 00 00 01 
[22575854.105816]         00 fa e1 27 
[22575854.105819] sd 6:0:6:0: [sdg] Add. Sense: Unrecovered read error
[22575854.105823] sd 6:0:6:0: [sdg] CDB: Read(16): 88 00 00 00 00 01 00 fa e1 00 00 00 01 00 00 00
[22575854.105832] end_request: I/O error, dev sdg, sector 4311408896
[22575855.115627] raid5_end_read_request: 22 callbacks suppressed
[22575855.115632] md/raid:md1: read error corrected (8 sectors at 4311408896 on sdg)
[22575855.115643] md/raid:md1: read error corrected (8 sectors at 4311408904 on sdg)
[22575855.590725] md/raid:md1: read error corrected (8 sectors at 4311408912 on sdg)
[22575855.590735] md/raid:md1: read error corrected (8 sectors at 4311408920 on sdg)
[22575855.590738] md/raid:md1: read error corrected (8 sectors at 4311408928 on sdg)
[22575855.590742] md/raid:md1: read error corrected (8 sectors at 4311408936 on sdg)
[22575855.591565] md/raid:md1: read error corrected (8 sectors at 4311408944 on sdg)
[22575855.591572] md/raid:md1: read error corrected (8 sectors at 4311408952 on sdg)
[22575855.591576] md/raid:md1: read error corrected (8 sectors at 4311408960 on sdg)
[22575855.591584] md/raid:md1: read error corrected (8 sectors at 4311408968 on sdg)
[22578251.067614] sd 6:0:6:0: [sdg] Unhandled sense code
[22578251.067623] sd 6:0:6:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[22578251.067632] sd 6:0:6:0: [sdg] Sense Key : Medium Error [current] [descriptor]
[22578251.067643] Descriptor sense data with sense descriptors (in hex):
[22578251.067648]         72 03 11 00 00 00 00 0c 00 0a 80 00 00 00 00 01 
[22578251.067667]         0c 88 26 c5 
[22578251.067676] sd 6:0:6:0: [sdg] Add. Sense: Unrecovered read error
[22578251.067685] sd 6:0:6:0: [sdg] CDB: Read(16): 88 00 00 00 00 01 0c 88 26 00 00 00 01 00 00 00
[22578251.067708] end_request: I/O error, dev sdg, sector 4505216512
[22578254.167280] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22578254.167289] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22578254.167292] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22578254.167296] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22578254.167301] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22578254.167305] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22578254.167314] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22578254.167320] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22578254.167443] sd 6:0:6:0: [sdg] Unhandled sense code
[22578254.167450] sd 6:0:6:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[22578254.167455] sd 6:0:6:0: [sdg] Sense Key : Medium Error [current] [descriptor]
[22578254.167459] Descriptor sense data with sense descriptors (in hex):
[22578254.167461]         72 03 11 00 00 00 00 0c 00 0a 80 00 00 00 00 01 
[22578254.167468]         0c 88 2e 30 
[22578254.167471] sd 6:0:6:0: [sdg] Add. Sense: Unrecovered read error
[22578254.167476] sd 6:0:6:0: [sdg] CDB: Read(16): 88 00 00 00 00 01 0c 88 2e 00 00 00 01 00 00 00
[22578254.167485] end_request: I/O error, dev sdg, sector 4505218560
[22578254.984897] raid5_end_read_request: 22 callbacks suppressed
[22578254.984902] md/raid:md1: read error corrected (8 sectors at 4505216512 on sdg)
[22578254.984908] md/raid:md1: read error corrected (8 sectors at 4505216520 on sdg)
[22578254.984911] md/raid:md1: read error corrected (8 sectors at 4505216528 on sdg)
[22578254.984914] md/raid:md1: read error corrected (8 sectors at 4505216536 on sdg)
[22578254.984916] md/raid:md1: read error corrected (8 sectors at 4505216544 on sdg)
[22578254.984918] md/raid:md1: read error corrected (8 sectors at 4505216552 on sdg)
[22578254.984921] md/raid:md1: read error corrected (8 sectors at 4505216560 on sdg)
[22578254.984923] md/raid:md1: read error corrected (8 sectors at 4505216568 on sdg)
[22578254.984926] md/raid:md1: read error corrected (8 sectors at 4505216576 on sdg)
[22578254.984928] md/raid:md1: read error corrected (8 sectors at 4505216584 on sdg)
[22578260.319089] raid5_end_read_request: 22 callbacks suppressed
[22578260.319095] md/raid:md1: read error corrected (8 sectors at 4505218560 on sdg)
[22578260.319102] md/raid:md1: read error corrected (8 sectors at 4505218568 on sdg)
[22578260.319105] md/raid:md1: read error corrected (8 sectors at 4505218576 on sdg)
[22578260.319108] md/raid:md1: read error corrected (8 sectors at 4505218584 on sdg)
[22578260.319110] md/raid:md1: read error corrected (8 sectors at 4505218592 on sdg)
[22578260.319113] md/raid:md1: read error corrected (8 sectors at 4505218600 on sdg)
[22578260.319115] md/raid:md1: read error corrected (8 sectors at 4505218608 on sdg)
[22578260.319117] md/raid:md1: read error corrected (8 sectors at 4505218616 on sdg)
[22578260.319119] md/raid:md1: read error corrected (8 sectors at 4505218624 on sdg)
[22578260.319122] md/raid:md1: read error corrected (8 sectors at 4505218632 on sdg)
[22581681.874078] sd 6:0:6:0: [sdg] Unhandled sense code
[22581681.874086] sd 6:0:6:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[22581681.874090] sd 6:0:6:0: [sdg] Sense Key : Medium Error [current] [descriptor]
[22581681.874095] Descriptor sense data with sense descriptors (in hex):
[22581681.874098]         72 03 11 00 00 00 00 0c 00 0a 80 00 00 00 00 01 
[22581681.874104]         1d fa 42 03 
[22581681.874107] sd 6:0:6:0: [sdg] Add. Sense: Unrecovered read error
[22581681.874112] sd 6:0:6:0: [sdg] CDB: Read(16): 88 00 00 00 00 01 1d fa 42 00 00 00 01 00 00 00
[22581681.874121] end_request: I/O error, dev sdg, sector 4797907456
[22581686.823444] raid5_end_read_request: 22 callbacks suppressed
[22581686.823451] md/raid:md1: read error corrected (8 sectors at 4797907456 on sdg)
[22581687.072047] md/raid:md1: read error corrected (8 sectors at 4797907464 on sdg)
[22581687.072059] md/raid:md1: read error corrected (8 sectors at 4797907472 on sdg)
[22581687.072062] md/raid:md1: read error corrected (8 sectors at 4797907480 on sdg)
[22581687.072065] md/raid:md1: read error corrected (8 sectors at 4797907488 on sdg)
[22581687.072973] md/raid:md1: read error corrected (8 sectors at 4797907496 on sdg)
[22581687.072980] md/raid:md1: read error corrected (8 sectors at 4797907504 on sdg)
[22581687.072982] md/raid:md1: read error corrected (8 sectors at 4797907512 on sdg)
[22581687.072990] md/raid:md1: read error corrected (8 sectors at 4797907520 on sdg)
[22581687.072994] md/raid:md1: read error corrected (8 sectors at 4797907528 on sdg)
[22581698.030939] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22581698.030947] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22581698.030951] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22581698.030954] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22581698.030958] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22581698.030995] sd 6:0:6:0: [sdg] Unhandled sense code
[22581698.031000] sd 6:0:6:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[22581698.031005] sd 6:0:6:0: [sdg] Sense Key : Medium Error [current] [descriptor]
[22581698.031010] Descriptor sense data with sense descriptors (in hex):
[22581698.031012]         72 03 11 00 00 00 00 0c 00 0a 80 00 00 00 00 01 
[22581698.031018]         1d fa b7 00 
[22581698.031021] sd 6:0:6:0: [sdg] Add. Sense: Unrecovered read error
[22581698.031026] sd 6:0:6:0: [sdg] CDB: Read(16): 88 00 00 00 00 01 1d fa b7 00 00 00 00 c8 00 00
[22581698.031035] end_request: I/O error, dev sdg, sector 4797937408
[22581701.434353] raid5_end_read_request: 22 callbacks suppressed
[22581701.434357] md/raid:md1: read error corrected (8 sectors at 4797937408 on sdg)
[22581701.434367] md/raid:md1: read error corrected (8 sectors at 4797937416 on sdg)
[22581701.435141] md/raid:md1: read error corrected (8 sectors at 4797937424 on sdg)
[22581701.435148] md/raid:md1: read error corrected (8 sectors at 4797937432 on sdg)
[22581701.435151] md/raid:md1: read error corrected (8 sectors at 4797937440 on sdg)
[22581701.435160] md/raid:md1: read error corrected (8 sectors at 4797937448 on sdg)
[22581701.435164] md/raid:md1: read error corrected (8 sectors at 4797937456 on sdg)
[22581701.435172] md/raid:md1: read error corrected (8 sectors at 4797937464 on sdg)
[22581701.435175] md/raid:md1: read error corrected (8 sectors at 4797937472 on sdg)
[22581701.435183] md/raid:md1: read error corrected (8 sectors at 4797937480 on sdg)
[22581981.870472] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22581981.870482] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22581981.870487] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22581981.870493] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22581981.870498] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22581981.870605] sd 6:0:6:0: [sdg] Unhandled sense code
[22581981.870613] sd 6:0:6:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[22581981.870618] sd 6:0:6:0: [sdg] Sense Key : Medium Error [current] [descriptor]
[22581981.870623] Descriptor sense data with sense descriptors (in hex):
[22581981.870625]         72 03 11 00 00 00 00 0c 00 0a 80 00 00 00 00 01 
[22581981.870632]         1f 19 45 58 
[22581981.870635] sd 6:0:6:0: [sdg] Add. Sense: Unrecovered read error
[22581981.870639] sd 6:0:6:0: [sdg] CDB: Read(16): 88 00 00 00 00 01 1f 19 45 00 00 00 01 00 00 00
[22581981.870648] end_request: I/O error, dev sdg, sector 4816717056
[22581985.861765] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22581985.861773] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22581985.861778] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22581985.861782] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22581985.861786] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22581985.861791] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22581985.861799] mpt2sas0: log_info(0x31080000): originator(PL), code(0x08), sub_code(0x0000)
[22581985.861911] sd 6:0:6:0: [sdg] Unhandled sense code
[22581985.861919] sd 6:0:6:0: [sdg] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[22581985.861923] sd 6:0:6:0: [sdg] Sense Key : Medium Error [current] [descriptor]
[22581985.861929] Descriptor sense data with sense descriptors (in hex):
[22581985.861930]         72 03 11 00 00 00 00 0c 00 0a 80 00 00 00 00 01 
[22581985.861937]         1f 19 45 59 
[22581985.861939] sd 6:0:6:0: [sdg] Add. Sense: Unrecovered read error
[22581985.861944] sd 6:0:6:0: [sdg] CDB: Read(16): 88 00 00 00 00 01 1f 19 45 00 00 00 01 00 00 00
[22581985.861953] end_request: I/O error, dev sdg, sector 4816717056
[22581985.862031] raid5_end_read_request: 15 callbacks suppressed
[22581985.862033] md/raid:md1: read error NOT corrected!! (sector 4816717056 on sdg).
[22581985.862037] md/raid:md1: Disk failure on sdg, disabling device.
[22581985.862038] <1>md/raid:md1: Operation continuing on 3 devices.
[22581985.862185] md/raid:md1: read error not correctable (sector 4816717064 on sdg).
[22581985.862188] md/raid:md1: read error not correctable (sector 4816717072 on sdg).
[22581985.862191] md/raid:md1: read error not correctable (sector 4816717080 on sdg).
[22581985.862194] md/raid:md1: read error not correctable (sector 4816717088 on sdg).
[22581985.862196] md/raid:md1: read error not correctable (sector 4816717096 on sdg).
[22581985.862198] md/raid:md1: read error not correctable (sector 4816717104 on sdg).
[22581985.862200] md/raid:md1: read error not correctable (sector 4816717112 on sdg).
[22581985.862202] md/raid:md1: read error not correctable (sector 4816717120 on sdg).
[22581985.862205] md/raid:md1: read error not correctable (sector 4816717128 on sdg).
[22581986.111914] md: md1: recovery done.
