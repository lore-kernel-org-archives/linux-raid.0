From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Forbid merging with partially assembled IMSM array
Date: Wed, 25 Jun 2014 14:15:51 +1000
Message-ID: <20140625141551.04c262a4@notabene.brown>
References: <84A53BEA6EAC69439B7E311E9B17A76F07918BDA@IRSMSX105.ger.corp.intel.com>
	<20140602121955.10a72b32@notabene.brown>
	<84A53BEA6EAC69439B7E311E9B17A76F0791C0DD@IRSMSX105.ger.corp.intel.com>
	<20140604123046.02e224d6@notabene.brown>
	<84A53BEA6EAC69439B7E311E9B17A76F0791D2DE@IRSMSX105.ger.corp.intel.com>
	<20140605162730.33e36f25@notabene.brown>
	<84A53BEA6EAC69439B7E311E9B17A76F0792870C@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NHmEgIB2Gdg4xSKkreSOEb9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84A53BEA6EAC69439B7E311E9B17A76F0792870C@IRSMSX105.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

--Sig_/NHmEgIB2Gdg4xSKkreSOEb9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 13 Jun 2014 09:48:16 +0000 "Baldysiak, Pawel"
<pawel.baldysiak@intel.com> wrote:

> >On Thursday, June 05, 2014 8:28 AM NeilBrown [neilb@suse.de] wrote:
> > To: Baldysiak, Pawel
> > Cc: linux-raid@vger.kernel.org; Paszkiewicz, Artur
> > Subject: Re: [PATCH] Forbid merging with partially assembled IMSM=20
> >array
> >=20
> > On Wed, 4 Jun 2014 09:25:47 +0000 "Baldysiak, Pawel"
> > <pawel.baldysiak@intel.com> wrote:
> >=20
> >=20
> > > Hi Neil
> > >
> > > There are several cases where not forbidding this operation can=20
> > > cause
> > problems.
> > > For example, if user will create IMSM array at one platform, then=20
> > > stop it, detach devices, and hotplug them to another platform (mixed=
=20
> > > between two different controllers) - everything will be looking good=
=20
> > > (array
> > will be incrementally assembled without any errors) until reboot.
> > > After that, user will be confused why array is degraded/failed and=20
> > > will be at
> > risk of losing data.
> > > Also, creation of IMSM array under different controllers is=20
> > > forbidden, so
> > there is no point in allowing that it in assemble process.
> > >
> > > If you really think this is no justification - I will prepare a=20
> > > patch that will print warning, but in my opinion this operation=20
> > > should be allowed
> > only with "--force"...
> > >
> >=20
> > I came across a situation once where someone was trying to crash-dump=20
> > onto an IMSM array.  'crashdump' does some sort of kexec thing and=20
> > runs a very minimal kernel/installation  which just does crash dumps.
> >=20
> > It didn't work because mdadm couldn't find the OpROM in that context=20
> > and so refused the assemble the array.
> > I really don't like that sort of thing happening.
> > If the OpROM is going to destroy your data (or whatever it does) when=20
> > you plug different devices into different controllers, then that is=20
> > the OpROM's problem, not mine.  I just want to make sure people can=20
> > get at their data in as many situations as possible.
> >=20
> >=20
> > A warning is probably OK, though I wonder if anyone would ever see it.
> > However the code would need improvement.
> > Doing a strcmp for "imsm" is not acceptable.
> >=20
> > I'm not even sure I understand what they rest of the code is trying to =
do.
> > It doesn't seem to make reference to separate OpROMs....
> >=20
> > NeilBrown
> >=20
>=20
> Hi Neil,
>=20
> Here is the patch that adds warning message.
>=20
> Thanks
> Pawel Baldysiak
>=20
> >From a0270724eb42e24a74508f5b0ec35afc64f17cf7 Mon Sep 17 00:00:00 2001
> From: Pawel Baldysiak <pawel.baldysiak@intel.com>
> Date: Fri, 13 Jun 2014 10:55:19 +0200
> Subject: [PATCH 1/1] IMSM: Add warning message when assemble spanned cont=
ainer
>=20
> Due to several changes in code assemble with disks
> spanned between different controllers can be obtained
> in some cases. After IMSM container will be assembled, check HBA of
> disks, and print proper warning if mismatch is detected.
>=20
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  Assemble.c       | 28 ++++++++++++++++++++++++++++
>  platform-intel.h |  1 +
>  2 files changed, 29 insertions(+)
>=20
> diff --git a/Assemble.c b/Assemble.c
> index 63e09ac..3542b16 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -23,6 +23,7 @@
>   */
> =20
>  #include	"mdadm.h"
> +#include	"platform-intel.h"
>  #include	<ctype.h>
> =20
>  static int name_matches(char *found, char *required, char *homehost)
> @@ -1001,6 +1002,33 @@ static int start_array(int mdfd,
>  					content->array.raid_disks);
>  			fprintf(stderr, "\n");
>  		}
> +		if (st->ss =3D=3D &super_imsm && !check_env("IMSM_NO_PLATFORM")) {
> +			struct sys_dev *idev;
> +			char *hba_path =3D NULL;
> +			char *dev_path =3D devt_to_devpath(makedev(devices->i.disk.major,
> +					devices->i.disk.minor));
> +
> +			for (idev =3D find_intel_devices(); idev; idev =3D idev->next) {
> +				if (strstr(dev_path, idev->path)) {
> +					hba_path =3D idev->path;
> +					break;
> +				}
> +			}
> +			free(dev_path);
> +
> +			if (hba_path) {
> +				for (i =3D 1; (unsigned)i < okcnt+sparecnt; i++) {
> +					if (!devt_attached_to_hba(makedev(devices[i].i.disk.major,
> +							devices[i].i.disk.minor), hba_path)) {
> +						pr_err("WARNING - IMSM container assembled with disks "
> +							"under different HBAs!\n"
> +							"       This operation is not supported "
> +							"and can lead to data loss.\n");
> +						break;
> +					}
> +				}
> +			}
> +		}
>  		st->ss->free_super(st);
>  		sysfs_uevent(content, "change");
>  		if (err_ok && okcnt < (unsigned)content->array.raid_disks)
> diff --git a/platform-intel.h b/platform-intel.h
> index bcd84b7..999a601 100644
> --- a/platform-intel.h
> +++ b/platform-intel.h
> @@ -203,6 +203,7 @@ struct sys_dev *find_driver_devices(const char *bus, =
const char *driver);
>  struct sys_dev *find_intel_devices(void);
>  const struct imsm_orom *find_imsm_capability(enum sys_dev_type hba_id);
>  const struct imsm_orom *find_imsm_orom(void);
> +int devt_attached_to_hba(dev_t dev, const char *hba_path);
>  int disk_attached_to_hba(int fd, const char *hba_path);
>  char *devt_to_devpath(dev_t dev);
>  int path_attached_to_hba(const char *disk_path, const char *hba_path);


Could you please:

 1/ move the code to super-intel.c and add a new superswitch method called
  "validate_array" or something like that.
  You can't pass the 'devices' array in as only Assemble.c knows about that,
  so filling the ->links in the mdinfo structure and pass the devices in as=
 a
  list.

 2/ Don't use a signed variable when you really want an unsigned variable!
    ('i' in the above code)
 3/ Don't break strings to fit 80 columns.  I know we have done that in the
    past, but I think it is more trouble than it is worth.  Do break the
    string after "\n", but not elsewhere.

Then I'll apply it.

Thanks,
NeilBrown

--Sig_/NHmEgIB2Gdg4xSKkreSOEb9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU6pM9znsnt1WYoG5AQI+Fw//dxMrvMRYCmKzHDI9kfzaF88FydQMj9c+
vi3qPY+vCUaxZlJqtQDrOkHzDlNJNS4ws1Az7X0XteNSyq9eIJ+q1WuAlIxJGP/r
pyOP8Xb0jdOpqBYluF5sDw121Ver0DXQfFyxeI5K38+FEdjOg9RIwC6DGUN7MoF9
EnV2Itk//A7Y3Jg2vDs1G7kRNCfMCw1O7yA1dFHqvhnC4OeEsBqKxOG9EeBMrHtY
zhmeSPRN80dY3GcbhXidNW8uOIyCtR70jNyNKUWEEqZmONvuJavxJiXhH6dQvrhc
h7CJPUG4FRs/FFEW9jQv2LwPW7ZFZgglCcX0NS0P5+RHeaL6THfjPwcPfjKmR6qM
y9uU1zKPa0Rw898QhSIJFLf9/LwVCZOH3GcGWc3gXgeAFZLP4AUlyPTwcu72Vzz8
StcZ9pjx+CCoYJuk6zcFCFL95puJ3lJF9mb02fGxKTrntwKBxtXY5Rt4iYpnv233
lnJF3Aek9aOtLxH27Gt12DQrwNZvQDuKgFTDMcVlMW+30JruDR8soljVK7tAHzmA
zKtjhy/pds/JVrwW8fKfjVbsmoU+eVcq8V8/DZQVKeXHjwXZlgJGJTvkqFaSat7d
15iMkgWgxafJB8A86tovL67rAlUv08+9jDGxHkj7k9Zx8m0/mWWYT+SuupQD8RZM
OTh1wOJ+dzE=
=9B5I
-----END PGP SIGNATURE-----

--Sig_/NHmEgIB2Gdg4xSKkreSOEb9--
