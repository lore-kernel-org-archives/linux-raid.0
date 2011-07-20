From: Werner Fischer <devlists@wefi.net>
Subject: Re: Software RAID and TRIM
Date: Wed, 20 Jul 2011 14:13:42 +0200
Message-ID: <1311164022.2031.0.camel@werner-t410>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk>
	 <iud06d$ad5$1@dough.gmane.org> <4E235984.2070704@5t9.de>
	 <j012fa$6k6$1@dough.gmane.org> <j01ssr$j1i$1@dough.gmane.org>
	 <j024fe$4va$1@dough.gmane.org> <j03ipg$uqk$1@dough.gmane.org>
	 <j03m2p$jn1$1@dough.gmane.org>
	 <alpine.OSX.2.00.1107191516181.275@trogdor.csi.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.00.1107191516181.275@trogdor.csi.cam.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2011-07-19 at 15:19 +0100, Tom De Mulder wrote:
> In case people are interested, I ran more benchmarks. The impact of T=
RIM=20
> on an over-provisioned drive is remarkable: a 25% performance loss wh=
en=20
> using Postmark.
>=20
> Because this isn't really on-topic for the MD mailing list, I've put =
it=20
> somewhere else:
>=20
> http://tdm27.wordpress.com/2011/07/19/some-solid-state-drive-benchmar=
ks/
>=20
> My next goal, when I have the time, is to compare different amounts o=
f=20
> over-provisioning.

There is a paper from Intel "Over-provisioning an Intel=C2=AE SSD" (ana=
lyzing
X25-M 160 GB Gen.2 SSDs):
http://cache-www.intel.com/cd/00/00/45/95/459555_459555.pdf

On page 10 of this Intel presentation they mention that a spare area
>27% of native capacity has diminishing returns for such an SSD:
http://maltiel-consulting.com/Enterprise_Data_Integrity_Increasing_Endu=
rance.pdf

Regards,
Werner

--=20
: Werner Fischer
: Technology Specialist
: Thomas-Krenn.AG | The server-experts
: http://www.thomas-krenn.com | http://www.thomas-krenn.com/wiki

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
