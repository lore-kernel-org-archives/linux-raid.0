From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/2] md: Inform udev about device
	removal when stopping
Date: Wed, 17 Feb 2016 07:43:03 +1100
Message-ID: <8760xotmi0.fsf@notabene.neil.brown.name>
References: <1455633877-4813-1-git-send-email-sebastian.riemer@profitbricks.com>
 <1455633877-4813-2-git-send-email-sebastian.riemer@profitbricks.com>
 <20160216200553.GA13119@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1465514563=="
Return-path: <systemd-devel-bounces@lists.freedesktop.org>
In-Reply-To: <20160216200553.GA13119@kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/systemd-devel>,
 <mailto:systemd-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/systemd-devel>
List-Post: <mailto:systemd-devel@lists.freedesktop.org>
List-Help: <mailto:systemd-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/systemd-devel>,
 <mailto:systemd-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: systemd-devel-bounces@lists.freedesktop.org
Sender: "systemd-devel" <systemd-devel-bounces@lists.freedesktop.org>
To: Shaohua Li <shli@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Brassow Jonathan <jbrassow@redhat.com>, systemd-devel@freedesktop.org
List-Id: linux-raid.ids

--===============1465514563==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 17 2016, Shaohua Li wrote:

> On Tue, Feb 16, 2016 at 03:44:36PM +0100, Sebastian Parschauer wrote:
>> When stopping an MD device, then its device node /dev/mdX may still
>> exist afterwards or it is recreated by udev. The next open() call
>> can lead to creation of an inoperable MD device. The reason for
>> this is that a change event (KOBJ_CHANGE) is announced to udev.
>> So announce a removal event (KOBJ_REMOVE) to udev instead.
>>=20
>> A change is likely also required in mdadm because of the support
>> for kernels prior to 2.6.28.
>
> I didn't follow why we need the change. Shouldn't the KOBJ_REMOVE event b=
e sent
> automatically when gendisk is deleted?
> mddev_put()->mddev_delayed_delete()->md_free()->del_gendisk().
>
> Thanks,
> Shaohua

For a bit of context: this KOBJ_CHANGE event was added in Oct 2008

Commit: 934d9c23b4c7 ("md: destroy partitions and notify udev when md array=
 is stopped.")

At the time, md devices weren't getting removed at all.
Now they are (I figured out the locking), though they can still come
back.

There are still two stages.  The array is stopped, and then the block
device is destroyed.  It is theoretically possible to stop the array
without destroying the block device, though I don't think that happens
in practice.

So this KOBJ_CHANGE is, I think, technically correct (change from
"active" to "inactive")  but probably isn't needed any more - not to the
extent it was at the time.

There are some annoying races with caused by udev responding (belatedly)
to events by running programs that open s/dev/mdXX and so automatically
re-creates the md device.
The real problem here is not the event or the delays in udev.  It is the
fact that opening /dev/mdXX transparently creates a device.

The only way (I know of) to really avoid these races is to use named
arrays.
Put
   CREATE names=3Dyes

in mdadm.conf.  Then md arrays will be created by writing a name to a
magic file in /sys.  The arrays have a minor number >=3D512 and are not
auto-re-created if the device node is re-opened before udev unlinks it.

So: the patch might be safe, and might solve a particular problem, but
it is really just a bandaid.  The best fix is "CREATE named=3Dyes" (and
use named like "md_home", not "md4".

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWw4nXAAoJEDnsnt1WYoG5yw4QAJopBZUDk9c7A/CfVcBqw3je
uFox+1XKXttl6za8TAOGomvoUXuqvlMs9pML19S4LURlXY7h6pELmb4vXaCHxG+u
psnKirsC5aQMjBCWSoftm/TPNs0MK3o5zwQDDxZZGdJAmwP8/WymCjWaol0AsbYl
M90Nv1yhBRF3fbMayHhbcmZdplZWBeM9x9uVG9lvNFTl6D2oSkK0hgxu2pSUtRGl
aoDB82WcnHzEKtE+OcgpWq5HcHm+exT66wBmv3b93SSfgdX/Gdhcn/x5caI6XYnC
h8dwN1zGZRtkjIP/U9RztnngzZkdGRVfV7FQzPjrmUoGXhMPDy5FCYtekw3PptHv
DTqfCX+2ES4EZrDU6u/JFfewTcBxhmq7DtMN2bqUVX8Lbh00gtj+1ZLnhGXNZjw5
0n8OTEhLnbckSlRszgTdYcwZEK2JkeI8kyiTDQStZt4o7e/pgLuZmvTy7fnMvPVf
zUCpRttzE7QTSlNtBuicVmLf/t/o/TQMI4r0XOboRAPJhhY+MwX3ad3QUZRIXhrZ
cA7Lf5NCfQX4Uk7+MHI/mHW9ukRMOQVCrPIPICfdKhSHr64mYTK5k1ibRItPzEwo
X5qzbYmKCxDDu//qxzAG7jbmcC7nvCQmKT2qgtsDBeeXZkMSYEreGOBiRWGbI6X2
Jhd8G4hzcumRNi+HtbnZ
=5rGB
-----END PGP SIGNATURE-----
--=-=-=--

--===============1465514563==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Kc3lzdGVtZC1k
ZXZlbCBtYWlsaW5nIGxpc3QKc3lzdGVtZC1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0
cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9zeXN0ZW1kLWRldmVs
Cg==

--===============1465514563==--
