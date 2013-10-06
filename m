From: Phil Turmel <philip@turmel.org>
Subject: Re: Help with data recovery - RAID6 with 2 failed drives and another
 with broken sectors
Date: Sun, 06 Oct 2013 17:44:15 -0400
Message-ID: <5251D9AF.9030402@turmel.org>
References: <524A07DC.1040002@sawicz.net> <524B2158.2020900@sawicz.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <524B2158.2020900@sawicz.net>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWljaGHFgiBTYXdpY3o=?= <michal@sawicz.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Micha=C5=82,

On 10/01/2013 03:24 PM, Micha=C5=82 Sawicz wrote:
> On 01.10.2013 01:23, Micha=C5=82 Sawicz wrote:

[trim /]

>> What I'd like to do first is to make sure the array rebuilds onto th=
e 6
>> healthy drives, regardless of the bad blocks, I can probably recover=
 the
>> data (assuming I can find out which files were affected - any
>> pointers?), but if the array doesn't rebuild correctly, I'm afraid i=
t's
>> gonna get worse, and soon.
>=20
> OK, so a ddrescue and --zero-superblock later my array is rebuilding
> onto one healthy spare. According to ddrescue I only lost some 8kB of
> data in more or less one chunk, so after the array is rebuilt my next
> task will be finding which file(s) that was.

I noticed that you never got any direct response, and I realized you
might still be at risk.  In particular, your OP said:

> As a side note... I've a full array scrub enabled on the array every =
now
> and again - and it did run after the disk started failing blocks, but
> they never got reallocated, they all remain pending / uncorrectable. =
Is
> that expected?

The answer is *NO*.  That is not expected.  But it does happen with
timeout mismatches, and the double failure you experienced is a common
result of error correction timeout mismatch.  Timeout mismatch is where
your drives are internally trying to retry reading a bad sector long
after the OS has given up.  It is always associated with consumer-grade
hard drives in raid arrays.

You might want to search the list archives for various combinations of
"error recovery", "scterc", "URE" and "timeout mismatch" for a full
description of the problem and the recommended ways to avoid it.

HTH,

Phil

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
