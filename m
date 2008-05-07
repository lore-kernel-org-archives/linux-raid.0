From: Marc MERLIN <marc_news@merlins.org>
Subject: Re: mdadm create corrupted md data?
Date: Tue, 6 May 2008 23:56:57 -0700
Message-ID: <20080507065657.GA21697@merlins.org>
References: <20080506054819.GA6413@merlins.org> <20080506230800.GL31536@merlins.org> <e9c3a7c20805062238l36674d8akffda7ea9aec78371@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e9c3a7c20805062238l36674d8akffda7ea9aec78371@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: linux-raid@vger.kernel.org, richard@sauce.co.nz
List-Id: linux-raid.ids

On Tue, May 06, 2008 at 10:38:27PM -0700, Dan Williams wrote:
> >  During my first post, and up to this mornhing, I had:
> >  Layout : left-symmetric
> >  Chunk Size : 64K
> >  md5 : active raid5 sdf1[0] sdc1[3] sdg1[2] sde1[1]
> >       1953535744 blocks level 5, 64k chunk, algorithm 2 [5/4] [UUUU_]
> >
> >  gargamel:~# cat /proc/mdstat | grep -1 md5 | tail -n+2
> >  md5 : active raid5 sdg1[3] sdf1[2] sde1[1] sdc1[0]
> >       1953535744 blocks level 5, 64k chunk, algorithm 2 [5/4] [UUUU_]
> 
> You may have created the array with a different disk order than when
> the array was originally created.  It would help if you had a dump of
> the original superblocks.  I'm guessing your original array might have
> been the following order "/dev/sdc1 missing /dev/sde1 /dev/sdf1
> /dev/sdg1"  where your last attempt changed this order to "/dev/sdc1
> /dev/sde1 /dev/sdf1 /dev/sdg1 missing"... however this assumes that
> the device names haven't changed.

Doh! I feel so silly considering how blindingly obvious this is now
now that you mention it :)

Yes, that was of course my problem, and the correct order of the drives
was shown as numbers in the first mdstat:
The winning command was therefore:
mdadm --create /dev/md5 --level=5 --raid-devices=5  /dev/sdf1 /dev/sde1 /dev/sdg1 /dev/sdc1 missing
or
mdadm --create /dev/md5 --level=5 --raid-devices=5  /dev/sdf1 missing /dev/sdg1 /dev/sdc1 /dev/sdd1

After that, I get my pv back, and my VG.

I did try an e2fsck -f -n -C 0 /dev/dshelf2/space when in the configuration
with sdd1 (i.e. the drive I first tried to rebuild parity on, until I found
out it was sde1 that had bad sectors), and it is showing some pretty scary
errors that probably show that my fs is mostly toast if I elect to use sdd1
instead of sde1.
Considering that sde1 is the soon to be dead drive, I guess backups is where
I go next.

I'm however surprised that rebuilding parity on sdd1 wasn't effectively a
no-op since sde1 only had one bad sector, about 100GB from its beginning,
and that rebuilding parity on sdd1 caused some no trivial FS damage.

Oh well...

If I can provide more useful info before I rebuild this array altogether,
let me know.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems & security ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
