From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: md questions [forwarded from already sent mail]
Date: Fri, 23 Jan 2004 19:31:02 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401231931.02390.gene.heskett@verizon.net>
References: <200401221928.00985.gene.heskett@verizon.net>
Reply-To: gene.heskett@verizon.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200401221928.00985.gene.heskett@verizon.net>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 22 January 2004 19:28, Gene Heskett wrote:
>Hello Mike;
>
>I've taken the liberty of CC: ing this to Jim Hines, the IT guy at
>wdtv.com, where I was the CE for almost 19 years, now semi-retired.
>He is the one with this problem machine, but isn't on this (lkml)
>mailing list.  If I screw this up, he'll probably reply and correct
>me.
>
>You seem to be the person who answers most of the 'md' questions, so
>here goes one.  Factor in that the list is tired of me so I'd rather
>not make noise in the mailboxes of those who aren't germain to this
>'md' discussion.  If there is a mailing list we should be useing,
>please advise as to signup proceedures.
>
>We built, 2 years ago, a raid server to use as a backup deposit,
> with it doing an rsync of the various clients each night to a
> subdir on the 320Gb raid5 according to the day of the week.
>
>Last week, something went in the toilet on its boot drive running
> ext3 and in the aftermath of an e2fsck everything was there, but in
> the lost+found directory, so the machine was replaced with a
> slightly newer one, the promise cards (20269's I think, but my hand
> isn't anywhere near a bible) were moved in from the older box, and
> the drives enhanced so there are now 4 each 180Gb drives in the
> raid5 setup on those two promise cards, and a couple of the older,
> still good 160Gbs for boot etc on the mobo's own controller.
>
>And since the old box was running rh7.2, Jim figured it probably
>needed to be updated to rh8.0 which was installed on the newer
>system.
>
>Recompileing the 2.4.20 kernel that came with rh8.0 to add the md
>support, then enabling that and formatting the md with the last
>reiserfs 3.x version (from rh8.0's disks I believe) all went well.
>This is what we had been using for 2 years, the only diffs being the
>newer 180Gb drives instead of the former 160's, and the switch from
> a 2.4.18 to a 2.4.20 kernel on a newer mobo.
>
>But, on the restart, with nothing other than the filesystem
> installed on the 'md' drives, it gave us a resync time of about
> 29,000 seconds. We cannot even see why a resync should be running
> since the array was at that point empty.  This was 2 days ago, and
> I've been informed that allthough the recovered crontab scripts
> seem to be working, the write speeds are atrocious, something like
> 16kb/second.  hdparm OTOH, reports the read times to be quite
> respectable and in the 160Mb/sec area.
>
>Also, and not sure if there is any connection, adding a 3rd promise
>card seems to do a fine job of fscking up the drive scanning during
>post.  Jim, haveing those 180's laying around, wanted to setup a
>second md array of 2 of them running in mirror mode in that machine,
>but thats apparently not possible.  It (post) seems to find several
>more drives than actually exist, but none appear to be accessable
>after post.
>
>Recommendations?  Things to check?  We're idiots?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty: soap,
ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
99.22% setiathome rank, not too shabby for a WV hillbilly
Yahoo.com attornies please note, additions to this message
by Gene Heskett are:
Copyright 2004 by Maurice Eugene Heskett, all rights reserved.
