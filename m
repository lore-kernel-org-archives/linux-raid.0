From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/2] mdadm: Add takeover support for external meta
Date: Mon, 17 May 2010 03:32:24 -0700
Message-ID: <AANLkTilbdHWxx_oaKthLRrF7UaiUP91PdGWgueRokGta@mail.gmail.com>
References: <BE2BFE91933D1B4089447C64486040801B61C4B2@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BE2BFE91933D1B4089447C64486040801B61C4B2@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Trela, Maciej" <Maciej.Trela@intel.com>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids

Hi Maciej,


On Fri, Apr 30, 2010 at 6:47 AM, Trela, Maciej <Maciej.Trela@intel.com>=
 wrote:
>
> When performing takeover 0->10 or 10->0 mdmon should update the
> external metadata (due to disk slot changes).
> To achieve that mdadm, after changing the level in md,
> sends update_level to mdmon.
>
> Signed-off-by: Maciej Trela <maciej.trela@intel.com>
> ---
> =A0Grow.c =A0 =A0 =A0 =A0| =A0 38 ++++++++++++++++-
> =A0managemon.c =A0 | =A0 14 ++++++-
> =A0mdadm.h =A0 =A0 =A0 | =A0 =A01 +
> =A0mdstat.c =A0 =A0 =A0| =A0 24 ++++++++++
> =A0monitor.c =A0 =A0 | =A0 =A02 +-
> =A0super-intel.c | =A0133 +++++++++++++++++++++++++++++++++++++++++++=
+++++++++++++-
> =A06 files changed, 207 insertions(+), 5 deletions(-)
>
> diff --git a/Grow.c b/Grow.c
> index 6264996..17974fa 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -540,7 +540,7 @@ int Grow_reshape(char *devname, int fd, int quiet=
, char *backup_file,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0" =A0 =A0 =A0 Please u=
se a newer kernel\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 sra =3D sysfs_read(fd, 0, GET_LEVEL);
> + =A0 =A0 =A0 sra =3D sysfs_read(fd, 0, GET_VERSION | GET_LEVEL);
> =A0 =A0 =A0 =A0frozen =3D freeze_array(sra);
> =A0 =A0 =A0 =A0if (frozen < 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, Name ": %s is performi=
ng resync/recovery and cannot"
> @@ -690,6 +690,42 @@ int Grow_reshape(char *devname, int fd, int quie=
t, char *backup_file,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprint=
f(stderr, Name " level of %s changed to %s\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0devname, c);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0changed =3D 1;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 st =3D super_by_fd(fd);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (st->ss->external) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int dn =
=3D devname2devnum(sra->text_version + 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* if r=
aid0 was takeovered by any other
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
personality start mdmon */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((le=
vel > 0) && (orig.level =3D=3D 0)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 if (!mdmon_running(dn))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 start_mdmon(dn);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ping_monitor(devnum2devname(dn));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* info=
rm mdmon about raid level change
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* on=
ly for 0->10 and 10->0 transitions */

This seems wrong... we should be checking with the metadata handler
before allowing a level change to occur.  It's only luck that a
raid5-to-raid6 conversion is currently broken by an inability to set
stripe_cache_size.  So I would do the call to update_super() before
the level is changed to give the handler a chance to abort
orom/metadata incompatible level changes.

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((le=
vel =3D=3D 10) || (orig.level =3D=3D 10)) {

Unnecessary parentheses... here and a few other places.

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 struct mdinfo *new_info;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 struct mdinfo curr_info;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 new_info =3D sysfs_read(fd, 0, GET_LEVEL | GET_LAYOUT
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | GET_DISKS | GET_=
DEVS);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 int container_fd =3D open_dev_excl(dn);

Please no c++ style variable declarations mid-block.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
