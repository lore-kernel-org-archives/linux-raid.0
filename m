From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: ANNOUNCE: mdadm 3.0 - A tool for managing Soft RAID under Linux
Date: Tue, 2 Jun 2009 15:58:49 -0700
Message-ID: <e9c3a7c20906021558q28f049ccw8d1b80a5c0f43b72@mail.gmail.com>
References: <18980.48553.328662.80987@notabene.brown>
	 <4A25876A.1010901@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4A25876A.1010901@garzik.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Arjan van de Ven <arjan@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>
List-Id: linux-raid.ids

On Tue, Jun 2, 2009 at 1:11 PM, Jeff Garzik <jeff@garzik.org> wrote:
> Neil Brown wrote:
>>
>> I am pleased to (finally) announce the availability of
>> =A0 mdadm version 3.0
>>
>> It is available at the usual places:
>> =A0 countrycode=3Dxx.
>> =A0 http://www.${countrycode}kernel.org/pub/linux/utils/raid/mdadm/
>> and via git at
>> =A0 git://neil.brown.name/mdadm
>> =A0 http://neil.brown.name/git?p=3Dmdadm
>>
>>
>> This is a major new version and as such should be treated with some
>> caution. =A0However it has seen substantial testing and is considerr=
ed
>> to be ready for wide use.
>>
>>
>> The significant change which justifies the new major version number =
is
>> that mdadm can now handle metadata updates entirely in userspace.
>> This allows mdadm to support metadata formats that the kernel knows
>> nothing about.
>>
>> Currently two such metadata formats are supported:
>> =A0- DDF =A0- The SNIA standard format
>> =A0- Intel Matrix - The metadata used by recent Intel ICH controlers=
=2E
>
> This seems pretty awful from a support standpoint: =A0dmraid has been=
 the sole
> provider of support for vendor-proprietary up until this point.

This bares similarities with the early difficulties of selecting
between ide and libata.

> Now Linux users -- and distro installers -- must choose between softw=
are
> RAID stack "MD" and software RAID stack "DM". =A0That choice is made =
_not_
> based on features, but on knowing the underlying RAID metadata format=
 that
> is required, and what features you need out of it.
>
> dmraid already supports
> =A0 =A0 =A0 =A0- Intel RAID format, touched by Intel as recently as 2=
007
> =A0 =A0 =A0 =A0- DDF, the SNIA standard format
>
> This obviously generates some relevant questions...
>
> 1) Why? =A0This obviously duplicates existing effort and code. =A0The=
 only
> compelling reason I see is RAID5 support, which DM lacks IIRC -- but =
the
> huge issue of user support and duplicated code remains.

The MD raid5 code has been upstream since forever and already has
features like online capacity expansion.  There is also
infrastructure, upstream, for online raid level migration.

> 2) Adding container-like handling obviously moves MD in the direction=
 of DM.
> =A0Does that imply someone will be looking at integrating the two cod=
ebases,
> or will this begin to implement features also found in DM's codebase?

I made a proof-of-concept investigation of what it would take to
activate all dmraid arrays (any metadata format, any raid level) with
MD.  The result, dm2md [1], did not stimulate much in the way of
conversation.

A pluggable architecture for a write-intent log seems to be the only
piece that does not have a current equivalent in MD.  However, the
'bitmap' infrastructure covers most needs.  I think unifying on a
write-intent logging infrastructure is a good place to start working
together.

> 3) What is the status of distro integration efforts? =A0I wager the d=
istro
> installer guys will grumble at having to choose among duplicated RAID=
 code
> and formats.

There has been some grumbling, but the benefits of using one
linux-raid infrastructure for md-metadata and vendor metadata is
appealing.  mdadm-3.0 also makes a serious effort to be more agreeable
with udev and incremental discovery.  So hopefully this makes mdadm
easier to handle in the installer.

> 4) What is the plan for handling existing Intel RAID users (e.g. dmra=
id +
> Intel RAID)? =A0Has Intel been contacted about dmraid issues? =A0What=
 does Intel
> think about this lovely user confusion shoved into their laps?

The confusion was the other way round.  We were faced with how to
achieve long term feature parity of our raid solution across OS's and
the community presented us with two directions DM and MD.  The
decision was made to support and maintain dmraid for existing
deployments while basing future development on extending the MD stack,
because it gave some feature advantages out of the gate.  So, there is
support for both and new development will focus on MD.

> 5) Have the dmraid maintainer and DM folks been queried, given that y=
ou are
> duplicating their functionality via Intel and DDF RAID formats? What =
was
> their response, what issues were raised and resolved?

There have been interludes, but not much in the way of discussion.
Hopefully, this will be a starting point.

Thanks,
Dan

[1] http://marc.info/?l=3Dlinux-raid&m=3D123300614013042&w=3D2
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
