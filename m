From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: MD driver development effort.
Date: Fri, 16 Jan 2004 10:42:48 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040116094248.GI22417@marowsky-bree.de>
References: <7A371016E109114EA47C89370296278B01F305BF@xrose01.rose.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7A371016E109114EA47C89370296278B01F305BF@xrose01.rose.hp.com>
To: "DIARE,ABOUBACAR (HP-Roseville,ex1)" <aboubacar.diare@hp.com>, "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
Cc: mauelshagen@sistina.com
List-Id: linux-raid.ids

On 2004-01-14T23:05:15,
   "DIARE,ABOUBACAR (HP-Roseville,ex1)" <aboubacar.diare@hp.com> said:

> Does anyone know if there are any ongoing development work on the md =
driver
> multipathing capabilities?

Jens Axboe and I have done work on the 2.4 multipathing module for md t=
o
the point where it was useable for our needs. But this is not the way
for 2.6.

=46or 2.6, the way to go was decided at KS/OLS 2003 - a Device Mapper
module would be used. Heinz Mauelshagen keeps telling me he has already
written it a long time ago and just needs to release it, but maybe you
can bug him so that it indeed gets committed to the kernel tree ;-)

> Because there isn't any industry standard path failover product for L=
inux MD
> seems to be what many turn too especially since it is readily availab=
le in
> all distros.  So I am wondering if future enhancements work to md tha=
t are
> going could help position md as maybe a potential industry standard p=
ath
> failover product and not only a raid enabler.

BINGO! Uhm, I meant to say:

At the leading technical steering conference for the Linux kernel produ=
ct
development group in the year 2003 a.d. in Ottawa, the lead system
architects have met with critically important industry representatives
and highly valued customers. During the in-depth technical discussions,
which were entirely market-demand-driven, we pushed forward towards an
industry standard solution for the next generation Linux kernel
2.6-based enterprise products. We have successfully converged on a
solution taking the synergetic effects between the enhanced
Device-Mapper framework, the hotplug core functionality and the next
millenia volume manager products (EVMS2 and LVM2) to the extreme. The
industry stakeholders were highly pleased with the proposed modular
architecture, which will enable them to build value-add load-balancing
and advanced IO scheduling modules directly on top of the core
technology without risking to be tainted by the GPL issues of the
mainstream vanilla kernel.

> Thanks for you time.

It was my pleasure!


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

PS: Sorry. I couldn't resist. I tried. For a second.

--=20
High Availability & Clustering	      \ ever tried. ever failed. no matt=
er.
SUSE Labs			      | try again. fail again. fail better.
Research & Development, SUSE LINUX AG \ 	-- Samuel Beckett

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
