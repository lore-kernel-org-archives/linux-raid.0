From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Mismatches
Date: Sun, 2 Jan 2011 17:58:00 -0800
Message-ID: <AANLkTiktpsFekCNFcnGcC1wu8_LD14w5WodvH8NiVc3A@mail.gmail.com>
References: <AANLkTimqKmegXCyPqeMn=fDVyPtNgyexUrC6QE4vRBzf@mail.gmail.com>
	<D6.53.07087.CFB212D4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D6.53.07087.CFB212D4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jan 2, 2011 at 5:53 PM, Leslie Rhorer <lrhorer@satx.rr.com> wro=
te:
<SNIP>
>
>> It was my understanding when researching RAID6 last week that the tw=
o
>> parity calculations are actually different. Only one of them is simp=
le
>> parity. The the other is part of an advanced math degree. ;-)
>> (According to Wikipedia, not a definitive source for sure...)
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Well, that's encouraging, if true. =C2=A0I=
t doesn't explain how big
> chunks of data in almost every large file got corrupted, though.
>
>

If it's real and not some strange bug then it certainly doesn't.

Neil had some very good responses.

Also, what does

smartctl -a /dev/sdX say for each drive? Any indication at all of
_any_ drive having problems?

- Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
