From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Tuning the I/O scheduler for md?
Date: Mon, 17 Jul 2006 11:28:26 +0200
Message-ID: <bb145bd20607170228o647f88b8i332cb9109d427f7b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Based on various googled comments I have selected 'deadline' as the
elevator for the disks comprising my md arrays, with no further tuning
yet ... not so stellar :(

Basically concurrent reads (even just 2, even worse with 1 read + 1
write) don't work too well.

Example:

RAID1: I bulk-move some 90GB of files onto the mirror, which takes a
while. Meanwhile I want to do an ls on another directory on the same
mirror. The ls output fits on 20 lines but takes in excess of 10
seconds.

RAID5: That's where the 90GB above are coming from. Concurrently my
music player wants to load a song every 3-5 Minutes from the same
array. Takes 5-10 seconds.

During the transfer I also tried to open a samba share on another disk
which was idle at the time - still took about 3 seconds, as samba
itself is on the mirror.

The bulk transfer (one mv) seems to utterly starve everything else.

CPU load is non-existent, all of 2GB RAM is used for cache, swap is unused.

I realize there's no way to tell the kernel which traffic is
interactive and which is bulk, but I also don't see why deadline
should starve so much.

Any pointers?

Thanks,

Christian
