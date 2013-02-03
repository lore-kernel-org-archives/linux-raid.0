From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid 5 to 6 migration
Date: Sun, 03 Feb 2013 09:30:18 -0500
Message-ID: <510E747A.7070808@turmel.org>
References: <29724805.0.1359885630022.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <29724805.0.1359885630022.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid@vger.kernel.org, "Dominique C." <dcouot@hotmail.com>
List-Id: linux-raid.ids

On 02/03/2013 05:00 AM, Roy Sigurd Karlsbakk wrote:
>> Shrinking is usually possible, but there are many more steps,
>> depending
>> on what is in the array.
>>
>> Please provide more detail. The output of "lsdrv"[1] might be a good
>> start.
>=20
> lsdrv? I can't find any references to that=E2=80=A6

Whoops, forgot the reference.  I created it just for this sort of
situation, and people on this list suggested I publish it and make it
more general.  It's a work in progress, so bug reports welcome:

http://github.com/pturmel/lsdrv

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
