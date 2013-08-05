From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: fix checking completion of RAID10 resync
Date: Mon, 5 Aug 2013 15:43:59 +1000
Message-ID: <20130805154359.7a85d2d0@notabene.brown>
References: <20130730135925.30168.91570.stgit@localhost.localdomain>
	<20130731092240.3230bf7f@notabene.brown>
	<D9FFE20C522965449E182ACE73889AEB1A537C60@IRSMSX105.ger.corp.intel.com>
	<D9FFE20C522965449E182ACE73889AEB1A5381ED@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zEpP_iyNh2HjKb5K4fBAmv3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D9FFE20C522965449E182ACE73889AEB1A5381ED@IRSMSX105.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Cc: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/zEpP_iyNh2HjKb5K4fBAmv3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 1 Aug 2013 12:32:50 +0000 "Dorau, Lukasz" <lukasz.dorau@intel.com>
wrote:

>=20
> There is another, more serious, problem.
> When we stop the array during initial resync (mdadm -Ss)=20
> and the function is_resync_complete() is entered for the last time,=20
> array->array.raid_disks already equals 0, because it is zero'ed by manage=
r:
>         a->info.array.raid_disks =3D mdstat->raid_disks;
> at managemon.c:454.
> As a result sync_size equals 0 and is_resync_complete() incorrectly retur=
ns 1 and resync finishes...
>=20
> It seems to be a race condition between monitor and manager - manager cha=
nges value of array.raid_disks too fast.

Yes - that is a serious problem.  Thanks for reporting it.
I think this is the correct fix.

Thanks,
NeilBrown


=46rom e49a8a80265ab2150c96b636450f5825bcd69d4a Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Mon, 5 Aug 2013 15:40:16 +1000
Subject: [PATCH] mdmon: don't use 'ghost' values from an inactive array.

It is possible for mdmon to see (in /proc/mdstat) and array
in 'inactive' state, "mdadm -S" has written "inactive" to
"array_state".

In this state values such as "raid_disk" are not meaningful
and so should be ignored by manage_member().

Reported-by: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/managemon.c b/managemon.c
index c245655..f40bbdb 100644
--- a/managemon.c
+++ b/managemon.c
@@ -450,9 +450,11 @@ static void manage_member(struct mdstat_ent *mdstat,
 		/* Raced with something */
 		return;
=20
-	// FIXME
-	a->info.array.raid_disks =3D mdstat->raid_disks;
-	// MORE
+	if (mdstat->active) {
+		// FIXME
+		a->info.array.raid_disks =3D mdstat->raid_disks;
+		// MORE
+	}
=20
 	if (sysfs_get_ll(&a->info, NULL, "component_size", &component_size) >=3D =
0)
 		a->info.component_size =3D component_size << 1;

--Sig_/zEpP_iyNh2HjKb5K4fBAmv3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUf87nznsnt1WYoG5AQLSNxAAwJvYG6kOTg7jM68F7jmzcoVYKRSWPKtX
YQ4rTEzkNEYD83UEpzDOjseOE8752agsgWgulsgauIxFre+zRXNJsbvywf5ABvQl
z15lF9kYUa48gDx6VqAmMsjIMM16v0raJwi4yWfNwEsUrXGKb5K9U0EmfRniUbgO
veJ7bpxYgSLkyN74A5tY36j9gnp7pjfORHGvYbdpgp+nBrDQJs4lPy3wCoNrshW2
+7LWhxd4j/NWblqdYzKwBVe+Szuzup0YFiVzfmancbBbJE7BvmLTyjcQhdByfNYo
lmfD/BvUP+PRlkqjlp1v892/gIhqCdU2f+UfyX4XeBGUoC06D+oQZ5FPZcYvCCpu
8NbwHoKHPCeghqEXflIPdBLe1Fsqa56FXeyWG0pw5CQfvDfPCbEqJV44TjVwB3+c
tR1Xkp0eSGK+5aKlTDcoShN0oi5z5PNEFAadg4KapadSi9xb0bgirCUuTwj3Nbvc
SOnsv8sz6hcdapCkYuPDMMrd+08vKNyzCIg0gfx8jNc+U99IPkSMFS0/PZZNaQJc
CtYRYsoC+d/Efr5BL26To8QAkdKofn59hLLu3fNY3B/3YICSxEjkgp7+7hS1sk1/
mpsdu3d8plgOLEzGj4dbsxBj/R5zmJ2Pav+vqgmHCga6TCUu1jMD2fyqSMIgYdNF
VnMCf7X34N0=
=DkNn
-----END PGP SIGNATURE-----

--Sig_/zEpP_iyNh2HjKb5K4fBAmv3--
