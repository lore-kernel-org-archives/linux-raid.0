From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID6 data-check took almost 2 hours, clicking sounds, system
 unresponsive
Date: Fri, 15 Apr 2011 00:15:00 +0100
Message-ID: <4DA77FF4.7030007@anonymous.org.uk>
References: <259379.79604.qm@web65105.mail.ac2.yahoo.com> <BANLkTinttwOaDm=QK5nbUd6Vbfzwur1Lyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTinttwOaDm=QK5nbUd6Vbfzwur1Lyw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: Gavin Flower <gavinflower@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/04/2011 22:19, Mathias Bur=C3=A9n wrote:
> On 14 April 2011 22:14, Gavin Flower<gavinflower@yahoo.com>  wrote:
[...]
>> Attaching OpenDocument file with full details of smart output and co=
mparison table.
[...]
> sda has a value higher than 0 on reported uncorrected sectors. That's
> enough for me to replace a drive. (heck, even if I see 1 reallocated
> sector I'd RMA it ASAP).

I've had a look at some of my drives' SMART output, and only my Samsung=
=20
drives have it - one showing 57 (with zero reallocated, pending or=20
offline sectors) and one showing 331 (zero reallocated, one pending and=
=20
zero offline sectors). Neither drive has ever given a read error, and I=
=20
do run a weekly check on my arrays which has never reported any mismatc=
hes.

Googling for this field doesn't give any indication that it is relevant=
=20
to determining whether a drive is failing, but if someone with more=20
SMART expertise can comment I'll be quite happy to be corrected...

Having said that, all of Gavin's drives apart from sdc show non-zero=20
reallocated sector counts, and that field definitely is one to follow=20
when considering replacing drives.

Cheers,

John.
(Just started long self-tests on all my local drives)

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
