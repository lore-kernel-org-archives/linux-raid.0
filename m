From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] mdmon@.service: Change type of process start-up to
 'forking'.
Date: Tue, 11 Mar 2014 14:44:30 +1100
Message-ID: <20140311144430.19f87195@notabene.brown>
References: <20140306145144.9690.29220.stgit@gklab-154-222.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dVE._c=ZAuZjORo_kg8kM7R"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140306145144.9690.29220.stgit@gklab-154-222.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

--Sig_/dVE._c=ZAuZjORo_kg8kM7R
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 06 Mar 2014 15:51:44 +0100 Pawel Baldysiak
<pawel.baldysiak@intel.com> wrote:

> Mdadm does not wait enough time when mdmon is started by systemd.
> It causes various problems with behaviour of a RAID volume with external =
metadata.
> For example: mdmon does not update a value of checkpoint during migration
> and second RAID5 volume is read-only after reboot done during
> container reshape (both problems occur with IMSM matadata).
> If a type of process start-up is changed to 'forking', systemctl will
> wait until mdmon (parent) process exits after calling fork.
> This way mdmon will always be fully initialized after start_mdmon
> and these problems will not occur.
> In this case it is recommended to add a path to PIDFile, so that systemd
> does not have to guess a PID of the mdmon process.
>=20
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> Reviewed-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  systemd/mdmon@.service |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/systemd/mdmon@.service b/systemd/mdmon@.service
> index 5520cd0..304b26e 100644
> --- a/systemd/mdmon@.service
> +++ b/systemd/mdmon@.service
> @@ -14,5 +14,7 @@ Before=3Dinitrd-switch-root.target
>  # mdmon should never complain due to lack of a platform,
>  # that is mdadm's job if at all.
>  Environment=3DIMSM_NO_PLATFORM=3D1
> -ExecStart=3D/sbin/mdmon --foreground %I
> +ExecStart=3D/sbin/mdmon %I
> +Type=3Dforking
> +PIDFile=3D/run/mdadm/%I.pid
>  KillMode=3Dnone
>=20

applied, thanks.

I wonder if we should try to make it use MDMON_DIR instead of /run/mdadm ...
though anyone who uses systemd almost certainly uses /run so it probably
doesn't matter.

Thanks,
NeilBrown

--Sig_/dVE._c=ZAuZjORo_kg8kM7R
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUx6Gnjnsnt1WYoG5AQIfmQ//a7fN6Agb4u8RZ2zu/fEgITbD++AlqTkn
bFGbm4xKjFRm7QH9jUTGiO6l546DYhYQbsWv2UyH68Q2Gyiy2dBzR3dOXmGiB2eK
q0tUfqTO3iiDImRzDpfT9m4KrkJY4PJkRkJh58DmCegxKM1Po6/r0Um43jTHjAxL
vc+2zRT2LBRnVFeNlblDvWZ1GgMkRaQFPWua23/tSF5vbiawjZ83XAL7yOHsnfu+
txMZlTI8TDFi5L57NilwQDM61/ITCtFOGvdfBkx0xF2+vccWSqy13q7Ct/NlisoM
AaQBniFoewktwjcu/Wb9Y9zc9/WN2F+6VHENyB5xsCiKbGy4FTcd/ZivKkIQ6ZE5
NL9yZ9aGMldUvGhqaCvBnzbURAG0+1cQ3eUuaFxxIMuwGlnXLQ5InO5PCDelrEwx
vra/BA5OG5uxYAe/bl3qH/98MHWb5NOL0MtHgmQQvz5qc/P2I/QbAgXdeWaMtyaY
jTS0ovu3MeDZZJJwgjw0NMZ4ummuwpRKIfEYHO+oDdEjvhPXBVrQSPS8KoxWSTCJ
R1mnXS9WHdpxBADH0sj9p2ObMUxZPVA51o4XsSmNQcFfgLR7zBcSKOu0B1Xri2cc
rrjspMJJlmdrzCRBGDJVU2z08czJEpcAVRXCGgocG0X51oznxB5AUZArYcwXkBG5
naiTgzlBahE=
=Vq82
-----END PGP SIGNATURE-----

--Sig_/dVE._c=ZAuZjORo_kg8kM7R--
