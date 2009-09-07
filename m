From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Array Power Management
Date: Mon, 7 Sep 2009 03:19:28 -0700 (PDT)
Message-ID: <342934.45030.qm@web51305.mail.re2.yahoo.com>
References: <70ed7c3e0909070257y4bec456h6de9cc6d2981c8ce@mail.gmail.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909070257y4bec456h6de9cc6d2981c8ce@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: jahammonds prost <gmitch64@yahoo.com>, "Majed B." <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Mon, 7/9/09, Majed B. <majedb@gmail.com> wrote:

> From: Majed B. <majedb@gmail.com>
> Subject: Re: Array Power Management
> To: "jahammonds prost" <gmitch64@yahoo.com>
> Cc: linux-raid@vger.kernel.org
> Date: Monday, 7 September, 2009, 10:57 AM
> If you're going to spin down the
> disks, you'd need to unmount the
> array first to ensure your data is fine, and after a
> spin-up then you
> mount the array again.
>=20
> I would suggest you buy a meter to measure how much power
> your storage
> is consuming before you decide on your next action.
>=20
> Personally, I'd turn off the machine altogether if it's not
> needed
> during working hours (assuming no one accesses through
> VPN). Check the
> BIOS, it may have the capability to wake up the machine on
> a certain
> date & time (So you can specify to turn itself on daily
> @ 8 AM).
> If not, you should have Wake-up On LAN support, so if you
> turn off the
> machine, another machine (a monitoring server) can turn it
> on for you
> (just put the wake-up on LAN command as a cron job to
> execute daily --
> perhaps exclude holidays).
>=20
> On Mon, Sep 7, 2009 at 6:48 AM, jahammonds prost<gmitch64@yahoo.com>
> wrote:
> > I've been becoming interested in the power consumption
> of the arrays I have on a couple of servers here that are
> basically used as media servers. Since they're not being
> used when I'm at work, I was looking at the possibility of
> spinning the disks down during certain times, and having
> them either spin up at a set time, or (ideally), when there
> is disk activity.
> >
> > I can do this on single drives using hdparm -S to set
> the spindown timeout, and the disks will spin up on activity
> as needed. Is there something similar I can do with an md
> array? I can see there's a /sys/block/md0/power/wakeup file,
> but I can't seem to find any documentation on it. I have
> thought about doing an hdparm -S on the array disks, but I
> suspect that would be A Bad Thing (tm).
> >
> > Does anyone have any advice/pointers? The servers are
> currently running fc9 - I'd like them to be Centos, but had
> to go with fc9, as I=A0needed Port Multiplier support.
> >
> >
> > Graham
> >
> >
> >
> > --
> > To unsubscribe from this list: send the line
> "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>=20
>=20
>=20
> --=20
> =A0 =A0 =A0=A0=A0Majed B.
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html
>=20

This is interesting.. I have the -S set for all my 6 drives in the arra=
y and have for some time and I do not unmount the array - access wakes =
the drives up - usually most of them, sometimes only a few of them. The=
 only part of this that has caused me any problems are scheduled smartd=
 checks - these cause timeout errors.

The timeout is between 30mins and 1hr as if it is over 1 hour smart wil=
l keep them awake forever. In my case, if they are not used for 30mins;=
 they wont be used for several hours.

-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'Do not worry about tomorrow, for tomorrow will bring worries of its ow=
n.'
-----------------------


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
