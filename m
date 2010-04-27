From: "Janos Haar" <janos.haar@netcenter.hu>
Subject: Re: Suggestion needed for fixing RAID6
Date: Tue, 27 Apr 2010 17:50:43 +0200
Message-ID: <80a201cae621$684daa30$0400a8c0@dcccs>
References: <626601cae203$dae35030$0400a8c0@dcccs> <20100423065143.GA17743@maude.comedia.it> <695a01cae2c1$a72907d0$0400a8c0@dcccs> <4BD193D0.5080003@shiftmail.org> <717901cae3e5$6a5fa730$0400a8c0@dcccs> <4BD3751A.5000403@shiftmail.org> <756601cae45e$213d6190$0400a8c0@dcccs> <4BD569E2.7010409@shiftmail.org> <7a3e01cae53f$684122c0$0400a8c0@dcccs> <4BD5C51E.9040207@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: MRK <mrk@shiftmail.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message ----- 
From: "MRK" <mrk@shiftmail.org>
To: "Janos Haar" <janos.haar@netcenter.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Monday, April 26, 2010 6:53 PM
Subject: Re: Suggestion needed for fixing RAID6


> On 04/26/2010 02:52 PM, Janos Haar wrote:
>>
>> Oops, you are right!
>> It was my mistake.
>> Sorry, i will try it again, to support 2 drives with dm-cow.
>> I will try it.
>
> Great! post here the results... the dmesg in particular.
> The dmesg should contain multiple lines like this "raid5:md3: read error 
> corrected ....."
> then you know it worked.

I am affraid i am still right about that....

...
end_request: I/O error, dev sdh, sector 1667152256
raid5:md3: read error not correctable (sector 1662188168 on dm-1).
raid5: Disk failure on dm-1, disabling device.
raid5: Operation continuing on 10 devices.
raid5:md3: read error not correctable (sector 1662188176 on dm-1).
raid5:md3: read error not correctable (sector 1662188184 on dm-1).
raid5:md3: read error not correctable (sector 1662188192 on dm-1).
raid5:md3: read error not correctable (sector 1662188200 on dm-1).
raid5:md3: read error not correctable (sector 1662188208 on dm-1).
raid5:md3: read error not correctable (sector 1662188216 on dm-1).
raid5:md3: read error not correctable (sector 1662188224 on dm-1).
raid5:md3: read error not correctable (sector 1662188232 on dm-1).
raid5:md3: read error not correctable (sector 1662188240 on dm-1).
ata8: EH complete
sd 7:0:0:0: [sdh] 2930277168 512-byte hardware sectors: (1.50 TB/1.36 TiB)
ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata8.00: port_status 0x20200000
ata8.00: cmd 25/00:f8:f5:ba:5e/00:03:63:00:00/e0 tag 0 dma 520192 in
         res 51/40:00:ef:bb:5e/40:00:63:00:00/e0 Emask 0x9 (media error)
ata8.00: status: { DRDY ERR }
ata8.00: error: { UNC }
ata8.00: configured for UDMA/133
ata8: EH complete
....
....
sd 7:0:0:0: [sdh] Add. Sense: Unrecovered read error - auto reallocate 
failed
end_request: I/O error, dev sdh, sector 1667152879
__ratelimit: 36 callbacks suppressed
raid5:md3: read error not correctable (sector 1662188792 on dm-1).
raid5:md3: read error not correctable (sector 1662188800 on dm-1).
md: md3: recovery done.
raid5:md3: read error not correctable (sector 1662188808 on dm-1).
raid5:md3: read error not correctable (sector 1662188816 on dm-1).
raid5:md3: read error not correctable (sector 1662188824 on dm-1).
raid5:md3: read error not correctable (sector 1662188832 on dm-1).
raid5:md3: read error not correctable (sector 1662188840 on dm-1).
raid5:md3: read error not correctable (sector 1662188848 on dm-1).
raid5:md3: read error not correctable (sector 1662188856 on dm-1).
raid5:md3: read error not correctable (sector 1662188864 on dm-1).
ata8: EH complete
sd 7:0:0:0: [sdh] Write Protect is off
sd 7:0:0:0: [sdh] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support 
DPO 
or FUA
ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
ata8.00: port_status 0x20200000
....
....
res 51/40:00:27:c0:5e/40:00:63:00:00/e0 Emask 0x9 (media error)
ata8.00: status: { DRDY ERR }
ata8.00: error: { UNC }
ata8.00: configured for UDMA/133
sd 7:0:0:0: [sdh] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
sd 7:0:0:0: [sdh] Sense Key : Medium Error [current] [descriptor]
Descriptor sense data with sense descriptors (in hex):
        72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
        63 5e c0 27
sd 7:0:0:0: [sdh] Add. Sense: Unrecovered read error - auto reallocate 
failed
end_request: I/O error, dev sdh, sector 1667153959
__ratelimit: 86 callbacks suppressed
raid5:md3: read error not correctable (sector 1662189872 on dm-1).
raid5:md3: read error not correctable (sector 1662189880 on dm-1).
raid5:md3: read error not correctable (sector 1662189888 on dm-1).
raid5:md3: read error not correctable (sector 1662189896 on dm-1).
raid5:md3: read error not correctable (sector 1662189904 on dm-1).
raid5:md3: read error not correctable (sector 1662189912 on dm-1).
raid5:md3: read error not correctable (sector 1662189920 on dm-1).
raid5:md3: read error not correctable (sector 1662189928 on dm-1).
raid5:md3: read error not correctable (sector 1662189936 on dm-1).
raid5:md3: read error not correctable (sector 1662189944 on dm-1).
ata8: EH complete
sd 7:0:0:0: [sdh] 2930277168 512-byte hardware sectors: (1.50 TB/1.36 TiB)
sd 7:0:0:0: [sdh] Write Protect is off
sd 7:0:0:0: [sdh] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support 
DPO 
or FUA
sd 7:0:0:0: [sdh] 2930277168 512-byte hardware sectors: (1.50 TB/1.36 TiB)
sd 7:0:0:0: [sdh] Write Protect is off
sd 7:0:0:0: [sdh] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support 
DPO 
or FUA
RAID5 conf printout:
 --- rd:12 wd:10
 disk 0, o:1, dev:sda4
 disk 1, o:1, dev:sdb4
 disk 2, o:1, dev:sdc4
 disk 3, o:1, dev:sdd4
 disk 4, o:1, dev:dm-0
 disk 5, o:1, dev:sdf4
 disk 6, o:1, dev:sdg4
 disk 7, o:0, dev:dm-1
 disk 8, o:1, dev:sdi4
 disk 9, o:1, dev:sdj4
 disk 10, o:1, dev:sdk4
 disk 11, o:1, dev:sdl4
RAID5 conf printout:
 --- rd:12 wd:10
 disk 0, o:1, dev:sda4
 disk 1, o:1, dev:sdb4
 disk 2, o:1, dev:sdc4
 disk 3, o:1, dev:sdd4
 disk 4, o:1, dev:dm-0
 disk 5, o:1, dev:sdf4
 disk 6, o:1, dev:sdg4
 disk 7, o:0, dev:dm-1
 disk 8, o:1, dev:sdi4
 disk 9, o:1, dev:sdj4
 disk 10, o:1, dev:sdk4
 disk 11, o:1, dev:sdl4
RAID5 conf printout:
 --- rd:12 wd:10
 disk 0, o:1, dev:sda4
 disk 1, o:1, dev:sdb4
 disk 2, o:1, dev:sdc4
 disk 3, o:1, dev:sdd4
 disk 4, o:1, dev:dm-0
 disk 5, o:1, dev:sdf4
 disk 6, o:1, dev:sdg4
 disk 7, o:0, dev:dm-1
 disk 8, o:1, dev:sdi4
 disk 9, o:1, dev:sdj4
 disk 10, o:1, dev:sdk4
 disk 11, o:1, dev:sdl4
RAID5 conf printout:
 --- rd:12 wd:10
 disk 0, o:1, dev:sda4
 disk 1, o:1, dev:sdb4
 disk 2, o:1, dev:sdc4
 disk 3, o:1, dev:sdd4
 disk 4, o:1, dev:dm-0
 disk 5, o:1, dev:sdf4
 disk 6, o:1, dev:sdg4
 disk 8, o:1, dev:sdi4
 disk 9, o:1, dev:sdj4
 disk 10, o:1, dev:sdk4
 disk 11, o:1, dev:sdl4
md: recovery of RAID array md3
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 
KB/sec) 
for recovery.
md: using 128k window, over a total of 1462653888 blocks.
md: resuming recovery of md3 from checkpoint.

md3 : active raid6 sdd4[12] sdl4[11] sdk4[10] sdj4[9] sdi4[8] dm-1[13](F) 
sdg4[6] sdf4[5] dm-0[4] sdc4[2] sdb4[1] sda4[0]
      14626538880 blocks level 6, 16k chunk, algorithm 2 [12/10] 
[UUU_UUU_UUUU]
      [===============>.....]  recovery = 75.3% (1101853312/1462653888) 
finish=292.3min speed=20565K/sec

du -h /sna*
1.1M    /snapshot2.bin
1.1M    /snapshot.bin

df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md1               19G   16G  3.5G  82% /
/dev/md0               99M   34M   60M  36% /boot
tmpfs                 2.0G     0  2.0G   0% /dev/shm

This is the actual state. :-(
In this way, the sync will stop again at 97.9%.

Another idea?
Or how to solve this dm-snapshot thing?

I think i know how can this be:
If i am right, the sync uses normal block size like usually wich is 4Kbyte 
in linux.
But the bad blocks are 512 bytes.
lets see for example one 4K window:
[BGBGBBGG] B: bad G: good sector
The sync reads up the block, the reported state is UNC because the drive 
reported UNC for some sector in this area.
The md recalculates the first 512byte bad block because the address is the 
same like the 4K block, than re-write it.
Than re-read the 4K block wich is still UNC because the 3rd sector is bad.
Can this be the issue?

Thanks,
Janos

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 

