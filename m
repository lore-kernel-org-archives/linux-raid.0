From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 07/14] FIX: Extend size of raid0 array
Date: Tue, 17 Apr 2012 12:52:36 +1000
Message-ID: <20120417125236.5debe352@notabene.brown>
References: <1334328728-12544-1-git-send-email-adam.kwolek@intel.com>
	<1334328728-12544-2-git-send-email-adam.kwolek@intel.com>
	<1334328728-12544-3-git-send-email-adam.kwolek@intel.com>
	<1334328728-12544-4-git-send-email-adam.kwolek@intel.com>
	<1334328728-12544-5-git-send-email-adam.kwolek@intel.com>
	<1334328728-12544-6-git-send-email-adam.kwolek@intel.com>
	<1334328728-12544-7-git-send-email-adam.kwolek@intel.com>
	<1334328728-12544-8-git-send-email-adam.kwolek@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XcLUs3uubgTf=5d4L4C9ok+"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334328728-12544-8-git-send-email-adam.kwolek@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, grzegorz.grabowski@intel.com, maciej.patelczyk@intel.com, anna.czarnowska@intel.com
List-Id: linux-raid.ids

--Sig_/XcLUs3uubgTf=5d4L4C9ok+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Apr 2012 16:52:01 +0200 Adam Kwolek <adam.kwolek@intel.com> wrot=
e:

> For raid0, takeover operation is required for size change.
> Add takeover to degraded raid4 before size change and back to raid0 after.
> Array information has to be read again from md after takeover.
>=20
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>  Grow.c |   35 +++++++++++++++++++++++++++++++++++
>  1 files changed, 35 insertions(+), 0 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index 8c7bafc..e8f6554 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1626,6 +1626,7 @@ int Grow_reshape(char *devname, int fd, int quiet, =
char *backup_file,
>  		long long orig_size =3D get_component_size(fd)/2;
>  		long long min_csize;
>  		struct mdinfo *mdi;
> +		int raid0_takeover =3D 0;
> =20
>  		if (orig_size =3D=3D 0)
>  			orig_size =3D array.size;
> @@ -1674,6 +1675,28 @@ int Grow_reshape(char *devname, int fd, int quiet,=
 char *backup_file,
>  				"2TB per device\n");
>  			size =3D min_csize;
>  		}
> +		if (st->ss->external) {
> +			if (sra->array.level =3D=3D 0) {
> +				rv =3D sysfs_set_str(sra, NULL, "level",
> +						   "raid5");
> +				if (!rv) {
> +					raid0_takeover =3D 1;
> +					/* get array parametes after takeover
> +					 * to chane one parameter at time only
> +					 */
> +					rv =3D ioctl(fd, GET_ARRAY_INFO, &array);
> +				}
> +			}
> +			/* make sure mdmon is
> +			 * aware of the new level */
> +			if (!mdmon_running(st->container_dev))
> +				start_mdmon(st->container_dev);
> +			ping_monitor(container);
> +			if (mdmon_running(st->container_dev) &&
> +					st->update_tail =3D=3D NULL)
> +				st->update_tail =3D &st->updates;
> +		}
> +
>  		array.size =3D size;
>  		if (array.size !=3D size) {
>  			/* got truncated to 32bit, write to
> @@ -1686,12 +1709,24 @@ int Grow_reshape(char *devname, int fd, int quiet=
, char *backup_file,
>  				rv =3D -1;
>  		} else {
>  			rv =3D ioctl(fd, SET_ARRAY_INFO, &array);
> +
>  			/* manage array size when it is managed externally
>  			 */
>  			if ((rv =3D=3D 0) && st->ss->external)
>  				rv =3D set_array_size(st, sra, sra->text_version);
>  		}
> =20
> +		if (raid0_takeover) {
> +			/* do not recync non-existing parity,
> +			 * we will drop it anyway
> +			 */
> +			sysfs_set_str(sra, NULL, "sync_action", "idle");

This is probably ineffective.  If the array thinks it needs to resync, then
just setting it to 'idle' will only stop in temporarily.  It will immediate=
ly
start syncing again.

However given that it is a RAID5 array which is degraded, it shouldn't try =
to
resync at all.

So:  does it still work if you remove this line?  If so, could you send a
patch to remove it?
If not - we should work out why.

Thanks,
NeilBrown


> +			/* go back to raid0, drop parity disk
> +			 */
> +			sysfs_set_str(sra, NULL, "level", "raid0");
> +			ioctl(fd, GET_ARRAY_INFO, &array);
> +		}
> +
>  		if (rv !=3D 0) {
>  			int err =3D errno;
> =20


--Sig_/XcLUs3uubgTf=5d4L4C9ok+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4za9Dnsnt1WYoG5AQKYKRAArkXKBUFHzXzoO2IgszvdmUNo1kUGVWjJ
cC4r2Z7QA4b7FwcHfRA4ScYo/i8yIjsXVYchSSkpsP4LcSpkKJg6KTMc92bHQhHW
je3zlvZqZZ1V6Ef/vnBbjBUzMIJy0Y2gJU9Zo0sCTfjuGxbX8W2Riae4Bb3zVcjR
PizRvAXV7rdiqVoaUSeT8YSNab1qeckUnBiEDcu7c5Ls88zHdz/eXGJwLP/o0qSd
U2H2AKBBCRxzD22bMNyrSmOMiJKtMuYm1vBdrysplCAU3bufEHjs7P+STTxN2Eln
CB0LO9xTmlfUhF4F/u99zKItrEOjxzhsahgjpQayb2erFIOH5S9wwtQu34j4t+cW
B/1u5JDZxO+DbXE70LtfLyqMTQeS7EseeofUrwMsd7wmr+m6SZVqpWl/KpzmUYNA
HvbYSKcJ6DFjBx7fGO9zpHxed0jEywpeY/1yuW144f2Dl0YPHEUkO1PJSos/8ge2
c5ZagQn1d6TBk+YUYywYTiOjaPPJ5q/rOa/X8QRcxmzCriffpI8yTKrJ7hXL42C9
md9bOPFayoV1dIWb53cm6JFYn/w0iJNciw3xfgKClMnL2b3lVxKU0q93tAdBQKp2
ycX55kwUwi8/7Ah+5vsmP8lp/5TtThNFfgNaAExxnmg6YC4a57F1EScoW90uRPF1
Gfeg0n4Ww8k=
=VvGo
-----END PGP SIGNATURE-----

--Sig_/XcLUs3uubgTf=5d4L4C9ok+--
