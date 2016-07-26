From: =?UTF-8?Q?Luis_Panadero_Guarde=C3=B1o?= <luis.panadero@gmail.com>
Subject: GPT Table broken on a Raid1 (necroposting)
Date: Tue, 26 Jul 2016 22:34:29 +0200
Message-ID: <CANWDRg8dgfLoNFJjJKNj99-cYcO+UojTs9qMWGEGbH1WYWfK-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

http://linux-raid.vger.kernel.narkive.com/nhUT84sK/gpt-table-broken-on-a-raid1#post21

I just, had nearly the same problem but on reverse. I get a GPT error
on the Raid 1 volume, not on the raid hard disks. On my case, is on a
server that have an Intel Matrix Storage fake raid, and have only a
Ubuntu server 14.04.4 x64 installed it.

Also, I got, at same time, other more serious problem. The server,
have four hard disks. Two small of ~400MiB (before was of ~250MiB) and
tow big of 1 TiB. On the bigger, I had set a Raid 1 where the data and
some third party software had been installed (Jenkins, GitLab, Nexus),
and on the smaller, I setup another Raid 1 where the OS is installed.
A few days ago, one of the small hard disk begun to fail, and we
procced to replace it for a new unit. Well, the Raid proceed to dump
the empty fresh hard disk over the hard disk with the OS!!! Lucky, the
old hard disk, can been read and I can recover the OS image from it,
but I would like to know what we did wrong (apart of using a
FakeRaid). The hardware guy decided to poweroff the server to add the
new hard disk (yeah, I thought that not have much sense having a Raid
if you need to stop the server to replace a hard disk...), and add the
new hard disk to the raid using the Intel tool on the BIOS. I think
that this was what whipped out our OS sane hard disk. Could be ?
