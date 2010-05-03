From: Neil Brown <neilb@suse.de>
Subject: Re: More Hot Unplug/Plug work
Date: Mon, 3 May 2010 15:58:11 +1000
Message-ID: <20100503155811.3bbcf9bd@notabene.brown>
References: <4BD714A3.9020801@redhat.com>
	<905EDD02F158D948B186911EB64DB3D11C954788@irsmsx503.ger.corp.intel.com>
	<4BD874CB.5040803@redhat.com>
	<905EDD02F158D948B186911EB64DB3D11C95485F@irsmsx503.ger.corp.intel.com>
	<4BD8A336.7080309@redhat.com>
	<20100429110153.7148bb9b@notabene.brown>
	<4BD8DEB1.40801@intel.com>
	<20100429123717.2144a341@notabene.brown>
	<l2he9c3a7c21004291455w936bab77gea816e681f72a943@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <l2he9c3a7c21004291455w936bab77gea816e681f72a943@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Doug Ledford <dledford@redhat.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On Thu, 29 Apr 2010 14:55:23 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> On Wed, Apr 28, 2010 at 7:37 PM, Neil Brown <neilb@suse.de> wrote:
> >> So something like DOMAIN spanning=3Dimsm, to tell mdadm to follow =
imsm
> >> rules for this domain. =C2=A0Where 'spanning' is policy tag??
> >>
> >
> > Thanks.
> >
> > So we have two different ideas here.
> >
> > 1/ A given set of devices (paths) are all attached to the one contr=
oller.
> > 2/ A given array is not allowed to span controllers
> >
> > The first statement is somewhat similar to a statement about spareg=
roups.
> > It groups devices together is some way.
> >
> > The second is a policy statement, and is metadata specific to some =
extent.
> > If I create a native-metadata array using the controller, then addi=
ng other
> > devices from a different controller is a non-issue. =C2=A0It is onl=
y when an
> > IMSM array is created that it is an issue (and then - only if the a=
rray is to
> > be used for boot for for multi-boot).
> >
> > So the ARRAY line could have "exclusive-group=3Dfoo" where 'foo' is=
 a group
> > name similar to those used for 'spare-group=3D'
> > But that isn't much fun for auto-detect and auto-assembly.
> >
> > Maybe we want to extend the 'auto' line. =C2=A0It gives policy on a=
 per-metadata
> > basis. Maybe:
> >
> > =C2=A0POLICY auto-assemble =C2=A0+1.x -all
> > =C2=A0POLICY same-group =C2=A0imsm
> >
> > where 'same-group' means that all the devices in an array must be i=
n the
> > same spare-group. =C2=A0The 'domain' lines assign spare-groups to d=
evices.
> >
> > Maybe "same-group" could be "same-$tag" so we could have different =
tags
> > for different metadatas....
> >
> > Is this working for anyone else, or have I lost the plot??
> >
>=20
> I am not grokking the separate POLICY line, especially for defining
> the spare-migration border because that is already what DOMAIN is
> specifying.

Is it?  This is what I'm not yet 100% convinced about.
We seem to be saying:
 - A DOMAIN is a set of devices that are handled the same way for
    hotplug
 - A DOMAIN is a set of devices that define a boundary on spare
    migration

and I'm not sure those sets are necessarily isomorphic - though I agree=
 that
they will often be the same.

Does each DOMAIN line define a separate migration boundary so that devi=
ces
cannot migrate 'across domains'??
If we were to require that, I would probably want multiple 'path=3D' wo=
rds
allowed for a single domain so we can create a union.

>=20
> Here is what I think we need to allow for simple honoring of platform
> constraints but without needing to expose all the nuances of those
> constraints in config-file syntax... yet.
>=20
> 1/ Allow path=3D to take a metadata name this allows the handler to
> identify its known controller ports, alleviating the user from needin=
g
> to track which ports are allowed, especially as it may change over
> time.  If someone really wants to see which ports a metadata handler
> cares about we could have a DOMAIN line dumped by --detail-platform
> --brief -e imsm.  However for simplicity I would rather just dump:
>=20
> DOMAIN path=3Dimsm action=3Dspare-same-port spare-migration=3Dimsm
>=20

So "path=3Dimsm" means "all devices which are attached to a controller =
which
seems to understand IMSM natively".
What if a system had two such controllers - one on-board and one on a p=
lug-in
card.  This might not be possibly for IMSM but would be for DDF.
I presume the default would be that the controllers are separate domain=
s -
would you agree?  So the above DOMAIN line would potentially create mul=
tiple
'domains' at least for spare-migration.

> 2/ I think we should always block configurations that cross domain
> boundaries.  One can always append more path=3D lines to override thi=
s.

I think we all agree on this.  Require --force to create an array, or a=
dd
devices to an array, where that would cross an established spare-group.=
=2E.
The details are still a bit vague for me but the principle is good.

>=20
> 3/ The metadata handler may want to restrict/control where spares are
> placed in a domain.  To enable interaction with CIM we are looking to
> add a storage-pool id to the metadata.  The primary usage of this wil=
l
> be to essentially encode a spare-group number in the metadata.  This
> seems to require a spare-migration=3D option to the DOMAIN line.  By
> default it is 'all' but it can be set to a metadata-name to let the
> handler apply its internal migration policy.

I'm not following you.  Are you talking about subsets of a domain? Subd=
omains?
Do the storage-pools follow hardware port locations, or dynamic configu=
ration
of individual devices (hence being recorded in metadata).

This is how I think spare migration should work:
 Spare migration is controlled entirely by the 'spare-group' attribute.
 A spare-group is an attribute of a device. A device may have multiple
   spare-group attributes (it might be in multiple groups).
 There are two ways a device can be assigned a spare-group.
  1/ If an array is tagged with a spare-group=3D in mdadm.conf then any=
 device
    in that array gets that spare-group attribute
  2/ If a DOMAIN is tagged with a spare-group attribute then any device
    in that domain gets that spare-group attribute

 When mdadm --monitor needs to find a hot spare for an array or contain=
er
 which is degraded, it collects a list of spare-group attributes
 for all devices in the array, then finds any device (of suitable size)
 that has a spare-group attribute matching any of those.
 Possibly a weighting should prefer spare-groups that are more prevalen=
t in
 the array, so that if you add a foreign device in an emergency, mdadm =
won't
 feel too free to add other foreign devices (but is still allowed to).

 You seem to be suggesting that the spare-group tag could also be speci=
fied
 by the metadata.  I think I'm happy with that.

 A DOMAIN line without an explicit spare-group=3D tag might imply an im=
plicit
 spare-group=3D tag where the spare-group name is some generated string=
 that
 is unique to that DOMAIN line.
 So all devices in a DOMAIN line are effectively interchangeable, but i=
t is
 easy to stretch the migration barrier around multiple domains by givin=
g
 them all a matching spare-group tag.

When you create an array, every pair of devices much share a spare-grou=
p, or
else one of them must not be in an spare-group.  Is that right?

NeilBrown
=20
>=20
> That should cover everything I would like to expose  Comments?
>=20
> --
> Dan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
