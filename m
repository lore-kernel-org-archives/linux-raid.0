From: Marc MERLIN <marc_news@merlins.org>
Subject: Re: mdadm create corrupted md data?
Date: Tue, 6 May 2008 16:08:00 -0700
Message-ID: <20080506230800.GL31536@merlins.org>
References: <20080506054819.GA6413@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080506054819.GA6413@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: richard@sauce.co.nz
List-Id: linux-raid.ids

[please Cc me on replies, I see them faster that way]

On Mon, May 05, 2008 at 10:48:19PM -0700, Marc MERLIN wrote:
> I thought I could recreate a n-1 array like so:
> gargamel:~# mdadm --create /dev/md5 --level=5 --chunk=64 --layout=left-symmetric  --raid-devices=5  /dev/sd{c,d,f,g}1
> mdadm: You haven't given enough devices (real or missing) to create this array
> 
> In the olden days (pre-mdadm), I could bring up the array by giving 5 drives
> and marking /dev/sde1 as failed-disk instead of read-disk (or somesuch).
 
Indeed "missing" as a device name did it, thanks Richard (I guess I can't
read when it's late).

Sad part is that recreating the device worked, but my VG on top disappeared.
I may have found a bug or misfeature. 

During my first post, and up to this mornhing, I had:
Layout : left-symmetric
Chunk Size : 64K
md5 : active raid5 sdf1[0] sdc1[3] sdg1[2] sde1[1]
      1953535744 blocks level 5, 64k chunk, algorithm 2 [5/4] [UUUU_]

pvdisplay /dev/md5 or vgscan would find the pv and vg.

Then, I just typed this:
mdadm --create /dev/md5 --level=5 --raid-devices=5  /dev/sd{c,d,f,g}1 missing

it made a new md5 that vgscan doesn't find anything on.

but I'm very confused as to why
mdadm --create /dev/md5 --level=5 --raid-devices=5  /dev/sd{c,e,f,g}1 missing
also gives me an md5 that vgscan won't find its pv on anymore

gargamel:~# cat /proc/mdstat | grep -1 md5 | tail -n+2
md5 : active raid5 sdg1[3] sdf1[2] sde1[1] sdc1[0]
      1953535744 blocks level 5, 64k chunk, algorithm 2 [5/4] [UUUU_]
gargamel:~# pvdisplay /dev/md5
  No physical volume label read from /dev/md5
    Failed to read physical volume "/dev/md5"

Any idea what got corrupted in my mdadm runs that caused my data to apparently be
gone now?
(good news is that I do have an up to date backup, but I should have to use
it, and I'd like to recover from this the way it should work, so that I can
learn from it)

It's maybe a good time to give:
2.6.24.5-slub-dualcore2smp-volpreempt-noticks
and
mdadm - v2.6.4 - 19th October 2007

Even if I've lost my data, I'd still like to try to find out what went wrong and help debug 
if that helps.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems & security ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
