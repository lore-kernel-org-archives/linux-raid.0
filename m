From: Brian Candler <B.Candler@pobox.com>
Subject: Interpreting mdstat output
Date: Tue, 5 Feb 2013 12:20:48 +0000
Message-ID: <20130205122048.GA417@nsrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

(Ubuntu 12.04.2, kernel 3.2.0-37-generic)

I created a RAID5 array with 22 data disks and 2 hot spares, like this:

    # mdadm --create /dev/md/dbs -l raid5 -n 22 -x 2 -c 512 -b internal /dev/sd{b..y}

However I'm having difficultly understanding the mdstat output.

    # cat /proc/mdstat
    Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
    md127 : active raid5 sdw[24] sdy[23](S) sdx[22](S) sdv[20] sdu[19] sdt[18] sds[17] sdr[16] sdq[15] sdp[14] sdo[13] sdn[12] sdm[11] sdl[10] sdk[9] sdj[8] sdi[7] sdh[6] sdg[5] sdf[4] sde[3] sdd[2] sdc[1] sdb[0]
          61532835840 blocks super 1.2 level 5, 512k chunk, algorithm 2 [22/21] [UUUUUUUUUUUUUUUUUUUUU_]
          [=>...................]  recovery =  6.0% (176470508/2930135040) finish=706.9min speed=64915K/sec
          bitmap: 0/22 pages [0KB], 65536KB chunk

    unused devices: <none>
    # 

Problems:

1. The UUUU_ and [22/21] suggests that one disk is bad, but is that true?
And if so which one?

Output from "dmesg | grep -3 sd" is at end of this mail, and it doesn't show
any errors.

All the disks have the same event counter in the metadata:

# for i in /dev/sd{b..y}; do mdadm --examine $i | grep Events; done | sort | uniq -c
     24          Events : 594

2. /proc/mdstat shows the member disks numbered 0..20 and 22..24, what
happened to 21 ?

I had previously initialised this array as a RAID6 and then changed my mind
(mdadm --stop on the RAID6, then mdadm --create as shown above). Could that
cause this?

Thanks,

Brian.


[ 1521.456236] md: bind<sdb>
[ 1521.562109] md: bind<sdc>
[ 1521.642205] md: bind<sdd>
[ 1521.742085] md: bind<sde>
[ 1521.865477] md: bind<sdf>
[ 1521.913948] md: bind<sdg>
[ 1522.032447] md: bind<sdh>
[ 1522.149983] md: bind<sdi>
[ 1522.210146] md: bind<sdj>
[ 1522.311450] md: bind<sdk>
[ 1522.394621] md: bind<sdl>
[ 1522.492218] md: bind<sdm>
[ 1522.609674] md: bind<sdn>
[ 1522.715425] md: bind<sdo>
[ 1522.793035] md: bind<sdp>
[ 1522.872313] md: bind<sdq>
[ 1522.984171] md: bind<sdr>
[ 1523.059627] md: bind<sds>
[ 1523.146203] md: bind<sdt>
[ 1523.257396] md: bind<sdu>
[ 1523.367173] md: bind<sdv>
[ 1523.459063] md: bind<sdx>
[ 1523.503167] md: bind<sdy>
[ 1523.602943] md: bind<sdw>
[ 1523.604343] md/raid:md127: device sdv operational as raid disk 20
[ 1523.604347] md/raid:md127: device sdu operational as raid disk 19
[ 1523.604350] md/raid:md127: device sdt operational as raid disk 18
[ 1523.604352] md/raid:md127: device sds operational as raid disk 17
[ 1523.604354] md/raid:md127: device sdr operational as raid disk 16
[ 1523.604356] md/raid:md127: device sdq operational as raid disk 15
[ 1523.604358] md/raid:md127: device sdp operational as raid disk 14
[ 1523.604361] md/raid:md127: device sdo operational as raid disk 13
[ 1523.604363] md/raid:md127: device sdn operational as raid disk 12
[ 1523.604365] md/raid:md127: device sdm operational as raid disk 11
[ 1523.604367] md/raid:md127: device sdl operational as raid disk 10
[ 1523.604369] md/raid:md127: device sdk operational as raid disk 9
[ 1523.604371] md/raid:md127: device sdj operational as raid disk 8
[ 1523.604373] md/raid:md127: device sdi operational as raid disk 7
[ 1523.604376] md/raid:md127: device sdh operational as raid disk 6
[ 1523.604378] md/raid:md127: device sdg operational as raid disk 5
[ 1523.604380] md/raid:md127: device sdf operational as raid disk 4
[ 1523.604382] md/raid:md127: device sde operational as raid disk 3
[ 1523.604384] md/raid:md127: device sdd operational as raid disk 2
[ 1523.604386] md/raid:md127: device sdc operational as raid disk 1
[ 1523.604388] md/raid:md127: device sdb operational as raid disk 0
[ 1523.605694] md/raid:md127: allocated 23216kB
[ 1523.605802] md/raid:md127: raid level 5 active with 21 out of 22 devices, algorithm 2
[ 1523.606250] RAID conf printout:
[ 1523.606252]  --- level:5 rd:22 wd:21
[ 1523.606254]  disk 0, o:1, dev:sdb
[ 1523.606256]  disk 1, o:1, dev:sdc
[ 1523.606258]  disk 2, o:1, dev:sdd
[ 1523.606260]  disk 3, o:1, dev:sde
[ 1523.606261]  disk 4, o:1, dev:sdf
[ 1523.606263]  disk 5, o:1, dev:sdg
[ 1523.606265]  disk 6, o:1, dev:sdh
[ 1523.606266]  disk 7, o:1, dev:sdi
[ 1523.606268]  disk 8, o:1, dev:sdj
[ 1523.606270]  disk 9, o:1, dev:sdk
[ 1523.606271]  disk 10, o:1, dev:sdl
[ 1523.606273]  disk 11, o:1, dev:sdm
[ 1523.606275]  disk 12, o:1, dev:sdn
[ 1523.606277]  disk 13, o:1, dev:sdo
[ 1523.606278]  disk 14, o:1, dev:sdp
[ 1523.606280]  disk 15, o:1, dev:sdq
[ 1523.606282]  disk 16, o:1, dev:sdr
[ 1523.606283]  disk 17, o:1, dev:sds
[ 1523.606285]  disk 18, o:1, dev:sdt
[ 1523.606287]  disk 19, o:1, dev:sdu
[ 1523.606289]  disk 20, o:1, dev:sdv
[ 1523.606440] created bitmap (22 pages) for device md127
[ 1523.609710] md127: bitmap initialized from disk: read 2/2 pages, set 44711 of 44711 bits
[ 1523.819455] md127: detected capacity change from 0 to 63009623900160
[ 1523.819488] RAID conf printout:
[ 1523.819492]  --- level:5 rd:22 wd:21
[ 1523.819495]  disk 0, o:1, dev:sdb
[ 1523.819497]  disk 1, o:1, dev:sdc
[ 1523.819499]  disk 2, o:1, dev:sdd
[ 1523.819501]  disk 3, o:1, dev:sde
[ 1523.819502]  disk 4, o:1, dev:sdf
[ 1523.819504]  disk 5, o:1, dev:sdg
[ 1523.819506]  disk 6, o:1, dev:sdh
[ 1523.819508]  disk 7, o:1, dev:sdi
[ 1523.819509]  disk 8, o:1, dev:sdj
[ 1523.819511]  disk 9, o:1, dev:sdk
[ 1523.819513]  disk 10, o:1, dev:sdl
[ 1523.819515]  disk 11, o:1, dev:sdm
[ 1523.819517]  disk 12, o:1, dev:sdn
[ 1523.819518]  disk 13, o:1, dev:sdo
[ 1523.819520]  disk 14, o:1, dev:sdp
[ 1523.819522]  disk 15, o:1, dev:sdq
[ 1523.819524]  disk 16, o:1, dev:sdr
[ 1523.819525]  disk 17, o:1, dev:sds
[ 1523.819527]  disk 18, o:1, dev:sdt
[ 1523.819529]  disk 19, o:1, dev:sdu
[ 1523.819531]  disk 20, o:1, dev:sdv
[ 1523.819532]  disk 21, o:1, dev:sdw
[ 1523.819539] RAID conf printout:
[ 1523.819541]  --- level:5 rd:22 wd:21
[ 1523.819543]  disk 0, o:1, dev:sdb
[ 1523.819544]  disk 1, o:1, dev:sdc
[ 1523.819546]  disk 2, o:1, dev:sdd
[ 1523.819548]  disk 3, o:1, dev:sde
[ 1523.819549]  disk 4, o:1, dev:sdf
[ 1523.819551]  disk 5, o:1, dev:sdg
[ 1523.819553]  disk 6, o:1, dev:sdh
[ 1523.819554]  disk 7, o:1, dev:sdi
[ 1523.819556]  disk 8, o:1, dev:sdj
[ 1523.819558]  disk 9, o:1, dev:sdk
[ 1523.819559]  disk 10, o:1, dev:sdl
[ 1523.819561]  disk 11, o:1, dev:sdm
[ 1523.819563]  disk 12, o:1, dev:sdn
[ 1523.819564]  disk 13, o:1, dev:sdo
[ 1523.819566]  disk 14, o:1, dev:sdp
[ 1523.819568]  disk 15, o:1, dev:sdq
[ 1523.819570]  disk 16, o:1, dev:sdr
[ 1523.819571]  disk 17, o:1, dev:sds
[ 1523.819573]  disk 18, o:1, dev:sdt
[ 1523.819575]  disk 19, o:1, dev:sdu
[ 1523.819576]  disk 20, o:1, dev:sdv
[ 1523.819578]  disk 21, o:1, dev:sdw
[ 1523.819579] RAID conf printout:
[ 1523.819581]  --- level:5 rd:22 wd:21
[ 1523.819583]  disk 0, o:1, dev:sdb
[ 1523.819584]  disk 1, o:1, dev:sdc
[ 1523.819586]  disk 2, o:1, dev:sdd
[ 1523.819588]  disk 3, o:1, dev:sde
[ 1523.819589]  disk 4, o:1, dev:sdf
[ 1523.819591]  disk 5, o:1, dev:sdg
[ 1523.819592]  disk 6, o:1, dev:sdh
[ 1523.819594]  disk 7, o:1, dev:sdi
[ 1523.819596]  disk 8, o:1, dev:sdj
[ 1523.819597]  disk 9, o:1, dev:sdk
[ 1523.819599]  disk 10, o:1, dev:sdl
[ 1523.819601]  disk 11, o:1, dev:sdm
[ 1523.819602]  disk 12, o:1, dev:sdn
[ 1523.819604]  disk 13, o:1, dev:sdo
[ 1523.819606]  disk 14, o:1, dev:sdp
[ 1523.819607]  disk 15, o:1, dev:sdq
[ 1523.819609]  disk 16, o:1, dev:sdr
[ 1523.819611]  disk 17, o:1, dev:sds
[ 1523.819612]  disk 18, o:1, dev:sdt
[ 1523.819614]  disk 19, o:1, dev:sdu
[ 1523.819616]  disk 20, o:1, dev:sdv
[ 1523.819617]  disk 21, o:1, dev:sdw
[ 1523.819761] md: recovery of RAID array md127
[ 1523.819765] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 1523.819767] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
