From: Sujit Karataparambil <sjt.kar@gmail.com>
Subject: Re: Raid and badblocks
Date: Sat, 30 May 2009 19:51:28 +0530
Message-ID: <921ca19c0905300721u7d2daaa7p3478d7cf78dd1334@mail.gmail.com>
References: <gv5q3p$vof$1@ger.gmane.org> <gv5qnk$1pe$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <gv5qnk$1pe$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeremy Sanders <jss@ast.cam.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>We have a linux RAID 5 md setup with 10 disks controlled using a 3ware
>>9650se card. Here is /proc/mdstat:

>>Personalities : [raid6] [raid5] [raid4]
>>md0 : active raid5 sdb1[0] sdk1[9] sdj1[8] sdi1[7] sdh1[6] sdg1[5] sdf1[4]
>>sde1[3] sdd1[2] sdc1[1]
    >> 8788959360 blocks level 5, 32k chunk, algorithm 2 [10/10] [UUUUUUUUUU]
Above the Raid Configuration. (Cut and Paste and other info)

> 3w-9xxx: scsi4: ERROR: (0x03:0x0202): Drive ECC error:port=8.
> sd 4:0:8:0: [sdj] Unhandled sense code
> sd 4:0:8:0: [sdj] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
> sd 4:0:8:0: [sdj] Sense Key : Medium Error [current]
> sd 4:0:8:0: [sdj] Add. Sense: Unrecovered read error

3ware 9650se card/check whether the drive on sdj is plugged in properly.
since the error is  sd 4:0:8:0: [sdj] Unhandled sense code. Probably an jumper.
But why does the error come up as read error. Is the read error given priority/
precedence over write error in the hardware?

> end_request: I/O error, dev sdj, sector 1953102848
> 3w-9xxx: scsi4: ERROR: (0x03:0x0202): Drive ECC error:port=8.
> sd 4:0:8:0: [sdj] Unhandled sense code
> sd 4:0:8:0: [sdj] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
> sd 4:0:8:0: [sdj] Sense Key : Medium Error [current]
> sd 4:0:8:0: [sdj] Add. Sense: Unrecovered read error
3ware 9650se card. Same here.

> end_request: I/O error, dev sdj, sector 1953102856
> Buffer I/O error on device sdj, logical block 244137857
> Buffer I/O error on device sdj, logical block 244137858
> Buffer I/O error on device sdj, logical block 244137859
> Buffer I/O error on device sdj, logical block 244137860
> Buffer I/O error on device sdj, logical block 244137861
> Buffer I/O error on device sdj, logical block 244137862
> Buffer I/O error on device sdj, logical block 244137863
> Buffer I/O error on device sdj, logical block 244137864
> Buffer I/O error on device sdj, logical block 244137865
> Buffer I/O error on device sdj, logical block 244137866

This is an read error as the disk is being added to the raid.
Here the sector and logical block is being looked for.

> 3w-9xxx: scsi4: ERROR: (0x03:0x0202): Drive ECC error:port=8.
> sd 4:0:8:0: [sdj] Unhandled sense code
> sd 4:0:8:0: [sdj] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
> sd 4:0:8:0: [sdj] Sense Key : Medium Error [current]
> sd 4:0:8:0: [sdj] Add. Sense: Unrecovered read error
> end_request: I/O error, dev sdj, sector 1953103080
> 3w-9xxx: scsi4: ERROR: (0x03:0x0202): Drive ECC error:port=8.
> sd 4:0:8:0: [sdj] Unhandled sense code
> sd 4:0:8:0: [sdj] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
> sd 4:0:8:0: [sdj] Sense Key : Medium Error [current]
> sd 4:0:8:0: [sdj] Add. Sense: Unrecovered read error
> end_request: I/O error, dev sdj, sector 1953103080
> 3w-9xxx: scsi4: ERROR: (0x03:0x0202): Drive ECC error:port=8.
> sd 4:0:8:0: [sdj] Unhandled sense code
> sd 4:0:8:0: [sdj] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
> sd 4:0:8:0: [sdj] Sense Key : Medium Error [current]
> sd 4:0:8:0: [sdj] Add. Sense: Unrecovered read error

3ware 9650se card. Same Here.

> end_request: I/O error, dev sdj, sector 1953103080
> __ratelimit: 24 callbacks suppressed
> Buffer I/O error on device sdj, logical block 244137885

Sector and block info.

> 3w-9xxx: scsi4: ERROR: (0x03:0x0202): Drive ECC error:port=8.
> sd 4:0:8:0: [sdj] Unhandled sense code
> sd 4:0:8:0: [sdj] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
> sd 4:0:8:0: [sdj] Sense Key : Medium Error [current]
> sd 4:0:8:0: [sdj] Add. Sense: Unrecovered read error

Same here.
> end_request: I/O error, dev sdj, sector 1953103080
> Buffer I/O error on device sdj, logical block 244137885
> md: requested-resync of RAID array md0
> md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> md: using maximum available idle IO bandwidth (but not more than 200000
> KB/sec) for requested-resync.
> md: using 128k window, over a total of 976551040 blocks.
> md: md0: requested-resync done.

is it printing out information regarding minimum/optimal speed/IO bandwidth
due to the an failed/partially failed device.
>
>
> --
> Jeremy Sanders <jss@ast.cam.ac.uk>   http://www-xray.ast.cam.ac.uk/~jss/
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
-- Sujit K M
