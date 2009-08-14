From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Help understanding the root cause of a member dropping out of
 a 	RAID 1 set.
Date: Fri, 14 Aug 2009 18:07:44 +0100
Message-ID: <4A8599E0.5000604@anonymous.org.uk>
References: <ABFC24E4C13D81489F7F624E14891C860BF9A409@uk-ex-mbx1.terastack.bluearc.com>	 <a43edf1b0908130913x238b33ecref5a3d070bf3cb16@mail.gmail.com>	 <64960.78.86.108.203.1250180799.squirrel@www.yuiop.co.uk> <b95c1fdd0908140609jac48ba9u595f839d3d167293@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b95c1fdd0908140609jac48ba9u595f839d3d167293@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-2?Q?Pawe=B3_Brodacki?= <pawel.brodacki@googlemail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 14/08/2009 14:09, Pawe=B3 Brodacki wrote:
> 2009/8/13 John Robinson <john.robinson@anonymous.org.uk>:
>=20
>> Can or could md be made or configured to try re-adding a device if t=
his
>> sort of thing happens? After all, a stray cosmic ray or whatever per=
haps
>> shouldn't make one lose redundancy if the drive's actually OK?
>=20
> I think that from the coding point of view md probably could. The mor=
e
> important thing is if it should. The only hard fact is that there was
> an error while accessing the device. md has no way of telling if it
> was just a freak accident, or the drive is unreliable from now on.

Ah well, perhaps we need to give md a way of knowing the difference=20
between a transient error (that has been recovered from) and a more=20
serious error.

> Therefore it does the one safe thing and says "I won't trust you
> anymore.". If a human being knows better, the said being is free to
> re-add the drive.
>=20
> Personally I'd hate having a suspicious drive being auto-added in hop=
e
> it will rebuild and function properly.

I wouldn't want it to be the default behaviour, but I'd like the option=
=20
to configure things that way. I'd want the number of auto-re-adds=20
configurable too.

> Because such an option could seem tempting but could and would cause
> loss of reliability I'd expect bad publicity if it was actually added=
=2E

But it could cause improvements in reliability too. If the cable on=20
drive A is hit by cosmic rays, the drive is taken out of the array, but=
=20
the drive's actually still fine, then drive B fails before the operator=
=20
has re-added drive A, the array goes down when it didn't need to.

What is the operator's most likely response to seeing the SATA bus=20
reset? She's going to re-add the drive assuming it was a transient=20
error. If we could make this happen automatically, we could close a=20
window when the array's more vulnerable. I wouldn't suggest we do it=20
silently; it gets logged, notified etc. just like the drive being taken=
=20
out of the array would be.

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
