From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Problem w/ commit ac8fa4196d20 on older, slower hardware
Date: Fri, 13 Nov 2015 01:03:06 +0100
Message-ID: <20151113000306.GA3563@EIS>
References: <87twq0527k.fsf@notabene.neil.brown.name>
 <56451299.6090107@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56451299.6090107@gentoo.org>
Sender: linux-raid-owner@vger.kernel.org
To: Joshua Kinard <kumba@gentoo.org>
Cc: Neil Brown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Nov 12, 2015 at 05:28:41PM -0500, Joshua Kinard wrote:
> running MD RAID5 and the XFS filesystem.  I have /, /home, /usr, /var,
> and /tmp on separate partitions, each a RAID5 setup.

Hi, sorry for butting in,

I have the same issue, on a regular consumer Haswell i5 box, 
with a setup very very similar to yours:

7x2TB disks, multiple partitions, for each: RAID-5, LUKS, LVM, XFS.

The issue occurs during regular RAID check which I run daily 
(different partition/RAID each day, so it's more like a 
evenly distributed weekly check).

I have an application that uses `find -size +100M` on a directory 
tree with ~3k subdirs and ~6k files in total. It doesn't do anything 
with the find result, it's purely informal. So no big data involved, 
even though the files themselves aren't small.

Yet, it's slooow. The following tests were on a completely idle box, 
apart from a running RAID check on the same /dev/mdX device.

Kernel 4.2.3, unpatched:

real	0m53.555s
user	0m0.013s
sys	0m0.037s

real	1m3.777s
user	0m0.013s
sys	0m0.037s

real	1m3.453s
user	0m0.014s
sys	0m0.036s

Kernel 4.2.3, reverted ac8fa4196d20:

real	0m3.206s
user	0m0.010s
sys	0m0.030s

real	0m0.450s
user	0m0.003s
sys	0m0.014s

real	0m0.375s
user	0m0.003s
sys	0m0.012s

I did echo 3 > /proc/sys/vm/drop_caches between each find. 
For some reason, subsequent calls in the reverted kernel are 
considerably faster regardless. In the original kernel it 
stays slow... if I don't drop_caches, the time is 0.006s.

I don't normally reboot (while a RAID sync or check is 
running) but while switching between kernels I noticed 
the shutdown was very slow also in the original kernel.

Are small requests getting delayed a lot or something?

Regards
Andreas Klauer
