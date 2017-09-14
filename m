From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 0/4] RFC: attempt to remove md deadlocks with metadata without
Date: Thu, 14 Sep 2017 15:32:02 +1000
Message-ID: <871sn9alrh.fsf@notabene.neil.brown.name>
References: <150518076229.32691.13542756562323866921.stgit@noble> <1403889957.10216459.1505268710452.JavaMail.zimbra@redhat.com> <1025458651.10368123.1505315351335.JavaMail.zimbra@redhat.com> <87o9qe9p3j.fsf@notabene.neil.brown.name> <446747392.10694917.1505364915884.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <446747392.10694917.1505364915884.JavaMail.zimbra@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 14 2017, Xiao Ni wrote:

> ----- Original Message -----
>> From: "NeilBrown" <neilb@suse.com>
>> To: "Xiao Ni" <xni@redhat.com>
>> Cc: linux-raid@vger.kernel.org
>> Sent: Thursday, September 14, 2017 7:05:20 AM
>> Subject: Re: [PATCH 0/4] RFC: attempt to remove md deadlocks with metada=
ta without
>>=20
>> On Wed, Sep 13 2017, Xiao Ni wrote:
>> >
>> > Hi Neil
>> >
>> > Sorry for the bad news. The test is still running and it's stuck again.
>>=20
>> Any details?  Anything at all?  Just a little hint maybe?
>>=20
>> Just saying "it's stuck again" is very nearly useless.
>>=20
> Hi Neil
>
> It doesn't show any useful information in /var/log/messages
>
> echo file raid5.c +p > /sys/kernel/debug/dynamic_debug/control
> There aren't any messages too.=20
>
> It looks like another problem.=20
>
> [root@dell-pr1700-02 ~]# ps auxf | grep D
> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> root      8381  0.0  0.0      0     0 ?        D    Sep13   0:00  \_ [kwo=
rker/u8:1]
> root      8966  0.0  0.0      0     0 ?        D    Sep13   0:00  \_ [jbd=
2/md0-8]
> root       824  0.0  0.1 216856  8492 ?        Ss   Sep03   0:06 /usr/bin=
/abrt-watch-log -F BUG: WARNING: at WARNING: CPU: INFO: possible recursive =
locking detected ernel BUG at list_del corruption list_add corruption do_IR=
Q: stack overflow: ear stack overflow (cur: eneral protection fault nable t=
o handle kernel ouble fault: RTNL: assertion failed eek! page_mapcount(page=
) went negative! adness at NETDEV WATCHDOG ysctl table check failed : nobod=
y cared IRQ handler type mismatch Machine Check Exception: Machine check ev=
ents logged divide error: bounds: coprocessor segment overrun: invalid TSS:=
 segment not present: invalid opcode: alignment check: stack segment: fpu e=
xception: simd exception: iret exception: /var/log/messages -- /usr/bin/abr=
t-dump-oops -xtD
> root       836  0.0  0.0 195052  3200 ?        Ssl  Sep03   0:00 /usr/sbi=
n/gssproxy -D
> root      1225  0.0  0.0 106008  7436 ?        Ss   Sep03   0:00 /usr/sbi=
n/sshd -D
> root     12411  0.0  0.0 112672  2264 pts/0    S+   00:50   0:00         =
 \_ grep --color=3Dauto D
> root      8987  0.0  0.0 109000  2728 pts/2    D+   Sep13   0:04         =
 \_ dd if=3D/dev/urandom of=3D/mnt/md_test/testfile bs=3D1M count=3D1000
> root      8983  0.0  0.0   7116  2080 ?        Ds   Sep13   0:00 /usr/sbi=
n/mdadm --grow --continue /dev/md0
>
> [root@dell-pr1700-02 ~]# cat /proc/mdstat=20
> Personalities : [raid6] [raid5] [raid4]=20
> md0 : active raid5 loop6[7] loop4[6] loop5[5](S) loop3[3] loop2[2] loop1[=
1] loop0[0]
>       2039808 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6] [UU=
UUUU]
>       [>....................]  reshape =3D  0.0% (1/509952) finish=3D1059=
.5min speed=3D7K/sec
>=20=20=20=20=20=20=20
> unused devices: <none>
>
>
> It looks like the reshape doesn't start. This time I didn't add the codes=
 to check
> the information of mddev->suspended and active_stripes. I just added the =
patches=20
> to source codes. Do you have other suggestions to check more things?
>
> Best Regards
> Xiao

What do
 cat /proc/8987/stack
 cat /proc/8983/stack
 cat /proc/8966/stack
 cat /proc/8381/stack

show??

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlm6FFMACgkQOeye3VZi
gbn6tg//T5cwkhvmuBmId41TPpAZG/azJhKVsENfAP7t/5J3JuQyAhPItFUIWjDp
PlSiKLS+B+ULCa4LsVlbbxY2SrbvtjgU2aEro7ehe2gEpQDFYsTyxoMA1yEKN7PY
IouQNkJX6ZczLerwGFPUi85cfyfneJCiJJ5hceGDKaN57nJSYv6wt8YyCRPJN0gu
6Nv7VgJGSCOxs0ZBLSd+YYN53KB5sszDbVL3di94WV11wwk0msAWCVdU9AUvJIDD
Erw1irW3XpESXm1ITeEQLeL9RtX3ZRteeirzsIiUbHpmSOzObJjGvfLmE3tv8LO6
ikNSzKM0Z61UG2t5bEP1/Kw+v2igC8CcUE3p7h9HF9MGoXCs2pNWTEcVtMBona5B
ZOMuOd8x7+ibKntJD9t2u8huXDwdYpltKZq/ZTshIN/iaVzxaL6w0qpzlXRuHDoW
X3WngN/mxO31pnRfrbpyYX3IQwRoJFbInbovp25bzxXG0L9ZucWhg53muy5OT0jn
Nyz5n0UZISRdj92NOpAmuQvkDMed4n85humdhNZ75IWaC+IwpqWlUV3QcqjXSEvR
bc7a7LZlD9BPCp4lNVQg/VIp6DGbQ027bdgQRRe0TiQhwGS6RS5gJ9ZIW8QVFaFi
drDiafpibpRF4e7hDkWc0pkd4xLe2lOd34U+bzCqpnZsN4ES+l0=
=aFGw
-----END PGP SIGNATURE-----
--=-=-=--
