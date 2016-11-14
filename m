From: NeilBrown <neilb@suse.com>
Subject: Re: mdadm I/O error with Ddf RAID
Date: Mon, 14 Nov 2016 17:00:45 +1100
Message-ID: <874m3ak3ci.fsf@notabene.neil.brown.name>
References: <CAPO=kN2QDLEMgo9p9pU3=MeLQ=J6R8eeDL1Pw9m2pHjbVsuFGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPO=kN2QDLEMgo9p9pU3=MeLQ=J6R8eeDL1Pw9m2pHjbVsuFGg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arka Sharma <arka.sw1988@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Nov 11 2016, Arka Sharma wrote:

> Hi All,
>
> We have developed a RAID creation application which create RAID with
> Ddf RAID metadata. We are using PCIe ssd as physical disks. We are
> writing the anchor, primary, secondary headers, virtual and physical
> records, configuration record and physical disk data. The offsets of
> the headers are updated in the primary, secondary and anchor headers
> correctly. The problem is when we try to boot to Ubuntu server and we
> observe that mdadm is throwing a disk failure error message and from
> block layer we are getting rw=0, want=7, limit=1000215216. We also
> confirmed using there is no I/O error is coming from the PCIe ssd,
> using a logic analyzer. Also the limit value 1000215216 is the
> capacity of the ssd in 512 byte blocks. Any insight will be highly
> appreciated.
>

It looks like mdadm is attempting a 4K read starting at the last sector.

Possibly the ssd's report a physical sector size of 4K.

I don't know how DDF is supposed to work on a device like that.
Should the anchor be at the start of the last 4K block,
or in the last 512byte virtual block?

DDF support in mdadm was written with the assumption of 512 byte blocks.

I'm not at all certain this is the cause of the problem though.

I would suggest starting by finding out which READ request in mdadm is
causing the error.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYKVMNAAoJEDnsnt1WYoG5q5sQALLKxgqhpjZKdiCG6ITBAvzl
Z9owGFypsVw5MoH8tW9wqOqpRsDgE+GHVGfxhyQgPY8Xpdnd9UrSAxlHGgJkZe97
qztwftdaxDZ5ODAx6NqODyP+59SY89ikYCIBCkFn/dvu2+KAAa8ZiD+Gx8i+Dl1d
l1QAzBzMiO5pcPZuqb+Yj+s0AWEtZWnt+8zZ1pzuNpW6oJxoMie196+8kE+Gr6kT
U4UczSxU9IgFrfHMMCb40dmfNhXXPIYkZ6sNAVo3JTihJxK9+Oo4U5kgtVtZbpLQ
bQbnvgFQAzM75J2xwd+v/g+zAh8BcVt8SwYqXg0irAKOitmN2Y7BOQobiF6s4+ir
slZtteZ/5FcQVWFDMlM6ltTiV9ZUpOzenaePAapNM1WLJbNymizWgs5WoOJ5SwWt
a++qoy1wTZ0KJ75ob6CPUCDfoPBWrX9kQEfxHII4pXoGFqe/gAL5B5PNlRrblwzU
3QulKzf/evVTDhgvvLuD+vRebKjQJdbxOErVY6qEbB2jB7oAJVJguO0lcFhRZdYj
pwPVcM4Xmz15+tlZ8YG3FHlTV/NhDGkBezDNxos8NjrAspH6vW2zX+rEgslTJxrD
AiiKrmr+06Hfp4gnQbKMI5rLGksA7gsxBAM3++31RT1cSSecqvyZcN3j77IPiuwF
Eh3ThMI+8bBsLcOcqnHy
=xyd3
-----END PGP SIGNATURE-----
--=-=-=--
