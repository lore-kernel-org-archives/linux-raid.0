From: NeilBrown <neilb@suse.com>
Subject: Re: [mdadm PATCH] mdopen: call "modprobe md_mod" if it might be needed.
Date: Tue, 26 Sep 2017 09:50:06 +1000
Message-ID: <87poae72z5.fsf@notabene.neil.brown.name>
References: <87y3p372b0.fsf@notabene.neil.brown.name> <22985.8214.251962.72926@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22985.8214.251962.72926@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 25 2017, John Stoffel wrote:

>>>>>> "NeilBrown" =3D=3D NeilBrown  <neilb@suse.com> writes:
>
> NeilBrown> Creating an array by opening a block-device with major number =
of 9
> NeilBrown> will transparently load the md module if needed.
> NeilBrown> Creating an array by opening
> NeilBrown>    /sys/module/md_mod/parameters/new_array
> NeilBrown> and writing to it won't, it will just fail if md_mod isn't loa=
ded.
>
> NeilBrown> So when opening that file fails with ENOENT, run "modprobe md_=
mod" and
> NeilBrown> try again.
>
> NeilBrown> This fixes a bug whereby if you have "CREATE names=3Dyes" in m=
dadm.conf,
> NeilBrown> and the md modules isn't loaded, then creating or assembling an
> NeilBrown> array will not honor the "names=3Dyes" configuration.
>
> NeilBrown> Signed-off-by: NeilBrown <neilb@suse.com>
> NeilBrown> ---
> NeilBrown>  mdopen.c | 4 ++++
> NeilBrown>  1 file changed, 4 insertions(+)
>
> NeilBrown> diff --git a/mdopen.c b/mdopen.c
> NeilBrown> index 3c0052f2db23..dcdc6f23e6c1 100644
> NeilBrown> --- a/mdopen.c
> NeilBrown> +++ b/mdopen.c
> NeilBrown> @@ -312,6 +312,10 @@ int create_mddev(char *dev, char *name, i=
nt autof, int trustworthy,
> NeilBrown>  		if (block_udev)
> NeilBrown>  			udev_block(devnm);
> NeilBrown>  		fd =3D open("/sys/module/md_mod/parameters/new_array", O_WR=
ONLY);
> NeilBrown> +		if (fd < 0 && errno =3D=3D ENOENT) {
> NeilBrown> +			system("modprobe md_mod");
> NeilBrown> +			fd =3D open("/sys/module/md_mod/parameters/new_array", O_W=
RONLY);
> NeilBrown> +		}
> NeilBrown>  		if (fd >=3D 0) {
> NeilBrown>  			n =3D write(fd, devnm, strlen(devnm));
> NeilBrown>  			close(fd);
> NeilBrown> --=20
> NeilBrown> 2.14.0.rc0.dirty
>
> I haven't looked, but shouldn't the path for modprobe be hardcoded
> here to /sbin/modprobe?  Or the PATH sanitized so that random people
> can't put something into the system PATH and cause problems?=20

That issue briefly crossed my mind as I wrote the code (is it OK to use
system()? should I use /sbin/modprobe or just modprobe?) but as mdadm is
not set-uid and cannot be run in an environment created by a
non-privileged user, there is no security risk.
Certainly a careless sysadmin might set path wrongs, but the most likely
wrong outcome is that modprobe won't be found, and there is very little
cost to that.

So thanks for asking, but I don't think there is any need for any extra
care, in which case "simplest is best".

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnJli8ACgkQOeye3VZi
gbkwbBAAm5+r2RkK5L2pNdKN0YyknNfUWkus+3T3xv6oKDKvN4FDP5oBrKXzPdJe
s25TTs13uDlwUZ/mS5LMgFXAqsCSFRmgi/IfKK46MoktqulPanxQ5S6sMoSUgOJb
wPNrsfjbCk/1v5Y0SfC51wtDgxBFmOQMqj64LTqi/IJl9LRifVxdjr85oN50z/bw
bIZWk2i1bqyeWEVmoLlEB6gj8BZXmVTYKpaRYurodU19Xm1FphflhxsD+BSmFA9L
vSvlUMeQCuZ2vrBT+297kmy09nwAOIG9FviT0q8HMoQu0BjZAiB6SnoG7GnBcbGM
SryPh1qiN1bDLIkKJVPLTSfPpHDUWb+3gfV91gYZ6Hk2oskhnciy2jVckq8kUKse
Xw/E13E5MefxgOjty6b+bwM88M+3x3WW/OSeURIzhfUcUA5c9CxGketqfQ0+J8QZ
y8QpkPXzXnx/5vYbsT070ORFpaXUtEuOX4AVnm06jfXBbWooscrV1WP8vvPZnXKX
prncnLVCUAjSmcPHSUTXxS7qS9XdEQUS/asNquxYqDm7rtyrz2I7Mp1qfz6JRWY8
XIh9Pg7l89A2u7cCx09950ZuKZHxEahpeftWO1K5zTDOd2FkK9gReDCU1tCR/8cC
LyKDM06pD0ARs1jPlvayUYWmiaN10EV0c1+4J3mF8YngrtM/Gzw=
=MbBu
-----END PGP SIGNATURE-----
--=-=-=--
