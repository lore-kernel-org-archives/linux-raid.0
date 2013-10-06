From: =?UTF-8?B?TWljaGHFgiBTYXdpY3o=?= <michal@sawicz.net>
Subject: Re: Help with data recovery - RAID6 with 2 failed drives and another
  with broken sectors
Date: Mon, 07 Oct 2013 00:11:05 +0200
Message-ID: <5251DFF9.4050708@sawicz.net>
References: <524A07DC.1040002@sawicz.net> <524B2158.2020900@sawicz.net> <5251D9AF.9030402@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5251D9AF.9030402@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06.10.2013 23:44, Phil Turmel wrote:
> The answer is*NO*.  That is not expected.  But it does happen with
> timeout mismatches, and the double failure you experienced is a commo=
n
> result of error correction timeout mismatch.  Timeout mismatch is whe=
re
> your drives are internally trying to retry reading a bad sector long
> after the OS has given up.  It is always associated with consumer-gra=
de
> hard drives in raid arrays.

Right, I knew that consumer HDDs did that, but didn't expect this to=20
cause such mayhem. So the take out for me for this is: as soon as you=20
see bad blocks on the drive, fail it, otherwise the whole array will=20
probably get kicked out sooner or later. Or try and manually force the=20
drive to reallocate, and then do a scrub.

> You might want to search the list archives for various combinations o=
f
> "error recovery", "scterc", "URE" and "timeout mismatch" for a full
> description of the problem and the recommended ways to avoid it.

Thanks, will do.
--=20
Micha=C5=82 (Saviq) Sawicz <michal@sawicz.net>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
