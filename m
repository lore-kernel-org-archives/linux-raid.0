From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: More Hot Unplug/Plug work
Date: Fri, 7 May 2010 18:06:48 -0700
Message-ID: <l2ue9c3a7c21005071806jc5286434i9834ed9f954b1b89@mail.gmail.com>
References: <4BD714A3.9020801@redhat.com>
	 <905EDD02F158D948B186911EB64DB3D11C954788@irsmsx503.ger.corp.intel.com>
	 <4BD874CB.5040803@redhat.com>
	 <905EDD02F158D948B186911EB64DB3D11C95485F@irsmsx503.ger.corp.intel.com>
	 <4BD8A336.7080309@redhat.com> <20100429110153.7148bb9b@notabene.brown>
	 <4BD8DEB1.40801@intel.com> <20100429123717.2144a341@notabene.brown>
	 <l2he9c3a7c21004291455w936bab77gea816e681f72a943@mail.gmail.com>
	 <20100503155811.3bbcf9bd@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100503155811.3bbcf9bd@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On Sun, May 2, 2010 at 10:58 PM, Neil Brown <neilb@suse.de> wrote:
> On Thu, 29 Apr 2010 14:55:23 -0700
> Dan Williams <dan.j.williams@intel.com> wrote:
>> I am not grokking the separate POLICY line, especially for defining
>> the spare-migration border because that is already what DOMAIN is
>> specifying.
>
> Is it? =A0This is what I'm not yet 100% convinced about.
> We seem to be saying:
> =A0- A DOMAIN is a set of devices that are handled the same way for
> =A0 =A0hotplug
> =A0- A DOMAIN is a set of devices that define a boundary on spare
> =A0 =A0migration

The definition I have been carrying around is slightly more nuanced.
The DOMAIN defines a maximal boundary, but there might be metadata
specific modifiers that further restrict the possible actions.  For
example a DOMAIN path=3Dddf domain would handle all hotplug events on
"ddf" ports the same way with the caveat that the ddf handler would
know about controller spanning rules in the multi-controller case.
Otherwise if you define path=3D<pci-device-path+partitions> then
wysiwyg, i.e. no arrays assembling across these boundaries.

>
> and I'm not sure those sets are necessarily isomorphic - though I agr=
ee that
> they will often be the same.
>
> Does each DOMAIN line define a separate migration boundary so that de=
vices
> cannot migrate 'across domains'??
> If we were to require that, I would probably want multiple 'path=3D' =
words
> allowed for a single domain so we can create a union.

Yes, we should do that regardless because it would be hard to write a
glob that covers disparate controllers otherwise.

>>
>> Here is what I think we need to allow for simple honoring of platfor=
m
>> constraints but without needing to expose all the nuances of those
>> constraints in config-file syntax... yet.
>>
>> 1/ Allow path=3D to take a metadata name this allows the handler to
>> identify its known controller ports, alleviating the user from needi=
ng
>> to track which ports are allowed, especially as it may change over
>> time. =A0If someone really wants to see which ports a metadata handl=
er
>> cares about we could have a DOMAIN line dumped by --detail-platform
>> --brief -e imsm. =A0However for simplicity I would rather just dump:
>>
>> DOMAIN path=3Dimsm action=3Dspare-same-port spare-migration=3Dimsm
>>
>
> So "path=3Dimsm" means "all devices which are attached to a controlle=
r which
> seems to understand IMSM natively".
> What if a system had two such controllers - one on-board and one on a=
 plug-in
> card. =A0This might not be possibly for IMSM but would be for DDF.
> I presume the default would be that the controllers are separate doma=
ins -
> would you agree?

The controllers may restrict spare migration but I would still see
this as one ddf DOMAIN where the paths and spare migration constraints
are internally determined by the handler, but the hotplug policy is
global for the "ddf-DOMAIN".

> So the above DOMAIN line would potentially create multiple
> 'domains' at least for spare-migration.

Yes.

>
>> 2/ I think we should always block configurations that cross domain
>> boundaries. =A0One can always append more path=3D lines to override =
this.
>
> I think we all agree on this. =A0Require --force to create an array, =
or add
> devices to an array, where that would cross an established spare-grou=
p...
> The details are still a bit vague for me but the principle is good.
>
>>
>> 3/ The metadata handler may want to restrict/control where spares ar=
e
>> placed in a domain. =A0To enable interaction with CIM we are looking=
 to
>> add a storage-pool id to the metadata. =A0The primary usage of this =
will
>> be to essentially encode a spare-group number in the metadata. =A0Th=
is
>> seems to require a spare-migration=3D option to the DOMAIN line. =A0=
By
>> default it is 'all' but it can be set to a metadata-name to let the
>> handler apply its internal migration policy.
>
> I'm not following you. =A0Are you talking about subsets of a domain? =
Subdomains?
> Do the storage-pools follow hardware port locations, or dynamic confi=
guration
> of individual devices (hence being recorded in metadata).

Dynamic configuration, but I would still call this the imsm-DOMAIN
with metadata specific spare-migration-boundaries.

>
> This is how I think spare migration should work:
> =A0Spare migration is controlled entirely by the 'spare-group' attrib=
ute.
> =A0A spare-group is an attribute of a device. A device may have multi=
ple
> =A0 spare-group attributes (it might be in multiple groups).
> =A0There are two ways a device can be assigned a spare-group.
> =A01/ If an array is tagged with a spare-group=3D in mdadm.conf then =
any device
> =A0 =A0in that array gets that spare-group attribute
> =A02/ If a DOMAIN is tagged with a spare-group attribute then any dev=
ice
> =A0 =A0in that domain gets that spare-group attribute
>
> =A0When mdadm --monitor needs to find a hot spare for an array or con=
tainer
> =A0which is degraded, it collects a list of spare-group attributes
> =A0for all devices in the array, then finds any device (of suitable s=
ize)
> =A0that has a spare-group attribute matching any of those.
> =A0Possibly a weighting should prefer spare-groups that are more prev=
alent in
> =A0the array, so that if you add a foreign device in an emergency, md=
adm won't
> =A0feel too free to add other foreign devices (but is still allowed t=
o).
>
> =A0You seem to be suggesting that the spare-group tag could also be s=
pecified
> =A0by the metadata. =A0I think I'm happy with that.

Yeah, metadata implied spare-groups that sub-divide the domain.

>
> =A0A DOMAIN line without an explicit spare-group=3D tag might imply a=
n implicit
> =A0spare-group=3D tag where the spare-group name is some generated st=
ring that
> =A0is unique to that DOMAIN line.
> =A0So all devices in a DOMAIN line are effectively interchangeable, b=
ut it is
> =A0easy to stretch the migration barrier around multiple domains by g=
iving
> =A0them all a matching spare-group tag.
>
> When you create an array, every pair of devices much share a spare-gr=
oup, or
> else one of them must not be in an spare-group. =A0Is that right?

=2E..once you allow for $metadata-DOMAINs I am having trouble
conceptualizing the use case for allowing spares to migrate across the
explicit union of path=3D boundaries?  Unless you are trying to codify
what the metadata handlers would be doing internally.  In which case I
would expect to replace a single spare-group=3D identifier with multipl=
e
mutually exclusive spare-path=3D lines to subdivide a DOMAIN into spare
migration sub-domains with the same hot-plug policy.

=2E..or am I still misunderstanding your spare-group=3D vs DOMAIN disti=
nction?

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
