From: Vincent Pelletier <plr.vincent@gmail.com>
Subject: Re: Split-Brain Protection for MD arrays
Date: Mon, 12 Dec 2011 21:18:28 +0100
Message-ID: <201112122118.28351.plr.vincent@gmail.com>
References: <CAGRgLy6=-naSGJw_tgiD5=ab7gWxyeQ2ysu-yCKa064Jih+cfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6=-naSGJw_tgiD5=ab7gWxyeQ2ysu-yCKa064Jih+cfA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Le lundi 12 d=E9cembre 2011 19:51:23, vous avez =E9crit :
> split-brain

I'm participating on the NEO[1] project (object database server with=20
redundancy - that last bit is the one relevant to this discussion), whi=
ch=20
faces the same kind of problem (storage nodes dying when cluster is fun=
ctional=20
or not, dead nodes comming back to life later, etc). So we had to desig=
n some=20
counter measures to handle split-brain.=20

I'm happy to recognise some equivalent of the decisions we took on NEO,=
 and=20
I'll be following this thread with attention (we didn't try to get a lo=
t of=20
reviewing on our design so far).

I would suggest one thing:
Use a fixed increment for "metadata version" number. Time representatio=
n is
not reliable IMHO, especially at times when you need to setup an array:
faulty BIOS battery, old RTC drifting either way, no NTP to correct thi=
s
(either none available or no client to access one).
If timestamp is affected by timezone (and especially DST) makes matters
worse.
Admitedly, fixed increment exposes user to problems if he decides to
independently run two halves of a split brain, start making their data
diverge, reach a point (controlable) where version number is at some
convenient value and then let the array assemble itself and burst in fi=
re.
Though, user has to jump through hoops to reach this. Timestamp-based
requires non-monotonous RTC.

Side note: if anyone knows a time source available to userland which is=
 not
affected by date/ntpd/ntpdate nor timezones nor DST (but can drift when=
=20
computer is powered down - but if possible not when suspended), please =
tell=20
me.

[1] http://pypi.python.org/pypi/neoppod

Regards,
--=20
Vincent Pelletier
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
