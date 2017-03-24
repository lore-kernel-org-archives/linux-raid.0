From: NeilBrown <neilb@suse.com>
Subject: Re: constant array_state active after specific jobs
Date: Fri, 24 Mar 2017 16:25:35 +1100
Message-ID: <8737e39rg0.fsf@notabene.neil.brown.name>
References: <20170323104643.6cca7986@hal9.pdi.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170323104643.6cca7986@hal9.pdi.lan>
Sender: linux-raid-owner@vger.kernel.org
To: pdi <pdi@otenet.gr>, linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 23 2017, pdi wrote:

> Greetings all,
>
> The problem in a nutshell is that an array is clean after boot, until
> some specific jobs switch it to active where it remains until reboot.
>
> A similar problem was discussed, and solved, in=20
> https://www.spinics.net/lists/raid/msg46450.html. However, AFAICT,
> it is not the same issue.
>
> I would be grateful for any insights as to why this happens and/or how
> to prevent it.
>
> The relevant info follows, please let me know if anything further might
> help.
>
> Many thanks in advance.
>
> - uname -a
>   Linux hostname 4.4.38 #1 SMP Sun Dec 11 16:03:41 CST 2016 x86_64
>   Intel(R) Core(TM)2 Duo CPU E8400 @ 3.00GHz GenuineIntel GNU/Linux
> - mdadm -V
>   mdadm - v3.3.4 - 3rd August 2015
> - Desktop drives without sct/erc,
>   with timeout mismatch correction as per
>   https://raid.wiki.kernel.org/index.php/Timeout_Mismatch
> - /dev/md9 is a raid10 array, 4 devices, far=3D2,
>   with various dirs used as samba and nfs shares
> - The array is in *constant* array_state active
> - mdadm -D /dev/md9 | grep 'State :'
>   State : active
> - cat /sys/block/md9/md/array_state
>   active
> - watch -d 'grep md9 /proc/diskstats'
>   remain unchanged
> - uptime
>   load average: 0.00, 0.00, 0.00
> - cat /sys/block/md9/md/safe_mode_delay
>   0.201
> - echo 0.1 > /sys/block/md9/md/safe_mode_delay
>   array_state remains active
> - echo clean > /sys/block/md9/md/array_state
>   echo: write error: Device or resource busy
> - reboot (with or without prior check)
>   array_state clean
> - After reboot, array remains clean until some specific
>   jobs put it in constant active state. Such jobs so far
>   identified:
>   - echo check > /sys/block/md9/md/sync_action
>   - run an rsnapshot job
>   - start a qemu/kvm vm
> - Other jobs, like text/doc editing, multimedia playback,
>   etc retain array_state clean

This bug was introduced by
Commit: 20d0189b1012 ("block: Introduce new bio_split()")
in 3.14, and fixed by
Commit: 9b622e2bbcf0 ("raid10: increment write counter after bio is split")
in 4.8.

Maybe the latter patch should be sent to -stable ??

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljUrdAACgkQOeye3VZi
gbkX1BAAo5+PaK2bW54/qXg1Ve3Z8ep5JYG9D4J2QoFJCO9gRP94mOGk9fzi8SDs
4HuOeqgT+pt2l+pgyCBso3mQgvkxfMtI6i1zHjTvB7xbgnP7bzyDG8SrMuIcMWzS
ci4ZYcGcDrzggd2KE2/tYpDnf3mpOfxMB4/pYOjjgNLYDN8/2OKfeK6TbdjsA5fr
+XAzvF52buJK4pBcCiyF4nj3DWIqwWOFayYPk7QK1rBP4PYSTpvt2TcLidNMKgWx
XqmqnF4P7oBVAyU1dQGs4d9zIN1NAn1m73F4O4/GsqLetVny+Vqx8t3uhlJyYZeW
BsFb/QOBVhr4QHWx7c+S0goBc1BHs2da4viW65oqgoVA8JToTRh4+Bw68WU63ncS
1twZplO41ItzYofqBdHo9bnEYXlRd1uuUZWfhuO4M3deyvEGlxm433kFs9Ne0bjO
yj+jk7Hl+oVu485yhixyZTxwN1Ja0o0Eiafi1juP4btPeFjfGgo3uiC1lLvTUT0T
2ok8Gac+DYSQamJnB1PH3GU0QBxmcgWfF4OwPw5B3t3Wq8ihwCnmGbx4YZzW6XSA
GNpQcGcsAdgsgufXWMdZ3oSPr9kOddWT9+YZqthpvfdPqlp5cmLjYmBMS2F65SgK
A5ZebwcZsmGG8Q7WfiZQyWW1rpzK2rGXJMrHYQJBHNCJ9RPcwVs=
=BMDa
-----END PGP SIGNATURE-----
--=-=-=--
