From: =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mru@kth.se>
Subject: Re: HighPoint Rocket 1540 hang driver load
Date: Thu, 22 Apr 2004 20:29:38 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <yw1x7jw7uar1.fsf@kth.se>
References: <40865AEC.8040604@online.no> <1082561078.40869236f3c14@www.tastycake.net>
 <yw1xd66146fo.fsf@kth.se> <1082641732.4087cd44b504f@www.tastycake.net>
 <yw1x7jw8qeff.fsf@kth.se> <40880724.3060600@online.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lars Gaarden <lar-gaar@online.no> writes:

> M=E5ns Rullg=E5rd wrote:
>> Nick Maynard <nick.maynard@alumni.doc.ic.ac.uk> writes:
>>
>>>The Rocket 1540 and the RocketRAID 1540 are different cards.  I am s=
ure the
>>>RocketRAID 1540 is a lovely card.  The Rocket 1540 is not, however.
>> Apparently that is the case.  What is the exact PCI id and revision
>> of
>> the chip used on the Rocket1540?  My Rocketraid 1540 reports as
>> 1103:0008 (rev 07).
>>
>
> No chance distinguishing them based on PCI id/rev, it seems.
> Here is the lspci -vvn for my Rocket1540.
>
> 00:08.0 Class 0104: 1103:0008 (rev 07)
>          Subsystem: 1103:0001

=46or the record, my rocketraid1540 has that same subsystem id too.

--=20
M=E5ns Rullg=E5rd
mru@kth.se

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
