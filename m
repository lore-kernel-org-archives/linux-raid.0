From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] md: Drop sending a change uevent when stopping
Date: Thu, 18 Feb 2016 07:45:40 +0100
Message-ID: <56C56894.8070906@suse.de>
References: <1455726300-20340-1-git-send-email-sebastian.riemer@profitbricks.com>
 <20160217181943.GA28011@kernel.org> <871t8brpon.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871t8brpon.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Jes Sorensen <Jes.Sorensen@redhat.com>, Brassow Jonathan <jbrassow@redhat.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>, systemd-devel@freedesktop.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/17/2016 10:29 PM, NeilBrown wrote:
> On Thu, Feb 18 2016, Shaohua Li wrote:
>=20
>> On Wed, Feb 17, 2016 at 05:25:00PM +0100, Sebastian
>> Parschauer wrote:
>>> When stopping an MD device, then its device node /dev/mdX
>>> may still exist afterwards or it is recreated by udev. The
>>> next open() call can lead to creation of an inoperable MD
>>> device. The reason for this is that a change event
>>> (KOBJ_CHANGE) is sent to udev which races against the
>>> remove event (KOBJ_REMOVE) from md_free(). So drop sending
>>> the change event.
>>>=20
>>> A change is likely also required in mdadm as many versions
>>> send the change event to udev as well.
>>=20
>> Makes sense, it's unlikely we need the CHANGE event.
>> Applied.
>>=20
>> Thanks, Shaohua
>=20
> It would be worth checking, but I think that with this change,
> you can write "inactive" to /sys/block/mdXXX/md/array_state and
> the array will become inactive, but no uevent will be
> generated, which isn't good. Maybe send the uevent that was
> just removed from the 'inactive' case of array_state_store()
> instead.
>=20
> (But I still think this is just a bandaid and doesn't provide
> any guarantees that there will be no races with udev)
>=20
Thing is, _none_ of the other subsystems will ever send a uevent
when it becomes inactive.
(Would be pretty pointless, too, as what exactly is one supposed
to do here?)
The current usage has it that CHANGE events are only ever sent if
a device becomes active.

Cheers,

Hannes
- --=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJWxWiUAAoJEGz4yi9OyKjPUhUP+gJXhNTCYTbLNzR7LYcPQplY
rqcALLhZIDt8inveiSaPVXs5F1VCQsT87qS6JtD3EBSU64eWVq0+xowxKStoyjPl
/MaBFQs7yxJCdf5Enx0/hKPN3MYuQT2nf5EiB461mlnfxLZKUEgwKbDK6+6HqToI
x0rtUFv4JpVDd9HFY3PNqZjGtQTMrbXMVxsBtefIiYPeyaPpYU9Zo0qM+17CmJIr
J3JdXOjHluengKcdi1O6GDvshUiysWP/ukG/q7If4JxpomKS5ljOn5MHcCgBl/CL
UwjUuSmZ9e5ZKyIIxU2oMAFRYqLCGX5Fw5Q90YG7UOZQ3ODbYPJfR7d61OSjomYt
j0bME+QXkdoxOkwlG7EwSU8fG6dv4H55RxrrFcu4ZBl6TRo3jpCOCrq+kY1XapF4
NGeY0j3vBQ4ZziMNodelg+KZaBrCSFGu+cn7uqEsrOJ+N4e7gJv28trPiPzE4Hiz
07buvtTNEYQuqUNvR9MiuDCubnHy0imaA+3fb0orXZOllhYFAMfUVxpOsJvO/ySg
XVSrpcm7BnU/4i6sNXJUpZdTrmWPi8kvZU9avlZFwL0CrVtdhjkoGOu20Ou7H53g
nR3wXQWEybd8yK62lqb3g7one/JnEeVupb69aSiaJnAt7kLZE2Dcg5QVFPAXOIDU
eqYQYG60/85zdeLcqzlM
=3De02n
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
