From: NeilBrown <nfbrown@novell.com>
Subject: Re: Reading the same block via partition and non-partitioned device gives different content
Date: Tue, 05 Jan 2016 22:23:33 +1100
Message-ID: <87lh84xoay.fsf@notabene.neil.brown.name>
References: <568B7EA7.9010901@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <568B7EA7.9010901@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrei Borzenkov <arvidjaar@gmail.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Jan 05 2016, Andrei Borzenkov wrote:

> [Please Cc me on reply; thank you]
>
> QEMU KVM virtual machine with openSUSE Tumbleweed (kernel
> 4.3.3-3-default); MD RAID1 with 1.2 metadata on /dev/vdb1 and /dev/vdc1.
>
> If I do
>
> mdadm /dev/mdX --fail /dev/vdb1
> mdadm /dev/mdX --add /dev/vdd1
>
> and wait for synchronization to finish and then look directly on on-disk
> suportblock, I see different content whether I read from /dev/vdd or
> from /dev/vdd1.
>
> /dev/vdd1 claims new disk is still spare (i.e. it is apparently
> immediately after adding it).
>
> The *same* superblock when read from /dev/vdd (of course with
> appropriate offset) correctly marks /dev/vdd1 as RAID member. The same
> content also seen when looking from host.
>
> I hit this when debugging problem with grub2 that scans devices for
> Linux MD (it is using the same code both at boot and run time). It
> skipped replacement disk because it believed disk was spare.
>
> Is it expected behavior? Note that if we now replace /dev/vdc1 with
> something else we have "wrong" superblock on both partitions so grub
> fails to find array completely. Fortunately this is transient state, but
> it also means it is impossible to reconfigure grub until reboot.
> Alternatively shutting down and restarting array cleats it as well.
>
> Any trick we can use to force content to be the same in this state?

blockdev --flushbufs /dev/vdd*

or use O_DIRECT to access the devices.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWi6e1AAoJEDnsnt1WYoG5NoIQAK3qoE6tS2u6y1x0ovgo3Ekb
MNXwjk5E8XAVh0Z3h7vqtjqzUs6nBKpkV0ukmu7+vArq4zuuT4WgyAMbJa10zZUU
sajtpqYfyHQSaRD1+Ova5XWFzS5wDe172lSnkpmJn+CUgclVZZuN7a6wHvO8O1IB
90Uk+De8q5pHdgb8iCbe6/PBTLZNIwsuJGik4r/YYRif1aNztdXl97Nmbwdt6Ftr
aylJFmgUZtyCu5HVf7Y2BjfajnXJwVZ1c+8QeGiBaqyjMGk5ww4FFERWJ8GLDQ05
6BVCcJZR9rVhc4QzwiCyhjp0skfqzg1n7evjkqjfTfi2SpUu0s+njPZKvmGUMecn
GR25gKcVWXdJPp1wxwjUqUj+mVdGaV5q7cQunuwze7N/F7H/HEMx2G0vlRrFmtBq
GFSg8g5X8bweNxVj/a+rtugyEZfOk42nmQfSnCXt7Lh92GO6gzzsvvc15eQmdfad
SF/yakCcaYxjzuNv8yBy5jgWgflQS79ZyqBTYIkWF/zuZD8VVEmRRHkFbPWGn+5+
BzJIjqBZ6aSbrrQKQJEwRgoZic/SSeqjvlsyRTY/kB5Tm5vQ28qvqM0mouSBgLRM
1QNqeFBoauIAoB2FA6uqOeo6IcrV7KA59Q9esM35QascfFYoOeNGOFc+0wuMhW5Q
Od9phJgzy48R5IFoZBYm
=wDwi
-----END PGP SIGNATURE-----
--=-=-=--
