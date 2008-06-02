From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Awful Raid10,f2 performance
Date: Mon, 2 Jun 2008 20:30:04 +0200
Message-ID: <20080602183004.GD7990@rap.rap.dk>
References: <cccedfc60806020711o39ccd321h5e410c963d8bf3b1@mail.gmail.com> <48440953.3040004@wpkg.org> <cccedfc60806020809t73794ce6w539c6b0d247a264f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cccedfc60806020809t73794ce6w539c6b0d247a264f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jun 02, 2008 at 10:09:46AM -0500, Jon Nelson wrote:
> i can't show you raw write values, but I can show you raw read values
> (after dropping the caches):
> 
> >From dstat, this shows disks sdb, sdc, and sdd values in read (space)
> write format, with the total on the end.
> 
> Thus:
> 
>   70M    0 :  71M    0 :  72M    0 : 213M    0
>   71M    0 :  70M    0 :  69M    0 : 210M    0
>   71M    0 :  73M    0 :  74M    0 : 217M    0
> 
> shows that I'm getting 70+- MB/s on each disk, combined to 210 to 217MB/s.
> These are read values.
> 
> I created a logical volume (50G), dropped the caches again, and issued:
> 
> dd if=/dev/zero of=/dev/raid/test bs=64k
> 
> and got from 100 to 150MB/s sustained write speeds.
> NOTE: this is with a bitmap (internal)
> Without a bitmap (removed for this test), I get a much more consistent
> 130-150MB/s.

70 MB/s sounds like as expected.

> dd reports a mere 70MB/s when complete.
> When using oflag=direct, I get about 100MB/s combined, with a
> "reported" speed of 51.9MB/s.
> Since I'm using 3x drives, my total I/O is going to be about 2x what dd "sees".
> 
> Does that help?

It does not explain a 7 MB/s rate.

the 52 MB/s writing seems as expected - maybe a bit slow, but not very
slow. I do not know is a 3-disk raid10,f2 has specific performance
problems.

You could try the command (md3 being my raid)

blockdev --setra 65536 /dev/md3 

It solved some performance problems for me.

Best regards
keld
