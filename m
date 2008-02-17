From: pg_lxra@lxra.to.sabi.co.UK (Peter Grandi)
Subject: Re: RAID5 to RAID6 reshape?
Date: Sun, 17 Feb 2008 11:50:25 +0000
Message-ID: <18360.8065.335494.142060@tree.ty.sabi.co.UK>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Sat, 16 Feb 2008 20:58:07 -0700, Beolach
>>> <beolach@gmail.com> said:

beolach> [ ... ] start w/ 3 drives in RAID5, and add drives as I
beolach> run low on free space, eventually to a total of 14
beolach> drives (the max the case can fit).

Like for for so many other posts to this list, all that is
"syntactically" valid is not necessarily the same thing as that
which is wise. 

beolach> But when I add the 5th or 6th drive, I'd like to switch
beolach> from RAID5 to RAID6 for the extra redundancy.

Again, what may be possible is not necessarily what may be wise.

In particular it seems difficult to discern which usage such
arrays would be put to. There might be a bit of difference
between a giant FAT32 volume containing song lyrics files or an
XFS filesystem with a collection of 500GB tomography scans in
them cached from a large tape backup system.

beolach> I'm also interested in hearing people's opinions about
beolach> LVM / EVMS.

They are yellow, and taste of vanilla :-). To say something more
specific is difficult without knowing what kind of requirement
they may be expected to satisfy.

beolach> I'm currently planning on just using RAID w/out the
beolach> higher level volume management, as from my reading I
beolach> don't think they're worth the performance penalty, [
beolach> ... ]

Very amusing that someone who is planning to grow a 3 drive
RAID5 into a 14 drive RAID6 worries about the DM "performance
penalty".
