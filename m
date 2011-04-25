From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: A few questions regarding RAID5/RAID6 recovery
Date: Mon, 25 Apr 2011 15:51:36 -0400
Message-ID: <BANLkTinp3ksiFDxozYNjobrcbRc8BqAh8Q@mail.gmail.com>
References: <002001cc0370$cd40ac90$67c205b0$@priv.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <002001cc0370$cd40ac90$67c205b0$@priv.hu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2011/4/25 K=C5=91v=C3=A1ri P=C3=A9ter <peter@kovari.priv.hu>:
> Hi all,
>
> Since this is my first post here, let me first thank all developers f=
or their great tool. It really is a wonderfull piece of soft. ;)
>
> I heard a lot of horror stories about the event, when a member of a r=
aid5/6 array gets kicked off due to I/O errors, and then, after the rep=
lacement and during the recostruction, another drive fails, and the arr=
ay become unusable. (For raid6, add another drive to the story, and the=
 problem is the same, so let=E2=80=99s just talk about raid5 now). I wa=
nt to prepare myself for this kind of unlucky event, and build up a str=
ategy that I can follow once it happens. (I hope never, but...)

=46rom what I understand If you run weekly raid scrubs you will limit
the possibility of this happening. CentOS / RedHat already have this
scheduled. If not you can add a cron job to call check or repair. Make
sure you replace DEV with the device.

echo check > /sys/block/DEV/md/sync_action

I have had 3 x 1TB drives in RAID 5 for the past 2.5 years. I have not
had a drive kicked out or an error found. If an error is found, since
it is caught early, I should have a good probability of replacing the
failed drive without incurring another error.

Ryan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
