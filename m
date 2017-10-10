From: NeilBrown <neilb@suse.com>
Subject: Re: mdadm: Patch to restrict --size when shrinking unless forced
Date: Wed, 11 Oct 2017 07:48:55 +1100
Message-ID: <871smaybig.fsf@notabene.neil.brown.name>
References: <22997.8664.67459.119616@quad.stoffel.home> <87a81637lq.fsf@notabene.neil.brown.name> <23002.37193.492253.120639@quad.stoffel.home> <87shetz207.fsf@notabene.neil.brown.name> <23002.53075.413063.6948@quad.stoffel.home> <87h8v9yn91.fsf@notabene.neil.brown.name> <c476e0a8-ff57-e38d-f3d7-0c59242cc0b9@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c476e0a8-ff57-e38d-f3d7-0c59242cc0b9@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, John Stoffel <john@stoffel.org>
Cc: Eli Ben-Shoshan <eli@benshoshan.com>, Jes.Sorensen@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, Oct 09 2017, Phil Turmel wrote:

> On 10/09/2017 12:10 AM, NeilBrown wrote:
>
>> If there is some action that mdadm can currently be told to perform, and
>> when it tries to perform that action it corrupts the array, then
>> it is certainly appropriate to teach mdadm not to perform that action.
>> It shouldn't even perform that action with --force.   I agree that
>> changing mdadm like this is complementary to changing the kernel.  Both
>> are useful.
>
> A certain amount of the trouble with all of this is the english meaning
> of "grow" doesn't really match what mdadm allows.
>
> Might it be reasonable to reject "--grow" operations that reduce the
> final array size, and introduce the complementary "--reduce" operation
> that rejects array size increases?

While there is a lot to like about this approach, one problem is that
some "grow" operations do not change the size. They might, e.g., just change
the chunksize.

I guess you could have --grow --reduce --reshape.

I wouldn't object to such a change.

Thanks,
NeilBrown

>
> Both operations would share the current code, just apply a different
> sanity check before proceeding.
>
> mdadm would then at least not violate the rule of least surprise.
>
> Phil

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlndMjcACgkQOeye3VZi
gbmoNg//Y0nrNsnG7h95fEXRFeNMgUGs2NlHu1GX1f49/KvdNEpDWlFoQZgYtH3g
18ZK9XMr9RKK8BatuIok1CuAFl25HVhzNhkhE4d5Dm6Dq4Xjtm0dg4Oa7OFRA4A4
gkNgcSfjOIJNsXcNp/nTGsTfuCWm+mQUn2bCIDyRbXYIRLF7IW/C9/stl3lYw69h
1VJw3L3YDlz0QAOB53gpbFS/b/EOIZvv0BZ2CmKQjiw+tGHZ+WDp8b01si14poUE
5AEeakvkx3lh9BvctE1vehsO4mdFaxSiNE84+ttNI3iQetVbS8snh3jztwuDWme6
414AgzOjvbVhrWymJEAFNmroAHpG7zKZcLIMJ8Iz6BolSf7IowI8aJdqEX2iP2B5
Udec+FR2bd04SnvOHcqJXh7zfk6/292qG/qeE2h7aMsC2Ph/urY9+5pkZjf8r7se
B3r2BOWS06CjRIxP3JsZSfxk4FeRQWfbTLGr71Ao9WHXPHGCwH9Tk7H6zVrVtwbv
s7tny0SljvC2F/1lolmmDMwtfspgPqFR/2a5oTnPmw/D2LAmCQDzopXvP85qbb4f
XIF0F5QG+98+dx7JE8xXGKiDte5P+n0rXxvItD4FdWlkYR7j/qnSBIlA3YLZjGn2
7PzjbDZ5VdneI0lSZ8vDoD6yqBUVS25UlKcsV7ODNDvNfB45akw=
=YCbP
-----END PGP SIGNATURE-----
--=-=-=--
