From: NeilBrown <neilb@suse.com>
Subject: Re: Errorneous detection of degraded array
Date: Mon, 30 Jan 2017 17:36:51 +1100
Message-ID: <87k29drr3w.fsf@notabene.neil.brown.name>
References: <96A26C8C6786C341B83BC4F2BC5419E4795DE9A6@SRF-EXCH1.corp.sunrisefutures.com>
 <b842c2ce-7d32-a392-e9d9-9f330fa6a7cf@gmail.com>
 <87vasxs47y.fsf@notabene.neil.brown.name>
 <666d5a48-4c71-77ee-f71b-c32f334cf7cc@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0327141363=="
Return-path: <systemd-devel-bounces@lists.freedesktop.org>
In-Reply-To: <666d5a48-4c71-77ee-f71b-c32f334cf7cc@gmail.com>
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

--===============0327141363==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 30 2017, Andrei Borzenkov wrote:

> 30.01.2017 04:53, NeilBrown =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>> On Fri, Jan 27 2017, Andrei Borzenkov wrote:
>>=20
>>> 26.01.2017 21:02, Luke Pyzowski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>>> Hello,
>>>> I have a large RAID6 device with 24 local drives on CentOS7.3. Randoml=
y (around 50% of the time) systemd will unmount my RAID device thinking it =
is degraded after the mdadm-last-resort@.timer expires, however the device =
is working normally by all accounts, and I can immediately mount it manuall=
y upon boot completion. In the logs below /share is the RAID device. I can =
increase the timer in /usr/lib/systemd/system/mdadm-last-resort@.timer from=
 30 to 60 seconds, but this problem can randomly still occur.
>>>>
>>>> systemd[1]: Created slice system-mdadm\x2dlast\x2dresort.slice.
>>>> systemd[1]: Starting system-mdadm\x2dlast\x2dresort.slice.
>>>> systemd[1]: Starting Activate md array even though degraded...
>>>> systemd[1]: Stopped target Local File Systems.
>>>> systemd[1]: Stopping Local File Systems.
>>>> systemd[1]: Unmounting /share...
>>>> systemd[1]: Stopped (with error) /dev/md0.
>>=20
>> This line perplexes me.
>>=20
>> The last-resort.service (and .timer) files have a Conflict=3D directive
>> against sys-devices-virtual-block-md$DEV.device=20
>> Normally a Conflicts=3D directive means that if this service starts, that
>> one is stopped, and if that one starts, this is stopped.
>> However .device units cannot be stopped:
>>=20
>> $ systemctl show sys-devices-virtual-block-md0.device | grep Can
>> CanStart=3Dno
>> CanStop=3Dno
>> CanReload=3Dno
>> CanIsolate=3Dno
>>=20
>> so presumable the attempt to stop the device fails, so the Conflict=3D
>> dependency cannot be met, so the last-resort service (or timer) doesn't
>> get started.
>
> As I explained in other mail, to me it looks like last-resort timer does
> get started, and then last-resort service is started which attempts to
> stop device and because mount point depends on device it also stops
> mount point. So somehow we have bad timing when both device and timer
> start without canceling each other.
>
> The fact that stopping of device itself fails is irrelevant here -
> dependencies are evaluated at the time job is submitted, so if
> share.mount Requires dev-md0.device and you attempt to Stop
> dev-md0.device, systemd still queues job to Stop share.mount.
>
>> At least, that is what I see happening in my tests.
>>=20
>
> Yes, we have race condition here, I cannot reproduce this either. It
> does not mean it does not exist :) Let's hope debug logging will show
> something more useful (it is entirely possible that with debugging logs
> turned on this race does not happen).
>
>> But your log doesn't mention sys-devices-virtual-block-md0, it
>> mentions /dev/md0.
>> How does systemd know about /dev/md0, or the connection it has with
>> sys-devices-virtual-block-md0 ??
>>=20
>
> By virtue of "Following" attribute. dev-md0.device is Following
> sys-devices-virtual-block-md0.device so stopping the latter will also
> stop the former.

Ahh.. I see why I never saw this now.
Two reasons.
 1/ My /etc/fstab has UUID=3Dd1711227-c9fa-4883-a904-7cd7a3eb865c rather
    than /dev/md0
    systemd doesn't manage to intuit a 'Following' dependency between
    the UUID and the mount point.
 2/ I use partitions of md arrays: that UUID is actually /dev/md0p3.
    systemd doesn't intuit that md0p3.device is Following md0.device.

So you only hit a problem if you have "/dev/md0" or similar in
/etc/fstab.

The race is, I think, that one I mentioned.  If the md device is started
before udev tells systemd to start the timer, the Conflicts dependencies
goes the "wrong" way and stops the wrong thing.

It would be nice to be able to reliably stop the timer when the device
starts, without risking having the device get stopped when the timer
starts, but I don't think we can reliably do that.

Changing the
  Conflicts=3Dsys-devices-virtual-block-%i.device
lines to
  ConditionPathExists=3D/sys/devices/virtual/block/%i
might make the problem go away, without any negative consequences.

The primary purpose of having the 'Conflicts' directives was so that
systemd wouldn't log
  Starting Activate md array even though degraded
after the array was successfully started.
Hopefully it won't do that when the Condition fails.

Thanks,
NeilBrown


=20
=20=20

>
>> Does
>>   systemctl  list-dependencies  sys-devices-virtual-block-md0.device
>>=20
>> report anything interesting?  I get
>>=20
>> sys-devices-virtual-block-md0.device
>> =E2=97=8F =E2=94=94=E2=94=80mdmonitor.service
>>=20

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAliO3wMACgkQOeye3VZi
gblAHA//WzZLO3Wbt/eb401pr/patujcQ/ScvXT0g7VuSZflqzzFQsQZkuym+O2o
SIxueS7CQabg+vKt3EruIoxOv9fSkcWm0jsoca7gYYWxpmSK104pv7FRFQRLEJD1
Ve2TZXTK8nPT6aM+UezdAmVRIrMqN9de9Oe4aHsc1BddLqU1m2bNgxtOS99RsIEq
AX2UouHaswPs4lXscxDkMFAxJnvg4aLBsysXyiNp8JpBXiuvtlpzuJJuhpolUs66
/Mb+N4uKAabxbngVXVqNZQMOoTorRDVH8YGf/Q7X5zYFiqdpOTclVlpyov2j+dC7
PnGC/AJjhQFp6Q+uQOlSx1Z3T3bxk9EpX4iSC46kOoGQ//YNNI5bwKi4ECYDf/dt
LT0uYuBAPr+DQa1l/3Rm1Bh896EIljCkCx/ArWM0Wgi3nZBSv2wxW/wyFhmU5t0g
k+HVtL4uP2/2/J2X0tO5vUVdBb6+goBrLFOZp0xidlhDiswKWtStvX1p5ArEOA3f
QeZ5NwBxtSvUnUf5XHqLFKBaKXxc0PQD5pE1WmnrsMgnbsRyNF+MSIYZ66/i0YYJ
R1gdtoijuB65lXq25c5ljSMEQ3Pn4FZAbeZ7SGu5zyoSuxNkC3d4T9uSrnAV+RFX
tOp2HGAcO4jkWK/Or81oE6h84fUO/1URtxoETFLaOC8I+qVNYeQ=
=gaBI
-----END PGP SIGNATURE-----
--=-=-=--

--===============0327141363==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Kc3lzdGVtZC1k
ZXZlbCBtYWlsaW5nIGxpc3QKc3lzdGVtZC1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0
cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9zeXN0ZW1kLWRldmVs
Cg==

--===============0327141363==--
