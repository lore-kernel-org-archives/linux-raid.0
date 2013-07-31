From: NeilBrown <neilb@suse.de>
Subject: Re: ddf: remove failed devices that are no longer in use ?!?
Date: Wed, 31 Jul 2013 13:25:45 +1000
Message-ID: <20130731132545.56a97d98@notabene.brown>
References: <51F2E4B9.1020505@arcor.de>
	<20130730113435.3421a111@notabene.brown>
	<51F812E8.1080004@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dEa+g289xOrPi6q8UK3mx0Z"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F812E8.1080004@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/dEa+g289xOrPi6q8UK3mx0Z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Jul 2013 21:24:24 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> On 07/30/2013 03:34 AM, NeilBrown wrote:
> > On Fri, 26 Jul 2013 23:06:01 +0200 Martin Wilck <mwilck@arcor.de> wrote:
> >=20
> >> Hi Neil,
> >>
> >> here is another question. 2 years ago you committed c7079c84 "ddf:
> >> remove failed devices that are no longer in use", with the reasoning "=
it
> >> isn't clear what (a phys disk record for every physically attached
> >> device) means in the case of soft raid in a general purpose Linux comp=
uter".
> >>
> >> I am not sure if this was correct. A common use case for DDF is an
> >> actual BIOS fake RAID, possibly dual-boot with a vendor soft-RAID driv=
er
> >> under Windows. Such other driver might be highly confused by mdadm
> >> auto-removing devices. Not even "missing" devices need to be removed
> >> from the meta data in DDF; they can be simply marked "missing".
> >>
> >> May I ask you to reconsider this, and possibly revert c7079c84?
> >> Martin
> >=20
> > You may certainly ask ....
> >=20
> > I presumably had a motivation for that change.  Unfortunately I didn't =
record
> > the motivation, only the excuse.
> >=20
> > It probably comes down to a question of when *do* you remove phys disk
> > records?
> > I think that if I revert that patch we could get a situation where we k=
eep
> > adding new phys disk records and fill up some table.
>=20
> How is this handled with native meta data? IMSM? Is there any reason to
> treat DDF special? In a hw RAID scenario, the user would remove the
> failed disk physically sooner or later, and it would switch to "missing"
> state. So here, I'd expect the user to call mdadm --remove.

Native metadata doesn't really differentiate between 'device has failed' and
'device isn't present'.  There are bits in the 0.90 format that can tell the
difference, but the two states are treated the same.

When a device fails it transition for 'working' to 'failed but still
present'.  Then when you "mdadm --remove" it transitions to "not present".
But it is not possible to go back to "failed but still present".
i.e. if you shut down the array and then start it up again, any devices that
have failed will not be included.  If they have failed then you possibly
cannot read the metadata and you may not know that they "should" be include=
d.

DDF is designed to work in the firmware of card which have a limited number
of port which they have complete control of.  So they may be able to "know"
that a device is present even if it isn't worked.  mdadm is designed with t=
he
same or of perspective.

If a device is working enough to read the metadata it would be possible to
include it in the contain even if it is being treated as 'failed'.  Not sure
how much work it would be to achieve this.

If a device is working enough to be detected on the bus, but not enough to
read the metadata, then you could only include it in the container if some
config information said "These ports all belong to that container".
I doubt that would be worth the effort.

>=20
> We already have find_unused_pde(). We could make this function try
> harder - when no empty slot is found, look for slots with
> "missing|failed" and then "missing" (or "failed"?) disks, and replace
> those with the new disk.

Yes, that could work.

>=20
> > We should probably be recording some sort of WWN or path identifier in =
the
> > metadata and then have md check in /dev/disk/by-XXX to decide if the de=
vice
> > has really disappeared or is just failed.
>=20
> Look for "Cannot be bothered" in super-ddf.c :-)
> This is something that waits to be implemented, for SAS/SATA at least.

:-) I'm hoping someone will turn up who can be bothered...

>=20
> > Maybe the 'path' field in phys_disk_entry could/should be used here.  H=
owever
> > we the BIOS might interpret that in a specific way that mdadm would nee=
d to
> > agree with....
> >=20
> > If we can come up with a reasonably reliable way to remove phys disk re=
cords
> > at an appropriate time, I'm happy to revert this patch.  Until then I'm=
 not
> > sure it is a good idea.....
> >=20
> > But I'm open to being convinced.
>=20
> Well, me too, I may be wrong, after all. Perhaps auto-removal is ok. I
> need to try it with fake RAID.

If you can determine that the current behaviour confuses some BIOS, then
clearly we should fix it.

If not, then the bar for acceptance of changes would probably be a little
higher.  As long as it isn't easy to get a growth of lots of 'failed' entri=
es
in the table I can probably be happy.

NeilBrown

--Sig_/dEa+g289xOrPi6q8UK3mx0Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUfiDuTnsnt1WYoG5AQLqXA/+MdFHHnen1Xtz2w8tHzdRik5xJB1cFfF2
iqf+zyRhEcbI/xO18KzhdrWfTFPB7OveNS0i2U3rYwBTgn4pTThF1le/JU4sc+kS
2z7uivUMaajqwAIkV5+grkr3iqkn9yeV00ZXrPjH9TR7p9RWb6/HW4eiZAGYPj5H
6AeaXCHjQOZqndmJ+6JNAOVu8+N4TungbMaUsEIf+aD+RT6MfjjIwDQHdwUHfrgn
adhwefmPzLut86J4PLMV4gkhq/lA4t1ZzlAxLMB4vACPdZUnUXre8tkzw39xpw3W
3eWih7r+R8v46OzSBzn0kjCW502oG04XQ1ZpdQ43UDMBxnvZ7NIsCLeQA8W125+Q
KbdXmWJ5QJCWZLxJdqQqrOUOyu2vIN/6GHkb/8m3sseociGcdXxm2etBOK9hEG8M
WLuPwV0R5TJal/9pVIi2+4DF+Fr8oD23DPyqFhYWY3Rm25Jr5lTraudWglt+vIxw
21hV/w9yvMXDgSsP36BaAiLXOQI+8hIkClwygTdXs4g72xprpG6rwWX11gjg90Ch
DM/Qn2y7T2YnysAJWBOmaa/vtAzD3I0fx9ZhPoooOi+DX2kLhmdrJshhoIFDbUUW
VgWOm7X2qHlYlFToUU6adW/VO/z63Zh9i926EjnI48tg/rJQqGO4IpyIA5jg9Tb8
GylIkWl8cjM=
=X0HF
-----END PGP SIGNATURE-----

--Sig_/dEa+g289xOrPi6q8UK3mx0Z--
