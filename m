Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 399F9C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 27 Apr 2022 12:53:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234835AbiD0M4Q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Apr 2022 08:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234805AbiD0M4P (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 27 Apr 2022 08:56:15 -0400
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A42412C38E4
        for <linux-raid@vger.kernel.org>; Wed, 27 Apr 2022 05:53:02 -0700 (PDT)
Date:   Wed, 27 Apr 2022 12:52:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail2; t=1651063976;
        bh=KDdLrv5EfcUrhPbmRSfRvjHye0lN36xO4PIbSmG0bx4=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:Feedback-ID:From:To:Cc:Date:Subject:Reply-To:
         Feedback-ID:Message-ID;
        b=gjigyNK5GxlL9XgZcp+niKyvOwhucjawc7JG1XbHNivNRewyjyDD+3yXZ9lI7Tqvg
         n5NnFcLY0QNdKFSuU2DzQ22+nX+7VG8V+QQKHmM+8l3OZ7Dlm8KJ79rKbzkBRXCDIE
         IHRkzzI29e+bQCd0AECiOFYjfEA1ctJiiONXeHJ0Y2l7lnkG1j8lGmAO4F9v+aGdsY
         Y9nJ5NydwnDTDQ8u+dBB+AcHGwSu7lk9tnA5vca/hYu8N+e0STjFfrrS6Q60UnDtLM
         NUzcEW3H+kMiCZAenekLXa0zfd+ydmJi9qlVgYTwqEIiP5W5d1aM5jzbuXQ5ydlCaE
         auDzWSb5Jf4gQ==
To:     John Stoffel <john@stoffel.org>
From:   Turritopsis Dohrnii Teo En Ming <teo.en.ming@protonmail.com>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "ceo@teo-en-ming-corp.com" <ceo@teo-en-ming-corp.com>
Reply-To: Turritopsis Dohrnii Teo En Ming <teo.en.ming@protonmail.com>
Subject: Re: arcconf Linux utility for Adaptec AAC-RAID (Rocket) (rev 02) (IBM ServeRAID 8k/8k-l8) unable to query RAID controller
Message-ID: <4BqR3yh3u2oLB5l0ijV_SHkfelzfUrDeubspiYm-i3t4pq-sXdqKN1f_McQDQsarCjwT0iPFZcMDSOB2NK67m2LQIWUkwZYI-70nrGKPne8=@protonmail.com>
In-Reply-To: <25190.46802.519914.353774@quad.stoffel.home>
References: <iddAq1G1O5s0ZaXiG770cpphw7qFQJvJxEpC9C6KNBOPlTh3tisL-yqiUeWxokp-rHBqFCovWBDJdDea1B48qzcD1YCeipV3M7sKtGiX21o=@protonmail.com> <25189.52847.196112.389335@quad.stoffel.home> <BI8tpiYl62HTeDCz8Bge5mtCTJsyLb3NVNl2W69b6WKm2OSMg6_bUnJroS3ttUFAhT4gxLP36lvRJH0180JbvfB3JVKtXf1JEkLJ5THdcHU=@protonmail.com> <25190.46802.519914.353774@quad.stoffel.home>
Feedback-ID: 39510961:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear John Stoffel,

Our client has informed us that they are migrating their application to the=
 cloud and this server will be decommissioned in the near future.

As such, we will not continue with troubleshooting this issue.

Thank you for your replies.

Regards,

Mr. Turritopsis Dohrnii Teo En Ming
Targeted Individual in Singapore
27 April 2022 Wednesday










Sent with ProtonMail secure email.
------- Original Message -------
On Monday, April 25th, 2022 at 10:57 PM, John Stoffel <john@stoffel.org> wr=
ote:


> Turritopsis> I have executed the following command on my client's
>
> Turritopsis> CentOS 6.10 32-bit Linux server.
>
>
> Turritopsis> # badblocks -sv /dev/sda
>
>
> Turritopsis> And found 512 bad blocks.
>
>
> Yup, you've got a bad array, either one or more disks is going bad.
> You need to backup this data ASAP to another disk somewhere else, so
> you can then work on repairing or replacing the bad disk in the RAID
> array.
>
> Since you say it's RAID5, and only three disks, you don't have much
> redundancy, and because you're seeing bad blocks at the level of the
> array (not the inidividual disks) then I think it's only a matter of
> time before you lose data.
>
> I also strongly encourage you to change the setup of the system to not
> use a hardware based RAID controller. As you can see now, when you
> start having problems, unless you have the right vendor tools, then
> you might not have any support to make figuring out what has gone
> wrong.
>
> Go look at this web page, it might be helpful for you.
>
> https://www.cyberciti.biz/faq/linux-checking-sas-sata-disks-behind-adapte=
c-raid-controllers/
>
> Or this might help:
>
> https://storage.microsemi.com/en-us/downloads/storage_manager/sm/producti=
d=3Daar-2820sa&dn=3Dadaptec+serial+ata+ii+raid+2820sa.html
>
> Good luck!
> John
>
>
> Turritopsis> ------- Original Message -------
>
> Turritopsis> On Monday, April 25th, 2022 at 6:25 AM, John Stoffel john@st=
offel.org wrote:
>
>
>
> > > > > > > > "Turritopsis" =3D=3D Turritopsis Dohrnii Teo En Ming teo.en=
.ming@protonmail.com writes:
>
> Turritopsis> Subject: arcconf Linux utility for Adaptec AAC-RAID
>
> Turritopsis> (Rocket) (rev 02) (IBM ServeRAID 8k/8k-l8) unable to
>
> Turritopsis> query RAID controller Good day from Singapore,
>
> Turritopsis> Our client has IBM System x3650 server (machine type:
>
> Turritopsis> 7979). Operating system is CentOS Linux 6.10 (32-bit).
>
> > > Ancient... you're running old mdadm code and kernel... and if it's
> > > critical enough, you could/might be able to get support from Redhat i=
f
> > > you pay them enough... and since it's a hardware RAID controller card=
,
> > > mdadm and Linux Raid isn't doing anything here, so we're really the
> > > wrong group to ask for help. But see below...
>
> Turritopsis> Recently we keep getting the following error messages
>
> Turritopsis> (output generated by dmesg).
>
> > > These errors look to be a bad sector on one of the disks. But since
> > > you're also using a hardware RAID controller... I would copy your dat=
a
> > > off ASAP onto some new media before you lose any thing more.
> > >
> > > Just ask them how much it will cost to keep the business running if
> > > they complain about the cost of three replacement disks on the
> > > system.
> > >
> > > But basically, I would:
> > >
> > > 0. copy the data somewhere else, especially if it's critical
> > > 1. copy the data somewhere else, especially if it's critical.
> > > 2. Try running 'badblocks' on /dev/sda to see if you can force it to
> > > re-write bad sectors. See man page for flags to use.
> > > 3. You can also try to boot the system to the BIOS and see if there's
> > > a BIOS screen for the AAC-RAID controller which lets you scrub the
> > > array or look for bad blocks.
> > >
> > > Good luck,
> > > John
>
> Turritopsis> <CODE>
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 09 2a d1 50 00 02 00=
 00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380104=
0
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 09 2a cf 50 00 02 00=
 00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380052=
8
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Write(10): 2a 00 09 2a d3 50 00 02 00=
 00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380155=
2
>
> Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>
> Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>
> Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>
> Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>
> Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>
> Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>
> Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>
> Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>
> Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>
> Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>
> Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>
> Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>
> Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>
> Turritopsis> JBD2: Detected IO errors while flushing file data on dm-0-8
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a cf 38 00 01 00 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380050=
4
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 38 00 01 00 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380076=
0
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 00 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380070=
4
>
> Turritopsis> </CODE>
>
> Turritopsis> /dev/sda is a RAID 5 array with 3 harddisks of 136.6 GB capa=
city each.
>
> Turritopsis> <CODE>
>
> Turritopsis> [root@teo-en-ming-server ~]# fdisk /dev/sda
>
> Turritopsis> WARNING: DOS-compatible mode is deprecated. It's strongly re=
commended to
>
> Turritopsis> switch off the mode (command 'c') and change display units t=
o
>
> Turritopsis> sectors (command 'u').
>
> Turritopsis> Command (m for help): p
>
> Turritopsis> Disk /dev/sda: 293.4 GB, 293378981888 bytes
>
> Turritopsis> 255 heads, 63 sectors/track, 35667 cylinders
>
> Turritopsis> Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
>
> Turritopsis> Sector size (logical/physical): 512 bytes / 512 bytes
>
> Turritopsis> I/O size (minimum/optimal): 512 bytes / 512 bytes
>
> Turritopsis> Disk identifier: 0x8b047782
>
> Turritopsis> Device Boot Start End Blocks Id System
>
> Turritopsis> /dev/sda1 * 1 64 512000 83 Linux
>
> Turritopsis> Partition 1 does not end on cylinder boundary.
>
> Turritopsis> /dev/sda2 64 35668 285989888 8e Linux LVM
>
> Turritopsis> Command (m for help):
>
> Turritopsis> </CODE>
>
> Turritopsis> We rebooted the server several times. The next morning we st=
ill get the same error messages.
>
> Turritopsis> <CODE>
>
> Turritopsis> sd 0:0:0:0: [sda] 573005824 512-byte logical blocks: (293 GB=
/273 GiB)
>
> Turritopsis> sd 0:0:0:0: [sda] Write Protect is off
>
> Turritopsis> sd 0:0:0:0: [sda] Mode Sense: 06 00 10 00
>
> Turritopsis> sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled=
, supports DPO and FUA
>
> Turritopsis> sda: sda1 sda2
>
> Turritopsis> sd 0:0:0:0: [sda] Attached SCSI removable disk
>
> Turritopsis> dracut: Scanning devices sda2 for LVM logical volumes vg_teo=
-en-ming-server/lv_swap vg_teo-en-ming-server/lv_root
>
> Turritopsis> EXT4-fs (sda1): mounted filesystem with ordered data mode. O=
pts:
>
> Turritopsis> SELinux: initialized (dev sda1, type ext4), uses xattr
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 00 00 00 80 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380070=
4
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 00 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380070=
4
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225088
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 00 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380070=
4
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225088
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 00 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380070=
4
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225088
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 00 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380070=
4
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225088
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 08 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380071=
2
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225089
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 08 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380071=
2
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225089
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 08 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380071=
2
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225089
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 08 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380071=
2
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225089
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d0 10 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380072=
0
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225090
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 10 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380097=
6
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 10 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380097=
6
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225122
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 10 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380097=
6
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225122
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 18 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380098=
4
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225123
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 18 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380098=
4
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225123
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 18 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380098=
4
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225123
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 18 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380098=
4
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225123
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 20 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380099=
2
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225124
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 20 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380099=
2
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225124
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d1 20 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380099=
2
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225124
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225124
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 28 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380125=
6
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 28 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380125=
6
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225157
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 28 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380125=
6
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225157
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 28 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380125=
6
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225157
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 30 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380126=
4
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225158
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 30 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380126=
4
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225158
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 30 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380126=
4
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225158
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 30 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380126=
4
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225158
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 38 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380127=
2
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225159
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d2 38 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380127=
2
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225159
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225159
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 30 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380152=
0
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 38 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380152=
8
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 38 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380152=
8
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225191
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 38 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380152=
8
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225191
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 38 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380152=
8
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225191
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 40 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380153=
6
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225192
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 40 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380153=
6
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225192
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 40 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380153=
6
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225192
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 40 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380153=
6
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225192
>
> Turritopsis> sd 0:0:0:0: [sda] Result: hostbyte=3DDID_OK driverbyte=3DDRI=
VER_SENSE
>
> Turritopsis> sd 0:0:0:0: [sda] Sense Key : Hardware Error [current]
>
> Turritopsis> sd 0:0:0:0: [sda] Add. Sense: Internal target failure
>
> Turritopsis> sd 0:0:0:0: [sda] CDB: Read(10): 28 00 09 2a d3 48 00 00 08 =
00
>
> Turritopsis> end_request: critical target error, dev sda, sector 15380154=
4
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225193
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225193
>
> Turritopsis> Buffer I/O error on device sda, logical block 19225193
>
> Turritopsis> </CODE>
>
> Turritopsis> Based on the following discussion thread, we think that the =
RAID controller may be failing.
>
> Turritopsis> Discussion thread: Which disk is bad in raid6 array
>
> Turritopsis> Link: https://serverfault.com/questions/384935/which-disk-is=
-bad-in-raid6-array
>
> Turritopsis> I had downloaded 32-bit arcconf Linux utility from the follo=
wing link.
>
> Turritopsis> Link: https://hwraid.le-vert.net/wiki/Adaptec
>
> Turritopsis> <CODE>
>
> Turritopsis> [root@teo-en-ming-server log]# lspci -vvv | grep RAID
>
> Turritopsis> 04:00.0 RAID bus controller: Adaptec AAC-RAID (Rocket) (rev =
02)
>
> Turritopsis> Subsystem: IBM ServeRAID 8k/8k-l8
>
> Turritopsis> </CODE>
>
> Turritopsis> However, we keep getting segmentation fault running arcconf =
utility.
>
> Turritopsis> <CODE>
>
> Turritopsis> [root@teo-en-ming-server log]# /usr/local/sbin/arcconf getco=
nfig 1
>
> Turritopsis> Segmentation fault (core dumped)
>
> Turritopsis> </CODE>
>
> Turritopsis> These are the Linux Kernel messages.
>
> Turritopsis> <CODE>
>
> Turritopsis> Apr 22 11:11:33 teo-en-ming-server kernel: aacraid: Host ada=
pter abort request (0,0,0,0)
>
> Turritopsis> Apr 22 11:11:33 teo-en-ming-server kernel: aacraid: Host ada=
pter reset request. SCSI hang ?
>
> Turritopsis> Apr 22 11:11:33 teo-en-ming-server kernel: AAC: Host adapter=
 BLINK LED 0x4
>
> Turritopsis> Apr 22 11:11:33 teo-en-ming-server kernel: AAC0: adapter ker=
nel panic'd 4.
>
> Turritopsis> Apr 22 11:12:23 teo-en-ming-server kernel: IRQ 17/aacraid: I=
RQF_DISABLED is not guaranteed on shared IRQs
>
> Turritopsis> Apr 22 11:14:37 teo-en-ming-server kernel: aacraid: Host ada=
pter abort request (0,0,0,0)
>
> Turritopsis> Apr 22 11:14:37 teo-en-ming-server kernel: aacraid: Host ada=
pter reset request. SCSI hang ?
>
> Turritopsis> Apr 22 11:14:37 teo-en-ming-server kernel: AAC: Host adapter=
 BLINK LED 0x4
>
> Turritopsis> Apr 22 11:14:37 teo-en-ming-server kernel: AAC0: adapter ker=
nel panic'd 4.
>
> Turritopsis> Apr 22 11:15:28 teo-en-ming-server kernel: IRQ 17/aacraid: I=
RQF_DISABLED is not guaranteed on shared IRQs
>
> Turritopsis> Apr 22 11:16:34 teo-en-ming-server kernel: aacraid: Host ada=
pter abort request (0,0,0,0)
>
> Turritopsis> Apr 22 11:16:34 teo-en-ming-server kernel: aacraid: Host ada=
pter reset request. SCSI hang ?
>
> Turritopsis> Apr 22 11:16:34 teo-en-ming-server kernel: AAC: Host adapter=
 BLINK LED 0x4
>
> Turritopsis> Apr 22 11:16:34 teo-en-ming-server kernel: AAC0: adapter ker=
nel panic'd 4.
>
> Turritopsis> </CODE>
>
> Turritopsis> It seems that I could not query the RAID controller. It keep=
s saying that the RAID controller adapter has kernel panics.
>
> Turritopsis> arcconf is a Linux utility to query the RAID controller.
>
> Turritopsis> <CODE>
>
> Turritopsis> [root@teo-en-ming-server cmdline]# lspci -nn | grep RAID
>
> Turritopsis> 04:00.0 RAID bus controller [0104]: Adaptec AAC-RAID (Rocket=
) [9005:0286] (rev 02)
>
> Turritopsis> </CODE>
>
> Turritopsis> Do you know why I keep getting segmentation fault running ar=
cconf Linux utility?
>
> Turritopsis> Regards,
>
> Turritopsis> Mr. Turritopsis Dohrnii Teo En Ming
>
> Turritopsis> Targeted Individual in Singapore
>
> Turritopsis> 24 April 2022 Sunday
