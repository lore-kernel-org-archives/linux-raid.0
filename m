From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: mdadm create corrupted md data?
Date: Tue, 6 May 2008 22:38:27 -0700
Message-ID: <e9c3a7c20805062238l36674d8akffda7ea9aec78371@mail.gmail.com>
References: <20080506054819.GA6413@merlins.org>
	 <20080506230800.GL31536@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080506230800.GL31536@merlins.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc_news@merlins.org>
Cc: linux-raid@vger.kernel.org, richard@sauce.co.nz
List-Id: linux-raid.ids

On Tue, May 6, 2008 at 4:08 PM, Marc MERLIN <marc_news@merlins.org> wrote:
> [please Cc me on replies, I see them faster that way]
>
>  On Mon, May 05, 2008 at 10:48:19PM -0700, Marc MERLIN wrote:
>  > I thought I could recreate a n-1 array like so:
>  > gargamel:~# mdadm --create /dev/md5 --level=5 --chunk=64 --layout=left-symmetric  --raid-devices=5  /dev/sd{c,d,f,g}1
>  > mdadm: You haven't given enough devices (real or missing) to create this array
>  >
>  > In the olden days (pre-mdadm), I could bring up the array by giving 5 drives
>  > and marking /dev/sde1 as failed-disk instead of read-disk (or somesuch).
>
>  Indeed "missing" as a device name did it, thanks Richard (I guess I can't
>  read when it's late).
>
>  Sad part is that recreating the device worked, but my VG on top disappeared.
>  I may have found a bug or misfeature.
>
>  During my first post, and up to this mornhing, I had:
>  Layout : left-symmetric
>  Chunk Size : 64K
>  md5 : active raid5 sdf1[0] sdc1[3] sdg1[2] sde1[1]
>       1953535744 blocks level 5, 64k chunk, algorithm 2 [5/4] [UUUU_]
>
>  pvdisplay /dev/md5 or vgscan would find the pv and vg.
>
>  Then, I just typed this:
>  mdadm --create /dev/md5 --level=5 --raid-devices=5  /dev/sd{c,d,f,g}1 missing
>
>  it made a new md5 that vgscan doesn't find anything on.
>
>  but I'm very confused as to why
>  mdadm --create /dev/md5 --level=5 --raid-devices=5  /dev/sd{c,e,f,g}1 missing
>  also gives me an md5 that vgscan won't find its pv on anymore
>
>  gargamel:~# cat /proc/mdstat | grep -1 md5 | tail -n+2
>  md5 : active raid5 sdg1[3] sdf1[2] sde1[1] sdc1[0]
>       1953535744 blocks level 5, 64k chunk, algorithm 2 [5/4] [UUUU_]
>  gargamel:~# pvdisplay /dev/md5
>   No physical volume label read from /dev/md5
>     Failed to read physical volume "/dev/md5"
>
>  Any idea what got corrupted in my mdadm runs that caused my data to apparently be
>  gone now?
>  (good news is that I do have an up to date backup, but I should have to use
>  it, and I'd like to recover from this the way it should work, so that I can
>  learn from it)

You may have created the array with a different disk order than when
the array was originally created.  It would help if you had a dump of
the original superblocks.  I'm guessing your original array might have
been the following order "/dev/sdc1 missing /dev/sde1 /dev/sdf1
/dev/sdg1"  where your last attempt changed this order to "/dev/sdc1
/dev/sde1 /dev/sdf1 /dev/sdg1 missing"... however this assumes that
the device names haven't changed.

>
>  It's maybe a good time to give:
>  2.6.24.5-slub-dualcore2smp-volpreempt-noticks

2.6.24.5 also needs this patch:

http://userweb.kernel.org/~akpm/mmotm/broken-out/md-fix-raid5-repair-operations.patch

--
Dan
