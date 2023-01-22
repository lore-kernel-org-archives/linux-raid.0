Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C005DC25B4E
	for <linux-raid@archiver.kernel.org>; Sun, 22 Jan 2023 05:05:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjAVFFm convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 22 Jan 2023 00:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjAVFFm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 22 Jan 2023 00:05:42 -0500
Received: from mout.perfora.net (mout.perfora.net [74.208.4.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF26B18A97
        for <linux-raid@vger.kernel.org>; Sat, 21 Jan 2023 21:05:40 -0800 (PST)
Received: from android-e41ce0186a96148b.home ([72.94.51.172]) by
 mrelay.perfora.net (mreueus004 [74.208.5.2]) with ESMTPSA (Nemesis) id
 1MIxeQ-1p09Xt2jF4-00KTvc for <linux-raid@vger.kernel.org>; Sun, 22 Jan 2023
 06:05:39 +0100
Date:   Sun, 22 Jan 2023 00:05:29 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <deafcb4a-ed1c-d0b3-c9f9-c0a99867bb7a@meddatainc.com>
References: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com> <deafcb4a-ed1c-d0b3-c9f9-c0a99867bb7a@meddatainc.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: Transferring an existing system from non-RAID disks to RAID1 disks in the same computer
To:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
From:   H <agents@meddatainc.com>
Message-ID: <3CEAC9AB-02FC-43BE-94CF-ED3ECFF6F4F7@meddatainc.com>
X-Provags-ID: V03:K1:UlYo08Muzw/w2ZS6pAm7xAljBHw/E+TPp5Xtm2C4h5fWRswlUPu
 Qr/Klseyq4zD/MpOe5uPRnte6vnVe1Xjsmx3l11THIoGu2hexNa0WdY1GMKArHy8xygx+G3
 Jcg7EpT3JwWM+ShLhLX9mJNCRmZYhhVcN6AUUWOuzKY06c9oAP7X495LL0H5e3on4cVgJT2
 iW5Gzp7RcNvTc8C8Ob37Q==
UI-OutboundReport: notjunk:1;M01:P0:BwcvNzrBpfs=;VVWwp00+u1C+RZqW61TzbjcFsHf
 K0Z62bcJ6RHEnUwxH2HMkETYMaOljD97zSXCczdO8VqapPDaZeATTjyp4gk6XMUWZHZVV9IIk
 b3Drox/lakEFHk3xpEGag0o463B7qWilIpc4lY/q/hifq/Mdl0mhAvqPl7oZofrzDQepFQpE0
 YjxCaUhVGN2rL49pzaNyPftxlawDJOHiX9HC9+cX7Bfg32M7cZ08IkOLu5AHDhAVrmH/GtDlj
 w1ZcBFhiOxnZOYsvd8DPyCe6eZtAwEiqsZu7ssd/g/lG0LrVtbSkhLcof+UwBK92ecm0r5v2A
 F/G1ma3RGRfgPw0DUVzGP5H+aSmbkvW0oAH7CJ+kZqsKE7MY3yJG3oexXKVwbXOBq5rBb3W42
 1EbrCgsjDivyehjH2oksWM8cTGyzBvwTVM7GjLh7RCY/0nGhDU/+vn6O5JYBqIMQFVQBnhw6Z
 ky5VWYe9u2Grd4xiGq2eumxfAUxFhCsOYEOJF5Bd3on6/mONKf+aiHVPIj2mBuf1y4ShfRn/E
 Oymdz6gnsfps9mzQ+bdRiDUCLz9hMnjND9uZkhEVTld7WNUZkeoewsgSjULDW5gBP/FFzd2YO
 uVc6tHxk/8CxOVeKx+l6k3mk09+81I6sVBE3w5yDbL6qwCBzbxYwYDpvh35nOEoJFLOsRi4/3
 LBi24tG1ySV+KIbYIOmsXBl5kGhmbWE945vzAdNDEw==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On January 15, 2023 12:25:11 PM EST, H <agents@meddatainc.com> wrote:
>On 01/14/2023 10:12 PM, H wrote:
>> I need to transfer an existing CentOS 7 non-RAID setup using one
>single SSD to a mdadm RAID1 using two much larger SSDs. All three disks
>exist in the same computer at the same time. Both the existing SSD and
>the new ones use LVM and LUKS and the objective is to preserve the OS,
>all other installed software and data etc. Thus no new installation
>should be needed.
>>
>> Since all disks, partitions, LUKS etc have their unique UUIDs I have
>not figured out how to do this and could use help and advice.
>>
>> In preparation for the above, I have:
>>
>> - Used rsync with the flags -aAXHv to copy all files on the existing
>SSD to an external harddisk for backup.
>>
>> - Partitioned the new SSDs as desired, including LVM and LUKS. My
>configuration uses one RAID1 for /boot, another RAID1 partition for
>/boot/efi, and a third one for the rest which also uses LVM and LUKS. I
>actually used a DVD image of Centos 7 (minimal installation) to
>accomplish this which also completed the minimal installation of the OS
>on the new disks. It boots as expected and the RAID partitions seem to
>work as expected.
>>
>> Since I want to actually move my existing installation from the
>existing SSDs, I am not sure whether I should just use rsync to copy
>everything from the old SSD to the new larger ones. However, I expect
>that to also transfer all OS files using the old, now incorrect UUIDs,
>to the new disks after which nothing will work, thus I have not yet
>done that. I could erase the minimal installation of the OS on the new
>disks before rsyncing but have not yet done so.
>>
>> I fully expect to have to do some manual editing of files but am not
>quite sure of all the files I would need to edit after such a copy. I
>have some knowledge of linux but could use some help and advice. For
>instance, I expect that /etc/fstab and /etc/crypttab would need to be
>edited reflecting the UUIDs of the new disks, partitions and LUKS, but
>which other files? Grub2 would also need to be edited I would think.
>>
>> The only good thing is that since both the old disk and the new disks
>are in the same computer, no other hardware will change.
>>
>> Is there another, better (read: simpler) way of accomplishing this
>transfer?
>>
>> Finally, since I do have a backup of the old SSD and there is nothing
>of value on the new mdadm RAID1 disks, except the partition
>information, I do have, if necessary, the luxury of multiple tries.
>What I cannot do, however, is to make any modifications to the existing
>old SSD since I cannot afford not being able to go back to the old SSD
>if necessary.
>>
>> Thanks.
>>
>>
>Upon further thinking, I am wondering if the process below would work?
>As stated above, I have two working disk setups in the same computer
>and depending on the order of disks in the BIOS I can boot any of the
>two setups.
>
>My existing setup uses one disk and no RAID (obviously), LUKS and LVM
>for everything but /boot and /boot/efi, total of three partitions. The
>OS is Centos 7 and I have made a complete backup to an external
>harddisk using rsync ("BACKUP1").
>
>The new one uses two disks, RAID1, LUKS and LVM for everything but
>/boot and /boot/efi, total of four partitions (swap has its own
>partition - not sure why I made it that way). A minimal installation of
>Centos 7 was made to this setup and is working. In other words, UUIDs
>of disks, partitions and LUKS are already configured and working.
>
>So, I am now thinking the following might work:
>
>- Make a rsync backup of the new disks to the external harddisk
>("BACKUP2").
>
>- Delete all files from the new disks except from /boot and /boot/efi.
>
>- Copy all files from all partitions except /boot and /boot/efi from
>BACKUP1 to the new disks. In other words, everything except /boot and
>/boot/efi will now be overwritten.
>
>- I would expect this system not to boot since both /etc/fstab and
>/etc/crypttab on the new disks contain the UUIDs from the old system.
>
>- Copy just /etc/fstab and /etc/crypttab from BACKUP2 to the new disks.
>This should update the new disks with the previously created UUIDs from
>when doing the minimal installation of CentOS 7.
>
>What do you think?

I am happy to share that my plan as outlined below worked. I now have /boot, /boot/efi and / on separate RAID partitions with the latter managed by LVM and encrypted.  All data from the old disk is now on the new setup and everything seems to be working.

However, going back to the issue of /boot/efi possibly not being duplicated by CentOS, would not mdadm take care of that automatically? How can I check?
