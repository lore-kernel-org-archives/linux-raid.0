Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 165B2C63797
	for <linux-raid@archiver.kernel.org>; Sun, 15 Jan 2023 17:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjAORaS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 15 Jan 2023 12:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbjAORaQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 15 Jan 2023 12:30:16 -0500
X-Greylist: delayed 302 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 15 Jan 2023 09:30:15 PST
Received: from mout.perfora.net (mout.perfora.net [74.208.4.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FC7CC21
        for <linux-raid@vger.kernel.org>; Sun, 15 Jan 2023 09:30:15 -0800 (PST)
Received: from [192.168.1.7] ([72.94.51.172]) by mrelay.perfora.net
 (mreueus003 [74.208.5.2]) with ESMTPSA (Nemesis) id 0Ln8sF-1onoH73Bpl-00hMQ8
 for <linux-raid@vger.kernel.org>; Sun, 15 Jan 2023 18:25:12 +0100
Subject: Re: Transferring an existing system from non-RAID disks to RAID1
 disks in the same computer
From:   H <agents@meddatainc.com>
To:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
Message-ID: <deafcb4a-ed1c-d0b3-c9f9-c0a99867bb7a@meddatainc.com>
Date:   Sun, 15 Jan 2023 12:25:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:8DfzIAxgMI4QQBVeTOtySsRzMHgXC71XViDayIhgAP3F0BwRb4N
 QB6h7IIn9X0ofOaaVjb7opj0DVx8+cm1VrE3XQNVFYYQxWAih5aar0BdJhtWxLsraYr+ele
 n+oMdQD9XSaCXZioShN8jsv1cpLMzBaUywx35+VgZg7gPEbKuaMuyccwQZxfKoM1X5Co5a+
 0TzMw+yd9hz+Vl69CV9LQ==
UI-OutboundReport: notjunk:1;M01:P0:F2lPmNmHFUs=;9DAPPRfgc5QZVm2lC/am+i1pTPc
 JwzGn5mzxZgbhkiBX7YwruvUkWYFa1iRnhKWRtDu8WgrUoIQSZKpvbMGF278Fpf2WcaSRorE0
 FhnF+PKvv7f2ZGHE0gBG1P2ILoocRR5s7rY5eu56FapWLX6U41CH68mRYJXsZcTmSmgfHOfRC
 udboitybM8+jeO2HmvwT8FoYzMEM6yNSUYfue3XouVLJ9uX2IZQBFgNTegTYvR1UJ0P1unsaK
 Om7vox7EGM0oY/vL7YN+RIZMQKwyMP1ImOSic224ro70Ot2H7rFem4BqkpJoppdy2KP/J5/V+
 5iSXzm/Nz7faVw10vE1s1qL4iys4hxyekAsCFFhrufgpfipnym50yV0RJ3agYUSs/g2NJWXg9
 mVPLDnuMSUzp+Q2qc+z+MPfHCgoUFwtGjP5xnJMDUPW5bL/+HojeXgBndJ3FTcJIwj/+n8tTI
 LsvKYxgJp1CF6hFWG0WiL93dnodrZuZZsA0RivOtJLRWj/gLcgx6rLYZpu6ST0i9eTg3bFnbe
 eO5uMBEXZLQ21jwZL9N+5lH7AD2Pk8+Sz0szEYtG7q+Yn43Py/rzsY19yRx5pHvgFkwQsBQ2u
 pQYFIxRVcTGnw7LINqoD2AD33sTtm/GrXQnlO3rcnZVgmZAAJmU3ICNugyFzDWvoP0wooCfHC
 TtuSteolDXgX5f/r2p2YccLhAx4wc8sqG/3PXdSi3w==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 01/14/2023 10:12 PM, H wrote:
> I need to transfer an existing CentOS 7 non-RAID setup using one single SSD to a mdadm RAID1 using two much larger SSDs. All three disks exist in the same computer at the same time. Both the existing SSD and the new ones use LVM and LUKS and the objective is to preserve the OS, all other installed software and data etc. Thus no new installation should be needed.
>
> Since all disks, partitions, LUKS etc have their unique UUIDs I have not figured out how to do this and could use help and advice.
>
> In preparation for the above, I have:
>
> - Used rsync with the flags -aAXHv to copy all files on the existing SSD to an external harddisk for backup.
>
> - Partitioned the new SSDs as desired, including LVM and LUKS. My configuration uses one RAID1 for /boot, another RAID1 partition for /boot/efi, and a third one for the rest which also uses LVM and LUKS. I actually used a DVD image of Centos 7 (minimal installation) to accomplish this which also completed the minimal installation of the OS on the new disks. It boots as expected and the RAID partitions seem to work as expected.
>
> Since I want to actually move my existing installation from the existing SSDs, I am not sure whether I should just use rsync to copy everything from the old SSD to the new larger ones. However, I expect that to also transfer all OS files using the old, now incorrect UUIDs, to the new disks after which nothing will work, thus I have not yet done that. I could erase the minimal installation of the OS on the new disks before rsyncing but have not yet done so.
>
> I fully expect to have to do some manual editing of files but am not quite sure of all the files I would need to edit after such a copy. I have some knowledge of linux but could use some help and advice. For instance, I expect that /etc/fstab and /etc/crypttab would need to be edited reflecting the UUIDs of the new disks, partitions and LUKS, but which other files? Grub2 would also need to be edited I would think.
>
> The only good thing is that since both the old disk and the new disks are in the same computer, no other hardware will change.
>
> Is there another, better (read: simpler) way of accomplishing this transfer?
>
> Finally, since I do have a backup of the old SSD and there is nothing of value on the new mdadm RAID1 disks, except the partition information, I do have, if necessary, the luxury of multiple tries. What I cannot do, however, is to make any modifications to the existing old SSD since I cannot afford not being able to go back to the old SSD if necessary.
>
> Thanks.
>
>
Upon further thinking, I am wondering if the process below would work? As stated above, I have two working disk setups in the same computer and depending on the order of disks in the BIOS I can boot any of the two setups.

My existing setup uses one disk and no RAID (obviously), LUKS and LVM for everything but /boot and /boot/efi, total of three partitions. The OS is Centos 7 and I have made a complete backup to an external harddisk using rsync ("BACKUP1").

The new one uses two disks, RAID1, LUKS and LVM for everything but /boot and /boot/efi, total of four partitions (swap has its own partition - not sure why I made it that way). A minimal installation of Centos 7 was made to this setup and is working. In other words, UUIDs of disks, partitions and LUKS are already configured and working.

So, I am now thinking the following might work:

- Make a rsync backup of the new disks to the external harddisk ("BACKUP2").

- Delete all files from the new disks except from /boot and /boot/efi.

- Copy all files from all partitions except /boot and /boot/efi from BACKUP1 to the new disks. In other words, everything except /boot and /boot/efi will now be overwritten.

- I would expect this system not to boot since both /etc/fstab and /etc/crypttab on the new disks contain the UUIDs from the old system.

- Copy just /etc/fstab and /etc/crypttab from BACKUP2 to the new disks. This should update the new disks with the previously created UUIDs from when doing the minimal installation of CentOS 7.

What do you think?


