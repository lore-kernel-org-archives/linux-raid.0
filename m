From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Auto Rebuild on hot-plug
Date: Mon, 29 Mar 2010 14:36:45 -0700
Message-ID: <e9c3a7c21003291436lb898278i21f988fd5f76bd53@mail.gmail.com>
References: <20100325113543.0e2124c5@notabene.brown>
	 <905EDD02F158D948B186911EB64DB3D11C510278@irsmsx503.ger.corp.intel.com>
	 <e9c3a7c21003261737k1e753b08xc6f8eb45d0320be9@mail.gmail.com>
	 <4BB0ED13.6020507@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB0ED13.6020507@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "Labun, Marcin" <Marcin.Labun@intel.com>, Neil Brown <neilb@suse.de>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

On Mon, Mar 29, 2010 at 11:10 AM, Doug Ledford <dledford@redhat.com> wr=
ote:
> The second thing I'm having a hard time with is the spare-group. =A0T=
o be
> honest, if I follow what I think I should, and make it a hard
> requirement that any action other than none and incremental must use =
a
> non-global path glob (aka, path=3D MUST be present and can not be *),=
 then
> spare-group looses all meaning. =A0I say this because if a disk match=
es
> the path glob is it in a specific spare group already (the one that t=
his
> DOMAIN represents) and ditto if arrays are on disks in this DOMAIN, t=
hen
> they are automatically part of the same spare-group. =A0In other word=
s, I
> think spare-group becomes entirely redundant once we have a DOMAIN ke=
yword.

I agree once you have a DOMAIN you implicitly have a spare-group.  So
DOMAIN would supersede the existing spare-group identifier in the
ARRAY line and cause mdadm --monitor to auto-migrate spares between
0.90 and 1.x metadata arrays in the same DOMAIN.  For the imsm case
the expectation is that spares migrate between containers regardless
of the DOMAIN line as that is what the implementation expects.
However this is where we get into questions of DOMAIN conflicting with
'platform' expectations, under what conditions, if any, should DOMAIN
be allowed to conflict/override the platform constraint?  Currently
there is an environment variable IMSM_NO_PLATFORM, do we also need a
configuration op

> I'm also having a hard time justifying the existence of the metadata
> keyword. =A0The reason is that the metadata is already determined for=
 us
> by the path glob. =A0Specifically, if we assume that an array's membe=
rs
> can not cross domain boundaries (a reasonable requirement in my opini=
on,
> we can't make an array where we can guarantee to the user that hot
> plugging a replacement disk will do what they expect if some of the
> array's members are inside the domain and some are outside the domain=
),
> then we should only ever need the metadata keyword if we are mixing
> metadata types within this domain. =A0Well, we can always narrow down=
 the
> domain if we are doing something like the first three sata disks on a=
n
> Intel Matrix RAID controller as imsm and the last three as jbod with
> version 1.x metadata by putting the first half in one domain and the
> second half in another. =A0And this would be the right thing to do ve=
rsus
> trying to cover both in one domain. =A0That means that only if we eve=
r
> mixed imsm/ddf and md native raid types on a single disk would we be
> unable to narrow down the domain properly, and I'm not sure we care t=
o
> support this. =A0So, that leaves us back to not really needing the
> metadata keyword as the disks present in the path spec glob should be
> uniform in the metadata type and we should be able to simply use the
> right metadata from that.

=2E..but this assumes we already have an array assembled in the domain
before the first hot plug event.  The 'metadata' keyword would be
helpful at assembly time for ensuring only arrays of a certain type
are brought up in the domain.

We also need some consideration for reporting and enforcing 'platform'
boundaries if the user requests it.  By default mdadm will block
attempts to create/assemble configurations that the option-rom does
not support (i.e. disk attached to third-party controller).  For the
hotplug case if the  DOMAIN is configured incorrectly I can see cases
where a user would like to specify "enforce platform constraints even
if my domain says otherwise", and the inverse "yes, I know the
option-rom does not support this configuration, but I know what I am
doing".

So I see a couple options:
1/ path=3Dplatform: auto-determine/enforce the domain(s) for all
platform raid controllers in the system
2/ Allow the user to manually enter a DOMAIN that is compatible but
different than the default platform constraints like your 3-ahci ports
for imsm-RAID remainder reserved for 1.x arrays example above
3/ Allow the user to turn off platform constraints and define 'exotic'
domains (mixed controller configurations).

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
