From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] tests/10ddf-fail-two-spares: new unit test
Date: Thu, 8 Aug 2013 09:37:43 +1000
Message-ID: <20130808093743.063b7a86@notabene.brown>
References: <1375907883-8202-1-git-send-email-mwilck@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//eS0dV2qrXyT2qo/Fl.U2Kv"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1375907883-8202-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: mwilck@arcor.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_//eS0dV2qrXyT2qo/Fl.U2Kv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed,  7 Aug 2013 22:38:03 +0200 mwilck@arcor.de wrote:

> This is one more unit test for failure/recovery, this time with
> double redundancy, which isn't covered by the other tests.
> ---
>  tests/10ddf-fail-two-spares |   85 +++++++++++++++++++++++++++++++++++++=
++++++
>  1 files changed, 85 insertions(+), 0 deletions(-)
>  create mode 100644 tests/10ddf-fail-two-spares
>=20
> diff --git a/tests/10ddf-fail-two-spares b/tests/10ddf-fail-two-spares
> new file mode 100644
> index 0000000..cc2cbb4
> --- /dev/null
> +++ b/tests/10ddf-fail-two-spares
> @@ -0,0 +1,85 @@
> +# Simulate two disks failing shorty after each other
> +. tests/env-ddf-template
> +tmp=3D$(mktemp /tmp/mdtest-XXXXXX)
> +
> +mdadm --zero-superblock $dev8 $dev9 $dev10 $dev11 $dev12 $dev13
> +mdadm -CR $container -e ddf -l container -n 6 \
> +      $dev8 $dev9 $dev10 $dev11 $dev12 $dev13
> +
> +#fast_sync
> +
> +mdadm -CR $member0 -l raid6 -n 4 $dev10 $dev11 $dev12 $dev13 -z 16384
> +#$dir/mdadm -CR $member0 -l raid6 -n 4 $dev10 $dev11 $dev12 $dev13  -z 1=
6384 \
> +#	    >/tmp/mdmon.txt 2>&1
> +mdadm -CR $member1 -l raid10 -n 4 $dev10 $dev11 $dev12 $dev13 -z 16384
> +
> +dd if=3D/dev/sda of=3D$member0 bs=3D1M
> +dd if=3D/dev/sda of=3D$member1 bs=3D1M skip=3D16
> +
> +check wait
> +
> +sum0=3D$(sha1sum $member0)
> +sum1=3D$(sha1sum $member1)
> +
> +mdadm --fail $member1 $dev11
> +sleep 1
> +mdadm --fail $member1 $dev12
> +
> +# We will have 4 resync procedures, 2 spares for 2 arrays.
> +mdadm --wait $member1 $member0
> +mdadm --wait $member1 $member0
> +
> +devs0=3D"$(get_raiddisks $member0)"
> +devs1=3D"$(get_raiddisks $member1)"
> +expected=3D"$dev10
> +$dev13
> +$dev8
> +$dev9"
> +
> +ret=3D0
> +if [ "$(echo "$devs0" | sort)" !=3D "$expected" \
> +   -o "$(echo "$devs1" | sort)" !=3D "$expected" ]; then
> +    echo ERROR: unexpected members
> +    echo $member0: $devs0
> +    echo $member1: $devs1
> +    ret=3D1
> +fi
> +
> +mdadm -E $dev10 >$tmp
> +if ! grep -q 'state\[0\] : Optimal, Consistent' $tmp; then
> +    echo ERROR: $member0 should be optimal in meta data
> +    ret=3D1
> +fi
> +if ! grep -q 'state\[1\] : Optimal, Consistent' $tmp; then
> +    echo ERROR: $member1 should be optimal in meta data
> +    ret=3D1
> +fi
> +if [ x"$(grep -c active/Online $tmp)" !=3D x4 ]; then
> +    echo ERROR: expected 4 online disks
> +    ret=3D1
> +fi
> +if [ x"$(grep -c "Offline, Failed" $tmp)" !=3D x2 ]; then
> +    echo ERROR: expected 2 failed disks
> +    ret=3D1
> +fi
> +
> +sum0a=3D$(sha1sum $member0)
> +sum1a=3D$(sha1sum $member1)
> +
> +if [ "$sum0" !=3D "$sum0a" -o "$sum1" !=3D "$sum1a" ]; then
> +   echo ERROR: checksum mismatch
> +   ret=3D1
> +fi
> +
> +if [ $ret -eq 1 ]; then
> +    cat /proc/mdstat
> +    cat $tmp
> +fi
> +
> +[ -f /tmp/mdmon.txt ] && {
> +  cat /tmp/mdmon.txt
> +  rm -f /tmp/mdmon.txt
> +}
> +rm -f $tmp
> +
> +[ $ret -eq 0 ]


Applied, thanks.

NeilBrown

--Sig_//eS0dV2qrXyT2qo/Fl.U2Kv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUgLaRznsnt1WYoG5AQJznw/+MrhmPvLL7dPZ1xmdbN1jRNo2+4UsL8zn
O3gNMWkYQZkKSsx50oFtu+RMLc2Nuzgt6qnoIC7ywa7vcaNvBFearuZ0/xwS+ey7
16EgM3q1vqDkvXp0o0qu5Mdcufzp3DUyqPMdvAY2yE1SDWH2txDSLTIcMfoFmuSh
aC73aJBOOVLwJAN3nvhszklwhc0Co0uDSt9CD7NOsZnVD8DMopksEJqc9VkNl0pi
UAl+WnepUrKbz43TbebCzfxgEyhlNrqxmKHKtxyJ9xmewJhSUyjmLICQ9UsDlfkA
AjTxcKPTaFY19FzZoIdDNZH1cGZ8sAjUXd7TiMnXqK2xlRly59+rSwlpK9GyGvy2
ZYDn8wk0vrr3q4eeB8ckwmLkeXUVe6Ab9I1II6ho4eRbHRw6+nRJDHXR4agrSkAs
5eC7yxoWfvKvW+IIFBD3KspIIE7EOOcVw7gBZoqLPSb1X3UvYK1C1W9yo4EztCqj
FsI40wFrWLBu7CdqEvQdmBcrMPiOCY8JD0XZam7xZ5ZxphSwS7xdtxMnTFuy0vAY
soPIIXjGVevupniLuh1+6D3KfCLA8DE4qB29SBNBWl1sb4n7LdQCr0bXliKw07ve
NEy3cCM9dxAMhEhHrSSv+v+93+OddDVs2fsuAOQSinMS5tXsgXyLak3hZK3i4b0Z
DCBqET/3RCQ=
=8n+z
-----END PGP SIGNATURE-----

--Sig_//eS0dV2qrXyT2qo/Fl.U2Kv--
