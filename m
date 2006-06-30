From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Strange intermittant errors + RAID doesn't fail the disk.
Date: Fri, 30 Jun 2006 18:32:00 +0200
Message-ID: <bb145bd20606300932x2268822k78561e549996aef3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

More problems ...

As reported I have 4x WD5000YS (Caviar RE2 500 GB) in a md RAID5
array. I've been benchmarking and otherwise testing the new array
these last few days, and apart from the fact that the md doesn't shut
down properly I've had no problems.

Today I wanted to finally copy some data over, but I after 5sec I got:

[...]
ata2: port reset, p_is 8000000 is 2 pis 0 cmd 44017 tf d0 ss 123 se 0
ata2: status=0x50 { DriveReady SeekComplete }
sdc: Current: sense key: No Sense
    Additional sense: No additional sense information
ata2: handling error/timeout
ata2: port reset, p_is 0 is 0 pis 0 cmd 44017 tf 150 ss 123 se 0
ata2: status=0x50 { DriveReady SeekComplete }
ata2: error=0x01 { AddrMarkNotFound }
sdc: Current: sense key: No Sense
    Additional sense: No additional sense information
[repeat]

All processes accessing the array hang and can't even be killed by
kill -9, but md does not mark the disk as failed.

I then tested all four disks individually in another box -- according
to WD's drive diagnostic they're fine. Re-created the array on the
disks, which worked for a few hours, now I get the same error again.
:(

Kernel is 2.6.17-1-686 (Debian testing). I could go back to 16, but 15
is missing a CIFS change I need.

Any help is appreciated.

Christian
