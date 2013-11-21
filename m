From: NeilBrown <neilb@suse.de>
Subject: Re: Is there a tool to examine raw metadata?
Date: Thu, 21 Nov 2013 14:36:01 +1100
Message-ID: <20131121143601.02e72a18@notabene.brown>
References: <CANb3qHfWJp4ana76ap8YBaVJfCfmUS8FUATYS9YrAgJ9JrfLCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AHW6G4uST2Sw0ipllSG8iL_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANb3qHfWJp4ana76ap8YBaVJfCfmUS8FUATYS9YrAgJ9JrfLCQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Veedar Hokstadt <veedar@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/AHW6G4uST2Sw0ipllSG8iL_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Nov 2013 13:26:10 -0500 Veedar Hokstadt <veedar@gmail.com> wrote:

> Greetings,
> Consider a 3 drive RAID5 where each drive has lost it's partitioning
> info. Running mdadm -E does not find a superblock. But using hexedit
> an mdadm superblock can be found in tact near the end of each drive.
>=20
> Is there perhaps a tool I can point at the superblock to decode it? Or
> trick mdadm into reporting the contents of the superblock?
>=20
> I know I can look at the superblock format doc and translate it by
> hand but I was hoping for an easier way.   Thanks for any help.  -V
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

If you use losetup to create a device pointing to the original but with an
offset to match where you think the partition was, then run "mdadm -E" on t=
he
loop device.

You could probably do:

 for i in {1..1000}
 do
  losetup -o $i /dev/loop0 /dev/whatever
  echo $i
  mdadm -E /dev/loop0
  mdadm -d /dev/loop0
 done

NeilBrown

--Sig_/AHW6G4uST2Sw0ipllSG8iL_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUo1/oTnsnt1WYoG5AQKK3w/9HsZYpkfCC1QmRIagG+JyDNHuVNYV0CBW
SZFRy0ufyGkHCiHSmD6prIilInu4EabfnwnR9uhtnj15LONHSAtCW0kLsAXfnsAy
Gk3vccH8yK+YaDYwsQr9S7lAn+R6+fLrNVPWNlNN9LEJ1BsF6Y0IWwv6jo10aEu8
ueH22qUb9YCIxr85rTYwOBsZowucxuPAj0tMxlWRQWbvbjAOldUWxhhlBiYzlBfW
P5FKUoAfe0sMnjzJHUtyl47+HPDPF9T+kYutPOm7pM2RJXYe+/Xq61GxvoKT3LAd
1QWqBOwksZHuEmM0bCkuZEnriaq5HEdF3gfvF+36+ab6u3lHIfVUsrdlpUirapcZ
KTo+GR1U2vqBpOzWDJaNDvJHkzdSxVy2cZV0NJ8lkdWme1Gf97l2CDyC8nI/5bpz
/nS5RRepwctGIyriC9kI8UyCiB22RCdtIaWvOhL52twNZgQxX/K7j8MfoS+NGBYP
44v9gHsL17f9LGcFCmdAy8eo9RuMxgixYIxAiuo4vJu8VkGJTkmrEvc42VI8tkvd
canXKEoEGqtsxK6nl8fa/CYNwQ4PHKPJLp/c/xeBiQiHDLsj0V2nL9770sY1qWtT
WXaPadCIEBmhJj0fL/SD7LW9+PwGLCqt4PfEVVmVze9kvlmKLw50BQSV9zdgoIHC
7M6y+BTZ1YU=
=xY7A
-----END PGP SIGNATURE-----

--Sig_/AHW6G4uST2Sw0ipllSG8iL_--
