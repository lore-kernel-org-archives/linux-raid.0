From: Clinton Lee Taylor <clintonlee.taylor@gmail.com>
Subject: Converting ext3 to RAID1 ...
Date: Mon, 24 Aug 2009 23:24:07 +0200
Message-ID: <b7b14cbb0908241424i50bdcf59p35a63e4496b108ca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings ...

I asked this question about two weeks ago

http://www.issociate.de/board/post/498227/Ext3_convert_to_RAID1_....html

  and have had not response, so I am going to try and re-phrase and
hope that somebody can confirm my test case. Thanks.

Wanting to convert an already created and populated ext3 filesystem.

I unmounted the filesystem, ran e2fsck -f /dev/sdb1 to check that the
current filesystem had no errors.
Then ran mdadm --create /dev/md0 --level=1 -n 1 /dev/sdb1 --force to
create the RAID1 device, answered yes to the question.
Ran e2fsck -v /dev/md0 to check that the RAID1 device had no
filesystem corruption on it, which it did not.
Added a spared RAID device using mdadm --add /dev/md0 /dev/sdc1
Then grew the RAID1 device to two compents with mdadm --grow /dev/md0
--raid-disks=2 --backup-file=/root/raid1.backup.file
Did another filesystem check once the RAID finished rebuilding and all
seemed fine.
Double checked that the data on the RAID was the same as the original
data by diffing the two, again all was fine.

 Now is this just lucky or would this be an acceptable way to convert
an existing ext3 filesystem to RAID1?

Thanks
Mailed
LeeT
