From: NeilBrown <neilb@suse.de>
Subject: Re: frequent disk activity with mdadm-3.3
Date: Thu, 18 Sep 2014 20:03:47 +1000
Message-ID: <20140918200347.762845bb@notabene.brown>
References: <AB305DF4-9DCC-47E1-9B29-130E211D4B4E@gmail.com>
	<20140912082403.549fc298@notabene.brown>
	<164CD08B-99CA-4007-855A-7B0561B4EC76@gmail.com>
	<BDDC2624-8578-4720-A526-56EFDFBE26C4@gmail.com>
	<20140915101830.3c85d423@notabene.brown>
	<DDAF4EEF-EFA9-4B0E-BB97-E5D8B9788A70@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/SA6wjNLNDzxXvSSl/AIg4Qx"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <DDAF4EEF-EFA9-4B0E-BB97-E5D8B9788A70@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marco Schindler <marco.schindler@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/SA6wjNLNDzxXvSSl/AIg4Qx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Sep 2014 12:52:07 +0200 Marco Schindler
<marco.schindler@gmail.com> wrote:

>=20
> On 15.09.2014, at 02:18, NeilBrown <neilb@suse.de> wrote:
>=20
> > It would help to get "udevadm monitor" info to correlate with this.
> > Presumably some uevent is generated when the spindown happens.  udev mi=
ght
> > respond to this by reading from the device, which defeats the purpose...
> >=20
> >=20
> >>=20
> >> here=E2=80=99s the output of blktrace -d /dev/sda during that time.
> >> https://dl.dropboxusercontent.com/u/3464720/blktrace.tar.bz2
> >=20
> > That suggest that something is reading the metadata from the device alm=
ost
> > constantly.  Mostly a 'kworker' thread.  I don't know what would cause =
that.
> >=20
> > Let's look at the 'udevadm monitor' trace first and see what that shows.
>=20
> here=E2=80=99s the output of udevadm monitor during the spindown cycle wh=
ile mdadm-3.3 is installed.
>=20
> monitor will print the received events for:
> UDEV - the event which udev sends out after rule processing
> KERNEL - the kernel uevent
>=20
> KERNEL[299719.336261] change   /devices/pci0000:00/0000:00:06.0/0000:09:0=
0.0/host0/port-0:1/end_device-0:1/target0:0:1/0:0:1:0/block/sdb (block)
> UDEV  [299720.646760] change   /devices/pci0000:00/0000:00:06.0/0000:09:0=
0.0/host0/port-0:1/end_device-0:1/target0:0:1/0:0:1:0/block/sdb (block)
> KERNEL[299780.202901] change   /devices/pci0000:00/0000:00:06.0/0000:09:0=
0.0/host0/port-0:0/end_device-0:0/target0:0:0/0:0:0:0/block/sda (block)
> UDEV  [299781.567308] change   /devices/pci0000:00/0000:00:06.0/0000:09:0=
0.0/host0/port-0:0/end_device-0:0/target0:0:0/0:0:0:0/block/sda (block)
> KERNEL[299841.090818] change   /devices/pci0000:00/0000:00:06.0/0000:09:0=
0.0/host0/port-0:1/end_device-0:1/target0:0:1/0:0:1:0/block/sdb (block)
> UDEV  [299842.407035] change   /devices/pci0000:00/0000:00:06.0/0000:09:0=
0.0/host0/port-0:1/end_device-0:1/target0:0:1/0:0:1:0/block/sdb (block)
>=20
> please note that the issue immediately disappears when downgrading to mda=
dm-3.2 without touching anything else.
> I see the udev rules have been updated in mdadm-3.3..

Getting a "change" even on spindown is causing the problem I suspect.
A change in 3.3.1 causes "mdadm -I" to be run on a device when it 'changes'.
That will read from the device which will wake it up.
(commit 25392f5fc59f96fb76 - revert it and the symptom will probably go awa=
y).

I really think the "bug" here is that the change event is emitted on
'spindown', but maybe the bug is that the exact meaning of 'change' isn't
well documented.

I can probably get "mdadm -I" to use O_EXCL which will fail on devices
already in an array, but I'm not sure that is a complete solution.  You cou=
ld
still get wakeups on other devices.

Can you rung the 'udevadm monitor' again, but this time with '--property'.
Maybe there is some property associated with spindown events which we can u=
se
to ignore them.

NeilBrown

--Sig_/SA6wjNLNDzxXvSSl/AIg4Qx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBquAznsnt1WYoG5AQKaQA//clFisrotmygI03JkDaT5MrIc3sLw7FVi
kyN6TKdHulQQaIlgm8SChKT8b1ZrGVsorvH5wv7tu/xkHHcf7xKtSDwQde0soy5J
8cdMnnli9K8iBhgNNAa7cEmphkZHY0riF0CZZFRFjjQCoX2GmylqL+6mQGau/kuZ
+xS2p9vsDidL5lzMuurM9b3imGT0maguFfbrGzrpg7LEpRNyrNCmXVeNrYxsgi8x
YkMKuCPJdK25W+YUqJgVJU8OUbrDnLmiVh6NULWW+y/STseBdYeWhbe0FZ03rQrF
r6D3Z1FcwXK7aN5Efy0V+tn/U6tsa+SCBLSXobZE81qacyQBQTlSkl0AalG3/h77
rfMw0mOPudPIWoBYu9a0KMWESAhT6XmboWC9EvVdXtHlbgYBpVggP+AKw0pRUbYP
Q+GM63aOTUEIENH5eBkfh5nTsaAfW6wR8SCzoD8dbmv5TXgqeBg7496uQcyeivyn
CDyqlfPeDgO9Blo4dGEcao+jpWmo/pAYAse4laQ74qwgbNKqLSkUpllQaLfC/DWH
8RCgsLqkB8+4BheDiuWy6A3qj8mFEvq5N2c+IuOYXAnsNAAM4pZOLei4mTQXZv0W
Ex5GhXbkk+zdMRykBE9AKHDX+w+GYJwyYX3ibVYKaR8sJG3r5mpBIjo5YAo9OunH
QajFZgF/aSU=
=fyTQ
-----END PGP SIGNATURE-----

--Sig_/SA6wjNLNDzxXvSSl/AIg4Qx--
