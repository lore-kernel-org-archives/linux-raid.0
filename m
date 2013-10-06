From: Phil Turmel <philip@turmel.org>
Subject: Re: Help with data recovery - RAID6 with 2 failed drives and another
 with broken sectors
Date: Sun, 06 Oct 2013 18:15:22 -0400
Message-ID: <5251E0FA.2030206@turmel.org>
References: <524A07DC.1040002@sawicz.net> <524B2158.2020900@sawicz.net> <5251D9AF.9030402@turmel.org> <5251DFF9.4050708@sawicz.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5251DFF9.4050708@sawicz.net>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgiBTYXdpY3o=?= <michal@sawicz.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/06/2013 06:11 PM, Micha=C5=82 Sawicz wrote:
> On 06.10.2013 23:44, Phil Turmel wrote:
>> The answer is*NO*.  That is not expected.  But it does happen with
>> timeout mismatches, and the double failure you experienced is a comm=
on
>> result of error correction timeout mismatch.  Timeout mismatch is wh=
ere
>> your drives are internally trying to retry reading a bad sector long
>> after the OS has given up.  It is always associated with consumer-gr=
ade
>> hard drives in raid arrays.
>=20
> Right, I knew that consumer HDDs did that, but didn't expect this to
> cause such mayhem. So the take out for me for this is: as soon as you
> see bad blocks on the drive, fail it, otherwise the whole array will
> probably get kicked out sooner or later. Or try and manually force th=
e
> drive to reallocate, and then do a scrub.

No, just fix the timeouts.  Otherwise, you'll be kicking drives out
*way* more often than you think.

Do check your smartctl reports for actual relocations, though.  In my
experience, once you pass single digits, further failures are rapid.

>> You might want to search the list archives for various combinations =
of
>> "error recovery", "scterc", "URE" and "timeout mismatch" for a full
>> description of the problem and the recommended ways to avoid it.
>=20
> Thanks, will do.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
