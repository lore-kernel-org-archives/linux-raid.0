From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: RAID5 / 6 Growth
Date: Wed, 16 Dec 2009 00:12:05 -0800
Message-ID: <4877c76c0912160012t3796247dg4dcf79c66e404528@mail.gmail.com>
References: <70ed7c3e0912152237v3b7bf25cg54c70eb61101a60a@mail.gmail.com>
	 <8D.4A.01567.8F4982B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8D.4A.01567.8F4982B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: "Majed B." <majedb@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Dec 16, 2009 at 12:06 AM, Leslie Rhorer <lrhorer@satx.rr.com> w=
rote:
>> Have you made sure that the value of
>> /proc/sys/dev/raid/speed_limit_min is high enough? (200000 means 200
>
> High enough? =A0Wouldn't a higher speed limit mean more stress on the=
 systems?
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
> It's 2.6.7.2. =A0Debian does not admit new software into its distro u=
ntil they
> are rock hard stable, unless it is a bug fix release. =A0I guess I'll=
 have to
> wait a few more days.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

You could seek out a testing version or compile it your self.  mdadm
doesn't depend on that much...
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
