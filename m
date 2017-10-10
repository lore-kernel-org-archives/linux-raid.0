From: NeilBrown <neilb@suse.com>
Subject: Re: mdadm: Patch to restrict --size when shrinking unless forced
Date: Wed, 11 Oct 2017 07:52:28 +1100
Message-ID: <87y3oiwws3.fsf@notabene.neil.brown.name>
References: <22997.8664.67459.119616@quad.stoffel.home> <87a81637lq.fsf@notabene.neil.brown.name> <23002.37193.492253.120639@quad.stoffel.home> <87shetz207.fsf@notabene.neil.brown.name> <23002.53075.413063.6948@quad.stoffel.home> <87h8v9yn91.fsf@notabene.neil.brown.name> <c476e0a8-ff57-e38d-f3d7-0c59242cc0b9@turmel.org> <20171010000702.GA6038@animx.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171010000702.GA6038@animx.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>, Phil Turmel <philip@turmel.org>
Cc: John Stoffel <john@stoffel.org>, Eli Ben-Shoshan <eli@benshoshan.com>, Jes.Sorensen@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 09 2017, Wakko Warner wrote:

> Phil Turmel wrote:
>> On 10/09/2017 12:10 AM, NeilBrown wrote:
>>=20
>> > If there is some action that mdadm can currently be told to perform, a=
nd
>> > when it tries to perform that action it corrupts the array, then
>> > it is certainly appropriate to teach mdadm not to perform that action.
>> > It shouldn't even perform that action with --force.   I agree that
>> > changing mdadm like this is complementary to changing the kernel.  Both
>> > are useful.
>>=20
>> A certain amount of the trouble with all of this is the english meaning
>> of "grow" doesn't really match what mdadm allows.
>>=20
>> Might it be reasonable to reject "--grow" operations that reduce the
>> final array size, and introduce the complementary "--reduce" operation
>> that rejects array size increases?
>>=20
>> Both operations would share the current code, just apply a different
>> sanity check before proceeding.
>>=20
>> mdadm would then at least not violate the rule of least surprise.
>
> As a general user of md raid and as a reader of the list, I would agree t=
hat
> this would be a better solution.  Thinking in terms of lvm, there's lvred=
uce
> and lvextend.  IMO, --force wouldn't be needed for --reduce (I was orgina=
lly
> thinking of --shrink)
>
> On a side note, is it possible for the lower layers to know what the last
> used sector is?  IE lvm ontop of raid and has 10% allocated and the last
> sector is around the 10% mark.  (If this were possible --force would be,
> required if shrinking would result in inaccessible data)

No it isn't.  I've occasionally thought of adding functionality so that
the a device could ask its client (e.g. filesystem, lvm, etc) if
shrinking is OK - but it hasn't happened yet.

>
> I recently did a shrink of 4x 2tb drives so that I could replace the 2tb
> drives with 80gb drives (yes, big shrink!)  Would have been nice for mdadm
> to know the smallest size was that wouldn't destroy my lvm volumes that w=
ere
> on top.

Guess, try, see if data is still accessible.  If not, revert the change.
If you have a filesystem on the raid, fsck will complain if you made it
too small.  I don't know what you would try with lvm.  pvscan?

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlndMwwACgkQOeye3VZi
gblOPg//VnSoPY06V+qRms+I/b+rb6NfGc8XWfcXVOk5lm3d834jfQfxKUEDnM/I
BDWKrrVaeWkB42Dmb927r4ZRujL4jwpd8ZzdAHO58mjKe27Ru2u+X+hoZ6I5tFQy
gmVAexTeKtOxrgiuPOOE0Q44cN5UXWV/L5pdKqtUGHrNj0wx678zz1XY1myGWo4w
zhmMYa/IzA5UaF81b3JZ34Y91XopWuLqRXTwXDW6woIuwcheP82Y0FsCMYwzq6CK
t8Kedg6JAs6Nfn4XyunPLixKL3trtBiEv94O5mCnTZVn7T3yE9XjWdqguVg38Zgm
AvKn3wNlaZuRjvWJtN17DYBWc9VnPS2S66Ae1P+lZo4TGtppau5DticHS46bJwxf
KvZqhr3gNDyqKVp5BrY+UgVnIPRYYdx7RJQjpygIXLA/tL0Gas7hKzU0NaH/a0pP
326wqqR8jaQYTaXBdNJJUmiBs4LTnZMNcqRAw/epXedO+zKQrbwHSTaeEgkQC0/A
T9ryanaDj+vH/qyKnQzveREHdsgHr7xmMu4MVYXnBWP9s3sCViTSsuXnoamHfyKD
CB21ECjef2rJFi6WuAN04CUyvctSn9JsSG69GMvghYv6DrgjNnNIvppVi/KYzBoa
Czn+Hzmg6SQJoxbelaeXedjCviuqcbNfUlqNMjkDMXR+EghhDCI=
=zB82
-----END PGP SIGNATURE-----
--=-=-=--
