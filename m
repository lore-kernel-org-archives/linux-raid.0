From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 07/14] FIX: Extend size of raid0 array
Date: Fri, 20 Apr 2012 07:23:49 +1000
Message-ID: <20120420072349.7636d58f@notabene.brown>
References: <1334328728-12544-1-git-send-email-adam.kwolek@intel.com>
	<1334328728-12544-2-git-send-email-adam.kwolek@intel.com>
	<1334328728-12544-3-git-send-email-adam.kwolek@intel.com>
	<1334328728-12544-4-git-send-email-adam.kwolek@intel.com>
	<1334328728-12544-5-git-send-email-adam.kwolek@intel.com>
	<1334328728-12544-6-git-send-email-adam.kwolek@intel.com>
	<1334328728-12544-7-git-send-email-adam.kwolek@intel.com>
	<1334328728-12544-8-git-send-email-adam.kwolek@intel.com>
	<20120417125236.5debe352@notabene.brown>
	<D9FFE20C522965449E182ACE73889AEB185DF96A@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4m_kjOYsw7m3gm6pxHVCmbG"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D9FFE20C522965449E182ACE73889AEB185DF96A@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Patelczyk, Maciej" <maciej.patelczyk@intel.com>, "Danecki, Jacek" <jacek.danecki@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>
List-Id: linux-raid.ids

--Sig_/4m_kjOYsw7m3gm6pxHVCmbG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Apr 2012 15:09:45 +0000 "Dorau, Lukasz" <lukasz.dorau@intel.com>
wrote:

> On Tuesday, April 17, 2012 4:53 AM NeilBrown wrote:
> >=20
> > On Fri, 13 Apr 2012 16:52:01 +0200 Adam Kwolek <adam.kwolek@intel.com>
> > wrote:
> >=20
> > > For raid0, takeover operation is required for size change.
> > > Add takeover to degraded raid4 before size change and back to raid0 a=
fter.
> > > Array information has to be read again from md after takeover.
> > >
> > > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > > ---
> > >  Grow.c |   35 +++++++++++++++++++++++++++++++++++
> > >  1 files changed, 35 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/Grow.c b/Grow.c
> > > index 8c7bafc..e8f6554 100644
> > > --- a/Grow.c
> > > +++ b/Grow.c
> > > @@ -1626,6 +1626,7 @@ int Grow_reshape(char *devname, int fd, int
> > quiet, char *backup_file,
> > >  		long long orig_size =3D get_component_size(fd)/2;
> > >  		long long min_csize;
> > >  		struct mdinfo *mdi;
> > > +		int raid0_takeover =3D 0;
> > >
> > >  		if (orig_size =3D=3D 0)
> > >  			orig_size =3D array.size;
> > > @@ -1674,6 +1675,28 @@ int Grow_reshape(char *devname, int fd, int
> > quiet, char *backup_file,
> > >  				"2TB per device\n");
> > >  			size =3D min_csize;
> > >  		}
> > > +		if (st->ss->external) {
> > > +			if (sra->array.level =3D=3D 0) {
> > > +				rv =3D sysfs_set_str(sra, NULL, "level",
> > > +						   "raid5");
> > > +				if (!rv) {
> > > +					raid0_takeover =3D 1;
> > > +					/* get array parametes after takeover
> > > +					 * to chane one parameter at time
> > only
> > > +					 */
> > > +					rv =3D ioctl(fd, GET_ARRAY_INFO,
> > &array);
> > > +				}
> > > +			}
> > > +			/* make sure mdmon is
> > > +			 * aware of the new level */
> > > +			if (!mdmon_running(st->container_dev))
> > > +				start_mdmon(st->container_dev);
> > > +			ping_monitor(container);
> > > +			if (mdmon_running(st->container_dev) &&
> > > +					st->update_tail =3D=3D NULL)
> > > +				st->update_tail =3D &st->updates;
> > > +		}
> > > +
> > >  		array.size =3D size;
> > >  		if (array.size !=3D size) {
> > >  			/* got truncated to 32bit, write to
> > > @@ -1686,12 +1709,24 @@ int Grow_reshape(char *devname, int fd, int
> > quiet, char *backup_file,
> > >  				rv =3D -1;
> > >  		} else {
> > >  			rv =3D ioctl(fd, SET_ARRAY_INFO, &array);
> > > +
> > >  			/* manage array size when it is managed externally
> > >  			 */
> > >  			if ((rv =3D=3D 0) && st->ss->external)
> > >  				rv =3D set_array_size(st, sra, sra->text_version);
> > >  		}
> > >
> > > +		if (raid0_takeover) {
> > > +			/* do not recync non-existing parity,
> > > +			 * we will drop it anyway
> > > +			 */
> > > +			sysfs_set_str(sra, NULL, "sync_action", "idle");
> >=20
> > This is probably ineffective.  If the array thinks it needs to resync, =
then
> > just setting it to 'idle' will only stop in temporarily.  It will immed=
iately
> > start syncing again.
> >=20
> > However given that it is a RAID5 array which is degraded, it shouldn't =
try to
> > resync at all.
> >=20
> > So:  does it still work if you remove this line?  If so, could you send=
 a
> > patch to remove it?
> > If not - we should work out why.
> >=20
>=20
> It doesn't work without this line.
> The N-disks raid0 changes to degraded (N+1)-disks raid5 (N of N+1 disks)=
=20
> in /proc/mdstat after size extension, however the metadata on all disks i=
s correct.
>=20

In that case I suspect that fact that it works with the line is racy and it
could sometimes fail.  Setting "sync_action" to "frozen" would be safer.
Can you confirm that also works?  I'd feel more comfortable about that.

NeilBrown


--Sig_/4m_kjOYsw7m3gm6pxHVCmbG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5CCZTnsnt1WYoG5AQJwDg//ctXEC/Bo7RtV0C7uOrkd7LudNK+WBjNy
RbMUf7mNrfz9YTwol60Kf5x1xtoRiAHdCFiaPNdxY1y1IErFUTXxMll5mtiRJVST
OXYS0UkMXy268MzhICdcN90CRszc5Loh38+i3iuqrCVHqarF07TlzXd9/phIu9QY
XtuZY0lwC3TLf5vzUjrnGPKKh2J7E2bjbYAtrkz+wY/4A2XwxZDAYZyXdIJEeZrg
4OR2fuLbpJsvP2W5SugWgrCKMcgnV8r+59uI3OtphUivL+EmuhefQ4RnmHEBYViB
WxTa+2VdAb3RHeW7hkpkLftfTqU5Ak6fwRCf8C046HJEeyNZfulQMLKCgobd2FyD
z4jOYGAvJ7wgwzegX0Y6SCrh/6r0FHwRdxCF60LQu31XxJrJbNuWwHljsrx4IXzz
eaXjDL4NTPlgPN/QcC2m7NxRPcukFrLypBiVXWSzVxCg/hL59nhj1GFKtA/6uk8B
AcdSbcq5cLscKjzGW+cQ7x82Fjq8hHYcaxitL1BkU0ps4e5z1+DW5tiN2/yNb8W/
SvEOtADDMG2jrkBal42ETH9klcv+HllWtHuF3/b5or47l+FeByoMuwv+BypO58XE
lGSgAHBpYRF+8oHUFOEc5o5KIsyF5mVKxjwXtVuHpznb5r7h/fSRAgFPLqwvZeH/
K17FAYJnFGM=
=Fj9A
-----END PGP SIGNATURE-----

--Sig_/4m_kjOYsw7m3gm6pxHVCmbG--
