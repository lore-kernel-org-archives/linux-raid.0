From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: Re: Good, recent FS comparison?
Date: Sun, 18 Sep 2005 14:29:49 +0300
Message-ID: <5d96567b05091804291a451796@mail.gmail.com>
References: <6d5bedd8050915131148b8108a@mail.gmail.com>
	 <432A37BF.7060305@dtbb.net> <200509162258.37730.a1426z@gawab.com>
	 <432D3024.3080302@dtbb.net>
Reply-To: raziebe@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <432D3024.3080302@dtbb.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Tyler <pml@dtbb.net>
Cc: Al Boldi <a1426z@gawab.com>, linux-fsdevel@vger.kernel.org, Linux RAID Mailing List <linux-raid@vger.kernel.org>, linux-xfs@oss.sgi.com
List-Id: linux-raid.ids

what is ordered mode that xfs doesn't support ?

On 9/18/05, Tyler <pml@dtbb.net> wrote:
> 
> Al Boldi wrote:
> 
> >Tyler wrote:
> >
> >
> >>Ewan Grantham wrote:
> >>
> >>
> >>>I've just setup a nice, 6-disk, USB-2 300 Gig/disk array, and was
> >>>prepared to follow my normal pattern of installing ext3 as the
> >>>filesystem. However, I saw the interview with Hans Reiser about
> >>>ReiserFS4, and am now wondering if reiser has really improved enough
> >>>to use it, or if ext3 is still the way to go?
> >>>
> >>>
> >>You'd be best off trying some tests of your own, using files of the size
> >>and quantity you expect to use on a regular basis.  I would consider
> >>ext3, xfs, and reiser3/4... and run some tests with them.  We've had
> >>really good luck using XFS on large raids, I personally had a bad
> >>experience with reiserfs 3, it lost data on a USB based drive, as if it
> >>were never even there, even after trying the recovery tools.
> >>
> >>
> >
> >Don't touch anything that doesn't do ordered-mode journaling, especially if
> >you use raid, unless your data-consistency requirements don't require this.
> >
> >XFS is best, but does not support ordered-mode.
> >reiser4 is still new.
> >ext3 is rock-solid!
> >
> >--
> >Al
> >
> >-
> >To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >
> Al... you've given us some "do's" .. can you give us some "why's" to go
> along with them? :)  I would appreciate a run-down with some more
> specific info as to what/why.
> 
> Thanks,
> Tyler.
> 
> 
> --
> No virus found in this outgoing message.
> Checked by AVG Anti-Virus.
> Version: 7.0.344 / Virus Database: 267.11.1/104 - Release Date: 9/16/2005
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Raz
