From: =?ISO-8859-2?Q?Pawe=B3_Brodacki?= <pawel.brodacki@googlemail.com>
Subject: Re: Help understanding the root cause of a member dropping out of a
	RAID 1 set.
Date: Fri, 14 Aug 2009 15:09:41 +0200
Message-ID: <b95c1fdd0908140609jac48ba9u595f839d3d167293@mail.gmail.com>
References: <ABFC24E4C13D81489F7F624E14891C860BF9A409@uk-ex-mbx1.terastack.bluearc.com>
	 <a43edf1b0908130913x238b33ecref5a3d070bf3cb16@mail.gmail.com>
	 <64960.78.86.108.203.1250180799.squirrel@www.yuiop.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <64960.78.86.108.203.1250180799.squirrel@www.yuiop.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2009/8/13 John Robinson <john.robinson@anonymous.org.uk>:

> Can or could md be made or configured to try re-adding a device if th=
is
> sort of thing happens? After all, a stray cosmic ray or whatever perh=
aps
> shouldn't make one lose redundancy if the drive's actually OK?
>
> Cheers,
>
> John.
>

I think that from the coding point of view md probably could. The more
important thing is if it should. The only hard fact is that there was
an error while accessing the device. md has no way of telling if it
was just a freak accident, or the drive is unreliable from now on.
Therefore it does the one safe thing and says "I won't trust you
anymore.". If a human being knows better, the said being is free to
re-add the drive.

Personally I'd hate having a suspicious drive being auto-added in hope
it will rebuild and function properly.

Because such an option could seem tempting but could and would cause
loss of reliability I'd expect bad publicity if it was actually added.

Just my 2c.

Regards,
Pawe=B3
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
