From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: mdadm freezes the system
Date: Tue, 8 Jun 2010 22:24:34 +0600
Message-ID: <20100608222434.3f0fb637@natsu>
References: <20100608145913.187a69ca@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Gm3GRtiww4m1Y4osy7yNPh1"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100608145913.187a69ca@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Gm3GRtiww4m1Y4osy7yNPh1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 8 Jun 2010 14:59:13 +0600
Roman Mamedov <roman@rm.pp.ru> wrote:

> Today, I have decided to convert a three-member RAID5 into a four-member
> RAID6. mdadm segfaulted(!) right after the --grow command, and dmesg had
> an error about md being unable to overwrite the /sys/.....stripe_cache_si=
ze
> file. (As I understand, this is already fixed in the latest kernel).
>=20
> The array then started rebuilding as 4-member RAID6 seemingly fine, but
> shortly after, the system locked up in the same manner as described above.

Interestingly though, when I attempted that reshape in 2.6.34 (complete with
the described segfault), the array _instantly_ became a 4-disk RAID6 with a
rebuilding spare, and the process was running at about 50 MB/sec. And I was
able to then remove that spare and shrink the array back to --level=3D5 and
--raid-devices=3D3, instantly too.

But when I rebooted to 2.6.35-rc2, the same --grow command I used initially
(--level=3D6 --raid-devices=3D4) while did not produce a segfault, failed, =
asking
for the "backup file" to be specified. And after I added the --backup-file
switch, it started a slow "Reshape" process, going at about 6 MBytes per
second. (And this too, caused a lockup in a way which I described earlier.)
Apparently, there is no way to abort this process now, so I paused it using
echo idle > /sys/.....sync_action, and copying data away from the array, to
recreate it from scratch.

So why the same RAID5 to RAID6 conversion started so differently in these t=
wo
cases? And is it even possible to reshape RAID5 to RAID6 while simultaneous=
ly
adding a disk, without overwriting all the other disks' contents (it surely
looked like this is what was happening in the first case)?

--=20
With respect,
Roman

--Sig_/Gm3GRtiww4m1Y4osy7yNPh1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwObsMACgkQTLKSvz+PZwguywCfT85ml2DDLWkPaDVcRBhvZ0Xu
f4kAoJBrJAVSrCKhmGH3/bt3jTJpNeDx
=YKBm
-----END PGP SIGNATURE-----

--Sig_/Gm3GRtiww4m1Y4osy7yNPh1--
