From: Janos Farkas <jf-ml-k3-raid@lk8rp.mail.xeon.eu.org>
Subject: Re: raid1 with 1.2 superblock never marked healthy?
Date: Fri, 24 Feb 2006 16:01:30 +0100
Message-ID: <priv$1140792048.koan@shadow.banki.hu>
References: <priv$1140364975.koan@shadow.banki.hu> <17400.61822.230666.23651@cse.unsw.edu.au> <privx$1140425087.koan@lk8rp.mail.xeon.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <privx$1140425087.koan@lk8rp.mail.xeon.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On 2006-02-20 at 10:13:40, Janos Farkas wrote:
> > >    Array State : uu 1 failed
> > Something is definitely wrong here... hda3 looks like a spare, but
> > isn't.... I'll have a look and see what I can find out.
> 
> The only "unusual" thing is how it got set up, because on a semi-live
> system, I started with the magic "missing" component to create another
> half mirror while the previous one is running. "Unusual" because I never
> thought of it as a bad idea, but maybe somehow it did cause what I'm
> seeing.
> 
> The original command (then, trying to use bitmaps :) was:
> 
> # mdadm --create /dev/md1 --level 1 -n 2 -d 4 -e 1.2 \
>   -b /etc/md/test1.bin --bitmap-chunk 64 missing /dev/hdc3

As another attempt to fix it, I tried to fault/hotadd the hdc3 partition
again:

# mdadm /dev/md0 -f /dev/hda3
{not saved this message}
# mdadm /dev/md0 -r /dev/hda3
mdadm: hot removed /dev/hda3
# mdadm --zero-superblock /dev/hda3
# mdadm /dev/md0 -a /dev/hda3
mdadm: added /dev/hda3

Resync started again, and after that finished, I saw this with -E:
| /dev/hda3:
| ...
|     Update Time : Fri Feb 24 08:57:41 2006
|        Checksum : 5c9262b - correct
|          Events : 671245
| 
|    Array State : uu 2 failed

| /dev/hdc3:
...
|     Update Time : Fri Feb 24 08:57:45 2006
|        Checksum : 31dda911 - correct
|          Events : 671247
| 
|    Array State : uu 2 failed

While md0 at this time was working without any problems, fearing that I
would be greeted the next day that I have two failed spare devices, I
took a big breath, and created another array with original superblocks:

# mdadm --create /dev/md1 \
   -n 2 --level 1 -b internal --bitmap-chunk 64 \
   /dev/hdc3 missing

Later, while resyncing, there was three line in mdadm -D for components,
one active, one spare (this is probably the dummy "missing" drive), and
one rebuilding.  Maybe this is the case which in v1 superblocks somehow
do not get updated correctly?  With some (marked) failed devices, I still
see weird numbers (and formatting) in mdadm -D, like:

    Number   Major   Minor   RaidDevice State
   -1208301100       0        0        0      removed
       1       3        3        1      active sync   /dev/hda3

       2      22        3        -      faulty spare   /dev/hdc3


Anyway, with some lvm/pvmove magic, I moved everything online from the
"old" md0 to the "new" md1, stopped the old one, activated the mirror on
the new one and it seems to work great ever since. And apparently I do
have bitmaps at last.  I'll try rebooting when I get home though :)

Janos
