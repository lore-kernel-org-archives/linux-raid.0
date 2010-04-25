From: Florian Kusche <flox@kusche.de>
Subject: Questions about 4k sector drives
Date: Sun, 25 Apr 2010 13:45:27 +0200
Message-ID: <4BD42B57.9000703@kusche.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have a few questions about Software RAID and 4k-sector drives. I already searched the web, but some questions are left.

1) (this one is not directly raid-related)
I understand, that newer kernels can determine whether a drive uses 4k physical sectors even if it presents 512-byte logical sectors to the outside. (via the sector_size_supported() patch by Matthew Wilcox)

Is this only an information given to userland tools, or will the linux kernel change its behavior (e.g. use 4k-blocks for such block devices)? (I guess it's only an information for userland tools.)

2)
Will Software RAID work with physical 4k-sector drives...
- that simulate logical 512 byte sectors?
- that also have logical 4k-sectors?
(I'm pretty sure, the answer to both questions is yes.)

3)
Will Software RAID work in mixed setups? i.e.: what combinations of the following drive types are possible?
- 512b physical / 512b logical
- 4k physical / 512b logical
- 4k physical / 4k logical
And: Will the resulting md block device have 512 byte blocks or 4k blocks?
(I would guess that you need to have the same logical sector size for all disks.)

I am aware of the performance problems due to read-modify-write cycles and potential misalignment. This has been discussed in plenty of articles on the web.

It would be great if someone could clear things up a little (and tell me if me guesses are correct).

Thanks,
Florian
