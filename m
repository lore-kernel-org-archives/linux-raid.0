From: NeilBrown <neilb@suse.com>
Subject: Re: Errorneous detection of degraded array
Date: Mon, 30 Jan 2017 12:53:37 +1100
Message-ID: <87vasxs47y.fsf@notabene.neil.brown.name>
References: <96A26C8C6786C341B83BC4F2BC5419E4795DE9A6@SRF-EXCH1.corp.sunrisefutures.com>
 <b842c2ce-7d32-a392-e9d9-9f330fa6a7cf@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1311669244=="
Return-path: <systemd-devel-bounces@lists.freedesktop.org>
In-Reply-To: <b842c2ce-7d32-a392-e9d9-9f330fa6a7cf@gmail.com>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/systemd-devel>,
 <mailto:systemd-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/systemd-devel>
List-Post: <mailto:systemd-devel@lists.freedesktop.org>
List-Help: <mailto:systemd-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/systemd-devel>,
 <mailto:systemd-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: systemd-devel-bounces@lists.freedesktop.org
Sender: "systemd-devel" <systemd-devel-bounces@lists.freedesktop.org>
To: Andrei Borzenkov <arvidjaar@gmail.com>, Luke Pyzowski <Luke@sunrisefutures.com>, "'systemd-devel@lists.freedesktop.org'" <systemd-devel@lists.freedesktop.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--===============1311669244==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 27 2017, Andrei Borzenkov wrote:

> 26.01.2017 21:02, Luke Pyzowski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>> Hello,
>> I have a large RAID6 device with 24 local drives on CentOS7.3. Randomly =
(around 50% of the time) systemd will unmount my RAID device thinking it is=
 degraded after the mdadm-last-resort@.timer expires, however the device is=
 working normally by all accounts, and I can immediately mount it manually =
upon boot completion. In the logs below /share is the RAID device. I can in=
crease the timer in /usr/lib/systemd/system/mdadm-last-resort@.timer from 3=
0 to 60 seconds, but this problem can randomly still occur.
>>=20
>> systemd[1]: Created slice system-mdadm\x2dlast\x2dresort.slice.
>> systemd[1]: Starting system-mdadm\x2dlast\x2dresort.slice.
>> systemd[1]: Starting Activate md array even though degraded...
>> systemd[1]: Stopped target Local File Systems.
>> systemd[1]: Stopping Local File Systems.
>> systemd[1]: Unmounting /share...
>> systemd[1]: Stopped (with error) /dev/md0.

This line perplexes me.

The last-resort.service (and .timer) files have a Conflict=3D directive
against sys-devices-virtual-block-md$DEV.device=20
Normally a Conflicts=3D directive means that if this service starts, that
one is stopped, and if that one starts, this is stopped.
However .device units cannot be stopped:

$ systemctl show sys-devices-virtual-block-md0.device | grep Can
CanStart=3Dno
CanStop=3Dno
CanReload=3Dno
CanIsolate=3Dno

so presumable the attempt to stop the device fails, so the Conflict=3D
dependency cannot be met, so the last-resort service (or timer) doesn't
get started.
At least, that is what I see happening in my tests.

But your log doesn't mention sys-devices-virtual-block-md0, it
mentions /dev/md0.
How does systemd know about /dev/md0, or the connection it has with
sys-devices-virtual-block-md0 ??

Does
  systemctl  list-dependencies  sys-devices-virtual-block-md0.device

report anything interesting?  I get

sys-devices-virtual-block-md0.device
=E2=97=8F =E2=94=94=E2=94=80mdmonitor.service

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAliOnKEACgkQOeye3VZi
gblacQ/5AZAcJe4Y7/b55tQW+gBF5x7Au9cl1B7LNv046QscygtYidzD8lwDiwWs
sPh2sWjX2Kc3K9Cb6D99jeQEPMMmigc3GPYa//eApsvg1IbNe74pMeGGO3UDeEB6
xZV+ttEY6qGchbRqp1bfZj21GTdRs6xKAb6vcgckLz+3wXuUqCNHGY5SpChGPLwd
tzqRjPvq2JhNzRKOABuwlAR20vwa1QkgyiZHmL0Gob/MTxbLzkvi9OvXVaDc1Dp7
/vXq5/0WoIomRggqKNwWoN9trjribqptBOj/8iSxbT30LNGuwmvND3qlQNUA6RG9
CKEN5ynIsSg0FRWuG0qzOuZbxT3L5jwnpxNvl0XeYdSwnc7c5kxvmyg8XSd38XT0
cPanAnLUqhZUTLwJqGQdvUIcgHycpj8E7I+s+4c5vmh9JasSGY81bhhhrpBTq1ca
oArDKi4DycDdD/imGKl9fw/4bBQP783RXx+/QL68Y9MoI729VZRdPqP117tDvofk
EQO7iTryz7zhxeaYH3Nchm66lAnBlZWNdCWxrlivzOMc4XG3VW+Gbfnjh5FQkuE/
McdaBXk2DREuES2zBcr4DGx8W55GtGk58TFf1uWOCQUKjOwqVA+0r0CWYue5nCaT
R5CPaHDbLT1amhjy2FiA6oVjAxKW90/fHYqfChoXH2N22Jqce2U=
=KZwe
-----END PGP SIGNATURE-----
--=-=-=--

--===============1311669244==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Kc3lzdGVtZC1k
ZXZlbCBtYWlsaW5nIGxpc3QKc3lzdGVtZC1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0
cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9zeXN0ZW1kLWRldmVs
Cg==

--===============1311669244==--
