From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] FIX: Cannot continue reshape if incremental assembly is
 used
Date: Thu, 8 Sep 2011 11:26:33 +1000
Message-ID: <20110908112633.25a982b0@notabene.brown>
References: <AcxtYQevh8pgNQALRp+uJrxQ29o1Kg==>
	<D9FFE20C522965449E182ACE73889AEB020100@IRSMSX101.ger.corp.intel.com>
	<CABE8wwsRYSD=zUGJbhAtRFqGL+WPPP4Sy85ExsvSxog6k1JymQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABE8wwsRYSD=zUGJbhAtRFqGL+WPPP4Sy85ExsvSxog6k1JymQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "Dorau, Lukasz" <lukasz.dorau@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Wed, 7 Sep 2011 18:11:12 -0700 "Williams, Dan J"
<dan.j.williams@intel.com> wrote:

> On Wed, Sep 7, 2011 at 6:21 AM, Dorau, Lukasz <lukasz.dorau@intel.com=
> wrote:
> > On Wed, Sep 07, 2011 4:38 AM Neil Brown <neilb@suse.de> wrote:
> >>
> >> On Tue, 6 Sep 2011 14:34:42 -0700 Dan Williams <dan.j.williams@int=
el.com>
> >> wrote:
> >>
> >> > On Thu, Sep 1, 2011 at 6:18 AM, Lukasz Dorau <lukasz.dorau@intel=
=2Ecom>
> >> wrote:
> >> > > Description of the bug:
> >> > > Interrupted reshape cannot be continued using incremental asse=
mbly.
> >> > > Array becomes inactive.
> >> > >
> >> > > Cause of the bug:
> >> > > Reshape tried to continue with insufficient number of disks
> >> > > added by incremental assembly (tested using capacity expansion=
).
> >> > >
> >> > > Solution:
> >> > > During reshape adding disks to array should be blocked until
> >> > > minimum required number of disks is ready to be added.
> >> >
> >> > Can you provide a script test-case to reproduce the problem?
> >>
> >> I can:
> >>
> >> mdadm -C /dev/md/imsm -e imsm -n 4 /dev/sd[abcd]
> >> mdadm -C /dev/md/r5 -n3 -l5 /dev/md/imsm -z 2000000
> >> mdadm --wait /dev/md/r5
> >> mdadm -G /dev/md/imsm -n4
> >> sleep 10
> >> mdadm -Ss
> >> mdadm -I /dev/sda
> >> mdadm -I /dev/sdb
> >> mdadm -I /dev/sdc
> >>
> >> array is started and reshape continues.
> >>
> >> The problem is that container_content reports that array.working_d=
isks is 3
> >> rather than 4.
> >> 'working_disks' should be the number of disks int the array that w=
ere working
> >> last time
> >> the array was assembled.
>=20
> Hmm, this might just be cribbed from the initial DDF implementation,
> should be straightforward to reuse the count we use for
> container_enough, but I'm not seeing where Incremental uses
> working_disks for external arrays...

Assemble.c: assemble_container_content()
=2E...
	if (runstop > 0 ||
		 (working + preexist + expansion) >=3D
			content->array.working_disks) {
=2E...

>=20
> >> However the imsm code only counts devices that can currently be fo=
und.
> >> I'm not familiar enough with the IMSM metadata to fix this.
> >> However by looking at the metadata on just one device in an array =
it should be
> >> possible
> >> to work out how many were working last time, and report that count=
=2E
> >>
> >
> > Neil, please consider the following script test-case (not 4 but 5 d=
rives finally in the array):
> >
> > mdadm -C /dev/md/imsm -e imsm -n 5 /dev/sd[abcde]
> > mdadm -C /dev/md/r5 -n3 -l5 /dev/md/imsm -z 2000000
> > mdadm --wait /dev/md/r5
> > mdadm -G /dev/md/imsm -n5
> > sleep 10
> > mdadm -Ss
> > mdadm -I /dev/sda
> > mdadm -I /dev/sdb
> > mdadm -I /dev/sdc
> > # array is not started and reshape does not continue!
> > mdadm -I /dev/sdd
> >
> > and now array is started and reshape continues - the minimum requir=
ed number of disks is added to array already.
> >
> > So the question is: =A0when mdadm should start the array using incr=
emental assembly?:
>=20
> As soon as all drives are present, or when the minimum number is
> present and --run is specified.
>=20
> > 1) when minimum required number of disks is added and (degraded) ar=
ray can be started or
> > 2) when all disks that were working last time the array was assembl=
ed are added.
>=20
> This is what ->container_enough attempts to identify, and it looks
> like you are running into the fact that it does not take into account
> migration.  imsm_count_failed() is returning the wrong value, and it
> has the comment:
>=20
>         /* FIXME add support for online capacity expansion and
>          * raid-level-migration
>          */
> The routine in getinfo_super_imsm should also be looking at map0,
> currently it is looking at map1 to determine the number of device
> members.
>=20
> > If the second is true, there is another question: when to decide to=
 give up waiting for non-present disks that can be (e.g.) removed meanw=
hile by user?
>=20
> Not really mdadm's problem.  That's primarily up to the udev policy.

Yes.  The theory is that once "enough time" as passed you run "mdadm -I=
Rs" to
pick up the pieces.  However I don't know where we should put that comm=
and.

NeilBrown


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
