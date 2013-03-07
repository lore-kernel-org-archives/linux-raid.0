From: Dave Cundiff <syshackmin@gmail.com>
Subject: Re: Raid 5/10 discard support broken in 3.8.2
Date: Thu, 7 Mar 2013 12:08:43 -0500
Message-ID: <CAKHEz2bGDyb2=t5gVycfm9YJcUu9k9943JYQFxAtStwrjehUbg@mail.gmail.com>
References: <CAKHEz2a+gwCzj16s3P3UOFMezC=CFe3D2002yyNsA_E5+-Ci6Q@mail.gmail.com>
	<18656028.2.1362650559146.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18656028.2.1362650559146.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Mar 7, 2013 at 5:02 AM, Roy Sigurd Karlsbakk <roy@karlsbakk.net> wrote:
>> It appears the Raid 5/10 discard support does not work in the mainline
>> kernel.
>>
>> I've been trying to backport it to a RHEL 6 kernel without success. I
>> finally managed to setup a mainline dev box and discovered it doesn't
>> work on it either!
>>
>> I'm now testing on a stock 3.8.2 kernel. The drives I'm using are
>> Samsung 840 Pro's hanging off an LSI 9211-8i. No backplane and each
>> drive has a dedicated channel. No RAID on the LSI, its just an HBA.
>
> I'm not sure if TRIM/UNMAP is supported on that controller, even in HBA mode (and with IT firmware). I've also seen scterc fail to work on that controller as well, while working with an ordinary "stupid" controller on the same disk.
>

I had heard that as well. I believe it may have been only older
firmware or maybe just people trying to TRIM against a RAID. I'm
running recent firmware and it appears to execute the command
correctly against a single disk.

[root@a2simage:etc]$ mkfs.ext4 /dev/sda3
mke2fs 1.41.12 (17-May-2010)
Discarding device blocks: ^C825792/54624256


Mar  7 11:53:08 66 kernel: sd 0:0:0:0: [sda] Send:
Mar  7 11:53:08 66 kernel: 0xffff8805edd86c80
Mar  7 11:53:08 66 kernel: sd 0:0:0:0: [sda] CDB:
Mar  7 11:53:08 66 kernel: Unmap/Read sub-channel: 42 00 00 00 00 00 00 00 18 00
Mar  7 11:53:08 66 kernel: buffer = 0xffff88062fe4a280, bufflen = 24,
queuecommand 0xffffffffa01d27e0
Mar  7 11:53:08 66 kernel: leaving scsi_dispatch_cmnd()
Mar  7 11:53:08 66 kernel: sd 0:0:0:0: [sda] Done:
Mar  7 11:53:08 66 kernel: 0xffff8805edd86c80 SUCCESS
Mar  7 11:53:08 66 kernel: sd 0:0:0:0: [sda]
Mar  7 11:53:08 66 kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Mar  7 11:53:08 66 kernel: sd 0:0:0:0: [sda] CDB:
Mar  7 11:53:08 66 kernel: Unmap/Read sub-channel: 42 00 00 00 00 00 00 00 18 00
Mar  7 11:53:08 66 kernel: sd 0:0:0:0: [sda] scsi host busy 1 failed 0
Mar  7 11:53:08 66 kernel: sd 0:0:0:0: Notifying upper driver of
completion (result 0)
Mar  7 11:53:08 66 kernel: sd 0:0:0:0: [sda]
Mar  7 11:53:08 66 kernel: Result: hostbyte=DID_OK driverbyte=DRIVER_OK
Mar  7 11:53:08 66 kernel: 4194304 sectors total, -2147483648 bytes done.

That negative bytes done number concerned me a little but it looks
likes its just a type issue in the printk. Its printing an unsigned
int as a signed.

--
Dave Cundiff
System Administrator
A2Hosting, Inc
http://www.a2hosting.com
