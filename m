From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: "Enhanced" MD code avaible for review
Date: Wed, 17 Mar 2004 15:02:38 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4058AEDE.10305@pobox.com>
References: <459805408.1079547261@aslan.scsiguy.com> <4058A481.3020505@pobox.com> <20040317193206.A17987@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040317193206.A17987@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-raid@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Christoph Hellwig wrote:
> On Wed, Mar 17, 2004 at 02:18:25PM -0500, Jeff Garzik wrote:
>=20
>>>	o Allow fully pluggable meta-data modules
>>
>>yep, needed
>=20
>=20
> Well, this is pretty much the EVMS route we all heavily argued agains=
t.
> Most of the metadata shouldn't be visible in the kernel at all.

_some_ metadata is required at runtime, and must be in the kernel.  I=20
agree that a lot of configuration doesn't necessarily need to be in the=
=20
kernel.  But stuff like bad sector and event logs, and other bits are=20
still needed at runtime.


>>>	o Improve the ability of MD to auto-configure arrays.
>>
>>hmmmm.  Maybe in my language this means "improve ability for low-leve=
l=20
>>drivers to communicate RAID support to upper layers"?
>=20
>=20
> I think he's talking about the deprecated raid autorun feature.  Agai=
n
> something that is completely misplaced in the kernel.  (=E5gain EVMS =
light)

Indeed, but I'll let him and the code illuminate the meaning :)

	Jeff



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
