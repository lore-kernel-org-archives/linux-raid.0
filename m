From: Jeff W <jeff.welling@gmail.com>
Subject: Re: RAID6 ext3 problems
Date: Sun, 12 Feb 2012 13:43:43 -0500
Message-ID: <CAKXovctDA28Gk61EJF_1-6kX2kMwRG8yyza4VFsKpzwsiHOEGQ@mail.gmail.com>
References: <CAKXovctDQdiMWEdzh6Jg8OkEjXX5OHZ+hubFV-GRsc8S2QHohQ@mail.gmail.com>
	<CAKXovctARfGAkug=ZA0EYm1uB=V0_5BXWyNisVZYip0VBpJxtA@mail.gmail.com>
	<CAK2H+eerAkwup2UcAu2v=_4+=Bg_FBCqZmjGjmcLQA+2ozmvbg@mail.gmail.com>
	<CAKXovcvvTioOP+JKd8b5-Hc1GZhAiqB85=A4d-cCP03uDPiGkg@mail.gmail.com>
	<CAK2H+eds+2wu6Nep639mZ1dkOMmxdzqp4_7-o=QJO_qqcTWr9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+eds+2wu6Nep639mZ1dkOMmxdzqp4_7-o=QJO_qqcTWr9g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Feb 12, 2012 at 1:33 PM, Mark Knecht <markknecht@gmail.com> wro=
te:
> Hi Jeff,
> =A0 In case you start laboring under a false perception, please
> understand I am _not_ a heavy hitter. :-)
>
> =A0 OK, so those results raise two questions for me:
>
> 1) Was it intentional to use all of /dev/sde - I.e. - no partition al=
a
> sde1- or is that something strange that needs to be investigated?

Using sde instead of sde1 was a mistake I made a long time ago that I
had planned to fix, but a sudden need to relocate put off my plans to
fix it since it was working in the configuration it was in.

>
> 2) For the device that has been removed (possibly /dev/sdb1?) what do
> you get with an --examine command?

The drive that has been removed from the array has been physically
removed from the system, it is unplugged. It was flooding the system
log with error messages while plugged in.

> Also, you might try smartctl on the missing drive to investigate
> whether the internal electronics identified a problem.
>
> HTH,
> Mark

Thanks,
Jeff.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
