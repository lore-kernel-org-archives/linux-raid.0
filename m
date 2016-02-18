From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: Drop sending a change uevent when
	stopping
Date: Fri, 19 Feb 2016 10:06:20 +1100
Message-ID: <87egc9pqj7.fsf@notabene.neil.brown.name>
References: <1455726300-20340-1-git-send-email-sebastian.riemer@profitbricks.com>
 <20160217181943.GA28011@kernel.org> <871t8brpon.fsf@notabene.neil.brown.name>
 <56C56894.8070906@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0429375645=="
Return-path: <systemd-devel-bounces@lists.freedesktop.org>
In-Reply-To: <56C56894.8070906@suse.de>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/systemd-devel>,
 <mailto:systemd-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/systemd-devel>
List-Post: <mailto:systemd-devel@lists.freedesktop.org>
List-Help: <mailto:systemd-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/systemd-devel>,
 <mailto:systemd-devel-request@lists.freedesktop.org?subject=subscribe>
Errors-To: systemd-devel-bounces@lists.freedesktop.org
Sender: "systemd-devel" <systemd-devel-bounces@lists.freedesktop.org>
To: Hannes Reinecke <hare@suse.de>, Shaohua Li <shli@kernel.org>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Jes Sorensen <Jes.Sorensen@redhat.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, Brassow Jonathan <jbrassow@redhat.com>, systemd-devel@freedesktop.org
List-Id: linux-raid.ids

--===============0429375645==
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 18 2016, Hannes Reinecke wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 02/17/2016 10:29 PM, NeilBrown wrote:
>> On Thu, Feb 18 2016, Shaohua Li wrote:
>>=20
>>> On Wed, Feb 17, 2016 at 05:25:00PM +0100, Sebastian
>>> Parschauer wrote:
>>>> When stopping an MD device, then its device node /dev/mdX
>>>> may still exist afterwards or it is recreated by udev. The
>>>> next open() call can lead to creation of an inoperable MD
>>>> device. The reason for this is that a change event
>>>> (KOBJ_CHANGE) is sent to udev which races against the
>>>> remove event (KOBJ_REMOVE) from md_free(). So drop sending
>>>> the change event.
>>>>=20
>>>> A change is likely also required in mdadm as many versions
>>>> send the change event to udev as well.
>>>=20
>>> Makes sense, it's unlikely we need the CHANGE event.
>>> Applied.
>>>=20
>>> Thanks, Shaohua
>>=20
>> It would be worth checking, but I think that with this change,
>> you can write "inactive" to /sys/block/mdXXX/md/array_state and
>> the array will become inactive, but no uevent will be
>> generated, which isn't good. Maybe send the uevent that was
>> just removed from the 'inactive' case of array_state_store()
>> instead.
>>=20
>> (But I still think this is just a bandaid and doesn't provide
>> any guarantees that there will be no races with udev)
>>=20
> Thing is, _none_ of the other subsystems will ever send a uevent
> when it becomes inactive.

A CDROM drive does when you eject the media.


> (Would be pretty pointless, too, as what exactly is one supposed
> to do here?)

Lazy-unmount the filesystem?
If the array was part of another array, mark the slot in that array as
'faulty' ?

> The current usage has it that CHANGE events are only ever sent if
> a device becomes active.

"mostly" but not "only ever".

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWxk5sAAoJEDnsnt1WYoG5TU8QAI0Cg7Lk1pOHjiqWWiRKKusN
X7i5rnp7uEYTHaru7HuhgjqilMKzO5wC8em9ZUD56zPVkXzSmgvcG59eli0288Pn
LM/2W6XjYVZnbkfnho9xGdc8VGnwVz317J/w49BFZhRRzDVwnMLayGk3w2s3kDTZ
zKJgbqUxuatBATYyhPCqb1Uw/hqtCgxgMwqjA9w4TeftX2HOvN8kGk5IxiWLVunP
wgdres3vCpwBMRVB2sascXdOAh2Kv1DMPoEyuxsJcBVORtH1nq/LtxH0udtxFVJA
y3UC90Iy+yGTXkabsAZ0GNCKvvGWwEm8Fyr9th3IVzRsBqkIPLoopJW9ZTUlr1uK
Ynw3UibhXk+gfh9ZskkPoq432zUnUJ9vQLnBYTH2/HmWluHYyOMia34WvkIEZQSe
6Ty0kwD9I8pzAjtHPduMdoue3m+aYdHZtT1DXvXoTcktjT+FTy50ahOIEwHw/Okk
5W2aZNd/rzOVO4yBslWSP+pHWviMrolZn8rYA20zL8UwiqUgbHChWOnMLqeRbWaW
H2JQIw3mp+VTBVQzolzRR/0eOKnWURy9h+RzoWCEgcY+CC9Lzifi1/k+BbaATDlM
DXnUukej+Q96Q5kWX8ewenL8sHhVhF161JheWAr00Mbp7/D6CWfEpfBXZXXDtGv9
qfn4I1PZLs82vjmGsWnb
=bBke
-----END PGP SIGNATURE-----
--=-=-=--

--===============0429375645==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Kc3lzdGVtZC1k
ZXZlbCBtYWlsaW5nIGxpc3QKc3lzdGVtZC1kZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0
cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9zeXN0ZW1kLWRldmVs
Cg==

--===============0429375645==--
