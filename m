Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 180B0C3DA78
	for <linux-raid@archiver.kernel.org>; Sun, 15 Jan 2023 03:12:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbjAODMg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 14 Jan 2023 22:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbjAODMe (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 14 Jan 2023 22:12:34 -0500
Received: from mout.perfora.net (mout.perfora.net [74.208.4.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0975693CC
        for <linux-raid@vger.kernel.org>; Sat, 14 Jan 2023 19:12:33 -0800 (PST)
Received: from [192.168.1.7] ([72.94.51.172]) by mrelay.perfora.net
 (mreueus003 [74.208.5.2]) with ESMTPSA (Nemesis) id 0M2bMR-1oQzBN3Lld-00sR8Y
 for <linux-raid@vger.kernel.org>; Sun, 15 Jan 2023 04:12:33 +0100
To:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
From:   H <agents@meddatainc.com>
Subject: Transferring an existing system from non-RAID disks to RAID1 disks in
 the same computer
Message-ID: <273d1fc9-853f-a8fa-bb47-2883ba217820@meddatainc.com>
Date:   Sat, 14 Jan 2023 22:12:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Provags-ID: V03:K1:M1jnwSljOcw7JdxebTnTqfcqkpCtaFd+YzHjANodo2Xy2nOgtie
 oiK8uKvzM9GmejdJlx/NaOzgb282AEtSbzf97CovFRcfQY+d2OwxsafiKbkRd2peZYX/q2s
 nNDh3r49xjXqmPs6jf3lJwrexj3CVD2gMHbbVCK6GfCE+AINUCfB1AtdC6ST9MV26ueSnwd
 oRuIOUN/FCX/C0APmLjzA==
UI-OutboundReport: notjunk:1;M01:P0:eaQZZ625drw=;phpv1f3lzqwIq9NC1ER3gXPlZQv
 sD1FHBLqMVjSvTB0mLZn4sDZuD7oqxuLboKR6k164ONYAGtLNvCp30VBN953sZ5outoe69mWO
 QWKWgEgPxlta9opIKqq+uOLVaW6+g+Hgp0+AuW7SBOJh3RFqcVZCLAfGeY1/7OnGldr9CF2m4
 fnKXXglK9ynSEGXWUe8D4q6PpZXeNaiPTr4WsZwMsK9M85Yc0hL/y5tvIpy5jpptHhMzovrRx
 D5lzHYjLQiGHU5HV09w7lC4CHgs6d0YIYjX3QSvSv6t3elqCQTkAGkkQf1zPmLQWjNdJZ8Cpe
 d9wPtuYxuOh9K4B2Ks8OOxsrxK+Kexi6S4WjQ8GxqzlAwbdr8v+xdPAlu+xd98phyhcEto6OD
 631t/x75Ct8cpDxi4MP+nBKJOmh9zHjzAHQLK2OGKaGlOQeeMomcEPXC2lZRcAHTHqlDB1s5t
 UE388+PUtNEvGs+9Z6oEfWeu+BD+FgK5fenAzHUArEFvtAsPJ2+JeDJcHnFeRloVJi5zzCSmp
 ygjK6uxt+Zb71nnLyHYrxCITxbrD1lRHVMi8wQHWdTU5maKYZgOoF10z3X1j8NRL15kdwrpv4
 fb/ivViVpCkwH+HUsfR3THAdtcKVPdgZABdxcGwr83yHxTcU5SwgW0oho2yLutiYlmL1W/wjr
 F1C77Tacy7TrzMYCdcg86IAqmUfYWw6/8ophmf1G7Q==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I need to transfer an existing CentOS 7 non-RAID setup using one single SSD to a mdadm RAID1 using two much larger SSDs. All three disks exist in the same computer at the same time. Both the existing SSD and the new ones use LVM and LUKS and the objective is to preserve the OS, all other installed software and data etc. Thus no new installation should be needed.

Since all disks, partitions, LUKS etc have their unique UUIDs I have not figured out how to do this and could use help and advice.

In preparation for the above, I have:

- Used rsync with the flags -aAXHv to copy all files on the existing SSD to an external harddisk for backup.

- Partitioned the new SSDs as desired, including LVM and LUKS. My configuration uses one RAID1 for /boot, another RAID1 partition for /boot/efi, and a third one for the rest which also uses LVM and LUKS. I actually used a DVD image of Centos 7 (minimal installation) to accomplish this which also completed the minimal installation of the OS on the new disks. It boots as expected and the RAID partitions seem to work as expected.

Since I want to actually move my existing installation from the existing SSDs, I am not sure whether I should just use rsync to copy everything from the old SSD to the new larger ones. However, I expect that to also transfer all OS files using the old, now incorrect UUIDs, to the new disks after which nothing will work, thus I have not yet done that. I could erase the minimal installation of the OS on the new disks before rsyncing but have not yet done so.

I fully expect to have to do some manual editing of files but am not quite sure of all the files I would need to edit after such a copy. I have some knowledge of linux but could use some help and advice. For instance, I expect that /etc/fstab and /etc/crypttab would need to be edited reflecting the UUIDs of the new disks, partitions and LUKS, but which other files? Grub2 would also need to be edited I would think.

The only good thing is that since both the old disk and the new disks are in the same computer, no other hardware will change.

Is there another, better (read: simpler) way of accomplishing this transfer?

Finally, since I do have a backup of the old SSD and there is nothing of value on the new mdadm RAID1 disks, except the partition information, I do have, if necessary, the luxury of multiple tries. What I cannot do, however, is to make any modifications to the existing old SSD since I cannot afford not being able to go back to the old SSD if necessary.

Thanks.


