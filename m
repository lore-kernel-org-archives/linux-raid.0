From: NeilBrown <neilb@suse.com>
Subject: Re: Shrinking an array
Date: Tue, 11 Apr 2017 14:33:24 +1000
Message-ID: <87fuhfwokr.fsf@notabene.neil.brown.name>
References: <20170411003008.GA18538@animx.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170411003008.GA18538@animx.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 10 2017, Wakko Warner wrote:

> I have a question about shrinking an array.  My current array is 4x 2tb
> disks in raid6 (md0).  The array was created on the 2nd partition of each
> disk and spans most of the disk.  I would like to replace the 2tb disks w=
ith
> 750gb disks.  md0 is a luks container with lvm underneath.  I have less t=
han
> 1tb actually in use.  What would the recommended procedure be for shrinki=
ng
> this?  I've watched this list, but I don't think I've come across anyone
> actually wanting to do this before.
> I'm thinking of these steps already:
> 1) Shrink PV.
> 2) Shrink luks.  I'm aware that there is not size metadata, but the dm
> mapping would need to be shrunk.
> 3) Shrink md0.  I did this once when I changed a 6 drive raid6 into a 5
> drive raid6.  Would I use --array-size=3D or --size=3D ?  I understand the
> difference is the size of md0 vs the individual members.

You don't need --array-size, as reducing --size is non-destructive.
Reducing the number of devices *is* destructive, so if you were to do
that, you would need to adjust the --array-size first.

So when you have prepared the contents of the array, use
  mdadm /dev/mdXXX --grow --size=3D750G

or whatever size you think is appropriate.

Then check that all your data is still accessible.  e.g. fsck your
filesystem.
If you are confident that the data is still accessible, you can continue
to --replace devices.
If not, you can
  mdadm /dev/mdXXX --grow --size=3Dmax

to restore the previous state, and then try to figure out what went
wrong.

NeilBrown


>
> So for number 4, if md0 is now small enough, will it accept a member that=
 is
> smaller?  If so, I should beable to add the member to the array and issue
> --replace.
>
> Thanks.
>
> --=20
>  Microsoft has beaten Volkswagen's world record.  Volkswagen only created=
 22
>  million bugs.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljsXJQACgkQOeye3VZi
gbl3mRAApJWqITp2/3FAgMqBZVq9SCqoOXYDQduCfxpHNNjtCJGZbhL8WYFPGYO2
5lJfLIfavTJfSF8jsqEFHlYA9Vf0KyeENAgZ00QxWArllNXqIBZZ4zGtYkfn9mm7
Bkq+AGRQKEVFa2loJ3ASGIXB1ZyGCASZNT3/Nos+gk7Iny98GcUv7ll8r2TMcMnM
tckF6kip/h1ZaDY35m50Dz3aobfESnfPrKQ0vAzQI48lTU7Ayh05UFoa9Y0gqk+1
NWfhBq94pk/svKpCVZKiqv2Ij1tWdkjgI51PzFRhv0QSb/GKs3RmZ91k9gmVIkU9
PXwE3qmNIa4YYc+aBvr1dPujsm27cA+MZwU5bsmWpfHBhkWjykC8L68dWB5yW8bV
04nUA6wPr0uJw8iIvM+01bVHCca4HIyL1HF1YBAb7FRqHUfhz/vsgRzty9qaJ73r
Ovh2TCc5kWCQ37MyT8pK7AqZwEZyKCRei0OlqbndHWZQxaoXOO5+chhmiKbogi13
g3vzXZYGfnw9nenpJY02yWqxWaJfPDzVRw7b1rPr6aKNbmroa5O+sUJYZroongX4
RkRzoD7En88ZJN/VQyX553qyNVTe4ZRyvUGLf51blIutMWd5yNSNYSsgs0GAxSbb
FB3JfgBQGPjS6RDzB6RtjQZmHRKh7Ls6kABYs7pjVlhiND4HCKE=
=pjAG
-----END PGP SIGNATURE-----
--=-=-=--
