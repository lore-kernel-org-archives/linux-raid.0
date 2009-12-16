From: "Majed B." <majedb@gmail.com>
Subject: Re: RAID5 / 6 Growth
Date: Wed, 16 Dec 2009 14:21:28 +0300
Message-ID: <70ed7c3e0912160321m39861a1ex84de114dc9a6b961@mail.gmail.com>
References: <70ed7c3e0912152237v3b7bf25cg54c70eb61101a60a@mail.gmail.com>
	<8D.4A.01567.8F4982B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8D.4A.01567.8F4982B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Oh, I thought this was a backup system. I always ramp up the speed on
min & max to have the resync & reshapes finish fast, but at the loss
of performance during that.

You mentioned that you've unmounted the filesystem, so why does it
make a different if you max the speed? Or do you have other services
running?

I think at the time I needed a new mdadm, I downloaded 3.0 which is
the stable one for now (3.1 was pulled -- donno about 3.1.1).

On Wed, Dec 16, 2009 at 11:06 AM, Leslie Rhorer <lrhorer@satx.rr.com> w=
rote:
>> Have you made sure that the value of
>> /proc/sys/dev/raid/speed_limit_min is high enough? (200000 means 200
>
> High enough? =C2=A0Wouldn't a higher speed limit mean more stress on =
the systems?
> Its value is 1000.
>
>> MB/s) along with /proc/sys/dev/raid/speed_limit_max?
>
> It's 200,000
>
>> I interrupted an array resyncing a couple of times without issues.
>> Only one time I interrupted an array during growth process and I had
>> an old version of mdadm (2.6.3) which didn't support resuming that. =
I
>> think Neil told me that 2.6.9 is the minimum requirement to resume.
>
> It's 2.6.7.2. =C2=A0Debian does not admit new software into its distr=
o until they
> are rock hard stable, unless it is a bug fix release. =C2=A0I guess I=
'll have to
> wait a few more days.
>
>
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
