From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: retry load_and_parse_mpb if we suspect mdmon has
 made modifications
Date: Tue, 3 Jun 2014 09:10:58 +1000
Message-ID: <20140603091058.1393f8dc@notabene.brown>
References: <1401455913-28657-1-git-send-email-artur.paszkiewicz@intel.com>
	<20140602123656.2e52d529@notabene.brown>
	<538C7603.3050204@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DlefWqn4aucaLm7eJ4GM6z="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <538C7603.3050204@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org, "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
List-Id: linux-raid.ids

--Sig_/DlefWqn4aucaLm7eJ4GM6z=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 02 Jun 2014 15:02:59 +0200 Artur Paszkiewicz
<artur.paszkiewicz@intel.com> wrote:

> On 06/02/2014 04:36 AM, NeilBrown wrote:
> > On Fri, 30 May 2014 15:18:33 +0200 Artur Paszkiewicz
> > <artur.paszkiewicz@intel.com> wrote:
> >=20
> >> If the checksum verification fails in mdadm and mdmon is running, retry
> >> the load to get a consistent snapshot of the mpb.
> >>
> >> Based on db575f3b
> >>
> >> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> >> Reviewed-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> >> ---
> >>  super-intel.c | 17 +++++++++++++++++
> >>  1 file changed, 17 insertions(+)
> >>
> >> diff --git a/super-intel.c b/super-intel.c
> >> index f0a7ab5..037c018 100644
> >> --- a/super-intel.c
> >> +++ b/super-intel.c
> >> @@ -4422,6 +4422,7 @@ static int load_super_imsm(struct supertype *st,=
 int fd, char *devname)
> >>  {
> >>  	struct intel_super *super;
> >>  	int rv;
> >> +	int retry;
> >> =20
> >>  	if (test_partition(fd))
> >>  		/* IMSM not allowed on partitions */
> >> @@ -4444,6 +4445,22 @@ static int load_super_imsm(struct supertype *st=
, int fd, char *devname)
> >>  	}
> >>  	rv =3D load_and_parse_mpb(fd, super, devname, 0);
> >> =20
> >> +	/* retry the load if we might have raced against mdmon */
> >> +	if (rv =3D=3D 3) {
> >> +		struct mdstat_ent *mdstat =3D mdstat_by_component(fd2devnm(fd));
> >> +
> >> +		if (mdmon_running(mdstat->devnm) && getpid() !=3D mdmon_pid(mdstat-=
>devnm)) {
> >> +			for (retry =3D 0; retry < 3; retry++) {
> >> +				usleep(3000);
> >> +				rv =3D load_and_parse_mpb(fd, super, devname, 0);
> >> +				if (rv !=3D 3)
> >> +					break;
> >> +			}
> >> +		}
> >=20
> > The only thing you use from mdstat is devnm, and that is the thing you =
passed
> > to mdstat_by_component to get mdstat....
> >=20
> > Can you just do
> >    char *devnm =3D fd2devnm(fd);
> >    if (mdmon_running(devnm) && ......)
> >=20
> > ??
> >=20
> I can't do that because mdmon_running and mdmon_pid need a devnm of a
> container device, and the only thing we have here is the file descriptor
> of a component device. So I used mdstat_by_component to get the
> container devnm. Do you have an idea how to get that reliably without
> reading mdstat?
>=20
> I have overlooked that mdstat_by_component can return NULL here. I've
> added a check for this in the patch below.


Right, of course, yes.
I've applied your patch - and thanks for the updated version.

NeilBrown

--Sig_/DlefWqn4aucaLm7eJ4GM6z=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU40Egjnsnt1WYoG5AQL7mw/9FtGnwzZuPF2PK7PH7+1VNFJMNWFLO4XG
G8ZON6KoZ6wVOPi+tjiHnAEMqfyOcyXYuyFjcgXd67WEoKhfpvwymGVKXMRUx3m4
wo1VnqF33aatV1JkojVqgxMKRe9khxBE9SuQLiEvn0NJuuAoLh5ceKHJm9+h//FO
eAUmYwV07EMyy+NDUbVLwcHDbdjB0sRVwFUo89PpBez4a/CHt0zqQ9SfpmoLXaZb
s+IqeltWnOymJoMH2q7lIk3CwSwBjbO/y7LxRh+0o8LPqUFXw1OMqlTrT83sUiF/
0/cOH675K6pmATOhQLv3Yt0zT/oDkVWALUPLZnTzWC82L74nyS7BJAXWxuxVsrxA
bdccNEfrqPjO8b43azVskFauxxtBRy4yhiwe2IyOURr+23JRceIFYIrbTDp7jSrg
qP2c57Acu+Rg4LCLG/96b3P+zHZPSkgDPLyXiHH81xAdwlYW1wVq7g4kubOk8K2q
2y5IszaZ1CCYWlzkOUoT3IcMHqOXt/eQ82kG3adoljUEfBQ9d4u2ASXtCw4xAVyx
4qjM4EPJR8DCrIb9tHA+IOINudwVKWyHL0Fw3gE4pWhwJaJuEcKPccjFhDAM6TqM
+EjHnwHLDw+U19sPldCYJ6hx5/3d+NVyvhN6zy+KPhgKc71XRRGG102ks+o1G5Og
5Ab207x7zng=
=sKp/
-----END PGP SIGNATURE-----

--Sig_/DlefWqn4aucaLm7eJ4GM6z=--
