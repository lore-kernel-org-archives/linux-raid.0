From: "Boylan, Ross" <Ross.Boylan@ucsf.edu>
Subject: RE: sector size mismatch a problem for RAID 1?
Date: Fri, 3 Feb 2017 06:18:49 +0000
Message-ID: <d05e3579-38c4-40bd-8fb4-d296fc3ea9c5@EXHT02.net.ucsf.edu>
References: <3dcb5a7a-9bd4-4cfd-a655-91a88692c549@EXHT01.net.ucsf.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3dcb5a7a-9bd4-4cfd-a655-91a88692c549@EXHT01.net.ucsf.edu>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

When I moved the new disk to an internal drive bay (after reading lvm-raid wiki's statements that RAID shouldn't be used over a USB link) the problems went away--at least so far.

I wonder if this  is the source of my original problem: I was using a single disk RAID1 where the single disk had a USB connection.  However, I did get a failure off that drive doing a dd off the raw device.


Ross
________________________________________
From: linux-raid-owner@vger.kernel.org [linux-raid-owner@vger.kernel.org] on behalf of Boylan, Ross [Ross.Boylan@ucsf.edu]
Sent: Thursday, February 02, 2017 4:17 PM
To: linux-raid@vger.kernel.org
Subject: sector size mismatch a problem for RAID 1?

I got a replacement  for a failing disk, but the 2 drives seems to have slightly different formatting:
For the failing one
GNU Parted 2.3
Using /dev/sdb
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) p
Model: WDC WD40 01FFSX-68JNUN0 (scsi)
Disk /dev/sdb: 4001GB
Sector size (logical/physical): 512B/4096B <<<------
Partition Table: gpt

And the replacement (sdk)
Model: WDC WD40 01FFSX-68JNUN0 (scsi)
Disk /dev/sdk: 7814037168s
Sector size (logical/physical): 512B/512B <<<<-----
Partition Table: gpt

So the first is 4k physical, and the second is 512b physical (I assume that's really a fib, but it's what the drive says).

Could the mismatch in the physical sizes cause trouble?

I ask because I did this:
mdadm --grow /dev/md/media4 --add /dev/sdk2 --raid-devices=2
which resulted in
the Feb  2 15:26:46 tempserver kernel: [ 8583.545160] md: bind<sdk2>
Feb  2 15:26:46 tempserver kernel: [ 8583.957047] RAID1 conf printout:
Feb  2 15:26:46 tempserver kernel: [ 8583.957051]  --- wd:1 rd:2
Feb  2 15:26:46 tempserver kernel: [ 8583.957052]  disk 0, wo:0, o:1, dev:sdb2
Feb  2 15:26:46 tempserver kernel: [ 8583.957054]  disk 1, wo:1, o:1, dev:sdk2
Feb  2 15:26:46 tempserver kernel: [ 8583.957108] md: recovery of RAID array md126
Feb  2 15:26:46 tempserver kernel: [ 8583.957111] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Feb  2 15:26:46 tempserver kernel: [ 8583.957112] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
Feb  2 15:26:46 tempserver kernel: [ 8583.957115] md: using 128k window, over a total of 1953376064k.
Feb  2 15:26:50 tempserver kernel: [ 8587.312261] usb 2-3: USB disconnect, device number 4
Feb  2 15:26:50 tempserver kernel: [ 8587.315908] scsi 8:0:0:3: rejecting I/O to offline device
Feb  2 15:26:50 tempserver kernel: [ 8587.315912] scsi 8:0:0:3: [sdk] killing request
Feb  2 15:26:50 tempserver kernel: [ 8587.315934] scsi 8:0:0:3: [sdk] Unhandled error code
Feb  2 15:26:50 tempserver kernel: [ 8587.315936] scsi 8:0:0:3: [sdk]
Feb  2 15:26:50 tempserver kernel: [ 8587.315939] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Feb  2 15:26:50 tempserver kernel: [ 8587.315941] scsi 8:0:0:3: [sdk] CDB:
Feb  2 15:26:50 tempserver kernel: [ 8587.315943] Write(16): 8a 00 00 00 00 00 00 0c 3e 80 00 00 00 80 00 00
Feb  2 15:26:50 tempserver kernel: [ 8587.315951] end_request: I/O error, dev sdk, sector 802432
Feb  2 15:26:50 tempserver kernel: [ 8587.315963] md/raid1:md126: Disk failure on sdk2, disabling device.
Feb  2 15:26:50 tempserver kernel: [ 8587.315963] md/raid1:md126: Operation continuing on 1 devices.result of which from kern.log was
I then tried
 dd if=/dev/disk/by-id/ata-WDC_WD4001FFSX-68JNUN0_WD-WMC130FACU91 of=/dev/null skip=802500 count=1000
which produced no error.  The input is from the device previously known as sdk.  So I can at least read from the sector that was associated with the error message above.

BTW, the array I'm trying to mirror is on a part of the disk that I think is still good.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
