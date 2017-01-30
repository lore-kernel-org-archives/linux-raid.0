From: Andrei Borzenkov <arvidjaar@gmail.com>
Subject: Re: Errorneous detection of degraded array
Date: Mon, 30 Jan 2017 06:40:09 +0300
Message-ID: <666d5a48-4c71-77ee-f71b-c32f334cf7cc@gmail.com>
References: <96A26C8C6786C341B83BC4F2BC5419E4795DE9A6@SRF-EXCH1.corp.sunrisefutures.com>
 <b842c2ce-7d32-a392-e9d9-9f330fa6a7cf@gmail.com>
 <87vasxs47y.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1629374690=="
Return-path: <systemd-devel-bounces@lists.freedesktop.org>
In-Reply-To: <87vasxs47y.fsf@notabene.neil.brown.name>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/systemd-devel>,
 <mailto:systemd-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/systemd-devel>
List-Post: <mailto:systemd-devel@lists.freedesktop.org>
List-Help: <mailto:systemd-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/systemd-devel>,
 <mailto:systemd-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: systemd-devel-bounces@lists.freedesktop.org
Sender: "systemd-devel" <systemd-devel-bounces@lists.freedesktop.org>
To: NeilBrown <neilb@suse.com>, Luke Pyzowski <Luke@sunrisefutures.com>, "'systemd-devel@lists.freedesktop.org'" <systemd-devel@lists.freedesktop.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============1629374690==
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="DQrqn0WQTAkcKUodaDpE3L3SUWHqqBKVL"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DQrqn0WQTAkcKUodaDpE3L3SUWHqqBKVL
Content-Type: multipart/mixed; boundary="msd4NlOLnRWDfv64uqIORkCvK5pS3U2C9"
From: Andrei Borzenkov <arvidjaar@gmail.com>
To: NeilBrown <neilb@suse.com>, Luke Pyzowski <Luke@sunrisefutures.com>,
 "'systemd-devel@lists.freedesktop.org'"
 <systemd-devel@lists.freedesktop.org>, linux-raid@vger.kernel.org
Message-ID: <666d5a48-4c71-77ee-f71b-c32f334cf7cc@gmail.com>
Subject: Re: [systemd-devel] Errorneous detection of degraded array
References: <96A26C8C6786C341B83BC4F2BC5419E4795DE9A6@SRF-EXCH1.corp.sunrisefutures.com>
 <b842c2ce-7d32-a392-e9d9-9f330fa6a7cf@gmail.com>
 <87vasxs47y.fsf@notabene.neil.brown.name>
In-Reply-To: <87vasxs47y.fsf@notabene.neil.brown.name>

--msd4NlOLnRWDfv64uqIORkCvK5pS3U2C9
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

30.01.2017 04:53, NeilBrown =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Fri, Jan 27 2017, Andrei Borzenkov wrote:
>=20
>> 26.01.2017 21:02, Luke Pyzowski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>> Hello,
>>> I have a large RAID6 device with 24 local drives on CentOS7.3. Random=
ly (around 50% of the time) systemd will unmount my RAID device thinking =
it is degraded after the mdadm-last-resort@.timer expires, however the de=
vice is working normally by all accounts, and I can immediately mount it =
manually upon boot completion. In the logs below /share is the RAID devic=
e. I can increase the timer in /usr/lib/systemd/system/mdadm-last-resort@=
=2Etimer from 30 to 60 seconds, but this problem can randomly still occur=
=2E
>>>
>>> systemd[1]: Created slice system-mdadm\x2dlast\x2dresort.slice.
>>> systemd[1]: Starting system-mdadm\x2dlast\x2dresort.slice.
>>> systemd[1]: Starting Activate md array even though degraded...
>>> systemd[1]: Stopped target Local File Systems.
>>> systemd[1]: Stopping Local File Systems.
>>> systemd[1]: Unmounting /share...
>>> systemd[1]: Stopped (with error) /dev/md0.
>=20
> This line perplexes me.
>=20
> The last-resort.service (and .timer) files have a Conflict=3D directive=

> against sys-devices-virtual-block-md$DEV.device=20
> Normally a Conflicts=3D directive means that if this service starts, th=
at
> one is stopped, and if that one starts, this is stopped.
> However .device units cannot be stopped:
>=20
> $ systemctl show sys-devices-virtual-block-md0.device | grep Can
> CanStart=3Dno
> CanStop=3Dno
> CanReload=3Dno
> CanIsolate=3Dno
>=20
> so presumable the attempt to stop the device fails, so the Conflict=3D
> dependency cannot be met, so the last-resort service (or timer) doesn't=

> get started.

As I explained in other mail, to me it looks like last-resort timer does
get started, and then last-resort service is started which attempts to
stop device and because mount point depends on device it also stops
mount point. So somehow we have bad timing when both device and timer
start without canceling each other.

The fact that stopping of device itself fails is irrelevant here -
dependencies are evaluated at the time job is submitted, so if
share.mount Requires dev-md0.device and you attempt to Stop
dev-md0.device, systemd still queues job to Stop share.mount.

> At least, that is what I see happening in my tests.
>=20

Yes, we have race condition here, I cannot reproduce this either. It
does not mean it does not exist :) Let's hope debug logging will show
something more useful (it is entirely possible that with debugging logs
turned on this race does not happen).

> But your log doesn't mention sys-devices-virtual-block-md0, it
> mentions /dev/md0.
> How does systemd know about /dev/md0, or the connection it has with
> sys-devices-virtual-block-md0 ??
>=20

By virtue of "Following" attribute. dev-md0.device is Following
sys-devices-virtual-block-md0.device so stopping the latter will also
stop the former.

> Does
>   systemctl  list-dependencies  sys-devices-virtual-block-md0.device
>=20
> report anything interesting?  I get
>=20
> sys-devices-virtual-block-md0.device
> =E2=97=8F =E2=94=94=E2=94=80mdmonitor.service
>=20



--msd4NlOLnRWDfv64uqIORkCvK5pS3U2C9--

--DQrqn0WQTAkcKUodaDpE3L3SUWHqqBKVL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEARECAAYFAliOtaEACgkQR6LMutpd94yMOwCgoY3oo7mtlLJpJrOuV6mtoUD7
RxIAn2ZAigldaNs6owTuErbR6DUowzSJ
=N7R9
-----END PGP SIGNATURE-----

--DQrqn0WQTAkcKUodaDpE3L3SUWHqqBKVL--

--===============1629374690==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Kc3lzdGVtZC1k
ZXZlbCBtYWlsaW5nIGxpc3QKc3lzdGVtZC1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0
cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9zeXN0ZW1kLWRldmVs
Cg==

--===============1629374690==--
