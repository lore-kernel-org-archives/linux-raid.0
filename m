From: "Jon Nelson" <jnelson@jamponi.net>
Subject: Re: raid10: unfair disk load?
Date: Sat, 22 Dec 2007 07:04:00 -0600
Message-ID: <cccedfc60712220504t1d720330p6f8ecf9bfd0f3163@mail.gmail.com>
References: <476BA4FD.6080401@msgid.tls.msk.ru>
	 <476BA942.40406@msgid.tls.msk.ru> <20071221174902.6fc02c4e@absurd>
	 <476C2869.1080903@msgid.tls.msk.ru> <20071222130559.68b773fd@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071222130559.68b773fd@absurd>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/22/07, Janek Kozicki <janek_listy@wp.pl> wrote:
> Michael Tokarev said:     (by the date of Fri, 21 Dec 2007 23:56:09 +0300)
>
> > Janek Kozicki wrote:
> > > what's your kernel version? I recall that recently there have been
> > > some works regarding load balancing.
> >
> > It was in my original email:
> > The kernel is 2.6.23
> >
> > Strange I missed the new raid10 development you
> > mentioned (I follow linux-raid quite closely).
> > What change(s) you're referring to?
>
> oh sorry it was a patch for raid1, not raid10:
>
>   http://www.spinics.net/lists/raid/msg17708.html
>
> I'm wondering if it could be adapted for raid10 ...
>
> Konstantin Sharlaimov said:     (by the date of Sat, 03 Nov 2007
> 20:08:42 +1000)
>
> > This patch adds RAID1 read balancing to device mapper. A read operation
> > that is close (in terms of sectors) to a previous read or write goes to
> > the same mirror.

Looking at the source for raid10 it already looks like it does some
read balancing.
For raid10 f2 on a 3 drive raid I've found really impressive
performance numbers - as good as raid0. Write speeds are a bit lower
but rather better than raid5 on the same devices.

-- 
Jon
