From: "TJ Harrell" <systemloc@earthlink.net>
Subject: Re: New RAID-5 800GB array, wich fs ? wich stripe block size ?
Date: Mon, 19 Jul 2004 22:39:20 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <001a01c46e02$c30d5f80$0201a8c0@windows>
References: <40FB923D.1080903@gouny.org> <40FC30C2.5050600@dobbels.com> <40FC37A9.6060006@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: =?iso-8859-1?Q?Aur=E9lien_Gouny?= <aurelien@gouny.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I just chose plain vanilla ext3 ('mke2fs -j -m1 /dev/md2') on top of
> plain ol' raid 5. The only option that's different there is the "m1"
> since with an enormous filesystem, reserving 5% of it for root use is a
> bit silly.

I have a similar set up. A 600GB RAID-5 serving mp3's, and divx. I use ext3.
The journalling is a lifesaver if you ever have a crash for some reason.
Fsck
on a file-system that large is amazingly slow. I also mount it in
data=writeback
mode to improve performance. The -m option is important, otherwise you
waste a great deal of space. Additionally, the stripe and chunck sizes
should
be matched to the array when you issue the mke2fs. That's something that
was difficult for me to understand, so someone might want to explain that
one.


> With regard to performance, the first thing you'll notice is that unless
> you have gigabit to everywhere, you're limited by network I/O. I am
> anyway. I could saturate a 100Mbit network connection with the read
> speed, and after that, who cares?

I do have gigabit from my fileserver :) The disk bandwidth is actually not
that
great, though. I have yet to figure out why.

> I will say though, I've had hardware failures and machine failures take
> the array out before - remember that MTBF is divided by the number of
> parts and arrays usually have lots of parts. Don't forget to backup
> early and often...

Yes.. RAID is no replacement for backing up!!! My RAID array has proven
extremely durable and reliable through several hardware failures, however,
two drives dying at once, a simple power surge from a faulty PSU or
lightning,
or many other things could kill it. Even mistyping a command during a
recovery
could destroy the array.

> Bernhard Dobbels wrote:
> > Technically speaking, I prefer the LVM2 solution on which you can make
> > and resize partitions on the fly.
> >
> > I must admit I lost my raid5 with LVM2. The cause will probably have
> > been my fault, although I don't know what I did wrong, so I suggest if
> > you have critical data, a backup on another medium is still advised.

I mount my array on /home, and have all data files in the home directory of
my
user account, myself. I can create additional home directories for different
shares.
This is convient to me, although other people may feel otherwise. I do not
use LVM2
for two reasons. It is extra for me to learn to use, and it is an extra
possible point
of failure. The RAID code alone has been found to have bugs and weak code in
the
past. Using LVM2 on top of RAID, which also may have weak code or bugs, is
just
an additional possible fail point. In my opinion, it should not be used
unless it is
significantly useful. In my case, it isn't. I get by without needing it.


I wish you success,
TJ Harrell


