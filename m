From: Jure =?ISO-8859-2?Q?Pe=5Far?= <pegasus@nerv.eu.org>
Subject: Re: Badstripe proposal (was Re: Bad blocks are killing us!)
Date: Fri, 19 Nov 2004 18:12:22 +0100
Message-ID: <20041119181222.6ce1f1be.pegasus@nerv.eu.org>
References: <200411162307.iAGN7lN28260@www.watkins-home.com>
	<419B5050.1010501@dgreaves.com>
	<419C729D.3E36A473@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <419C729D.3E36A473@libero.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 18 Nov 2004 10:59:58 +0100
Maurilio Longo <maurilio.longo@libero.it> wrote:

> David and others,
>=20
> I'd like to add that evms ( http://evms.sourceforge.net/ ) already ha=
s a
> bad-block management layer, maybe it could be merged inside md to hav=
e
> write errors management as well, maybe :)

BBR as it is called is implemented with a device mapper. AFAIK one can =
take
dm managed block devices and build md with them.=20


--=20

Jure Pe=E8ar
http://jure.pecar.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
