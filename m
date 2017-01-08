From: NeilBrown <neilb@suse.com>
Subject: Re: using the raid6check report
Date: Mon, 09 Jan 2017 09:39:14 +1100
Message-ID: <87pojxjhwt.fsf@notabene.neil.brown.name>
References: <14e8ec23-de4a-e90b-4b67-155e5e3cc228@eyal.emu.id.au> <20170108174010.GA3699@lazy.lzy> <5872A698.7000009@youngman.org.uk> <20170108214111.GA7933@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170108214111.GA7933@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Eyal Lebedinsky <eyal@eyal.emu.id.au>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 09 2017, Piergiorgio Sartor wrote:

> On Sun, Jan 08, 2017 at 08:52:40PM +0000, Wols Lists wrote:
>> On 08/01/17 17:40, Piergiorgio Sartor wrote:
>> > On Fri, Dec 23, 2016 at 11:56:34AM +1100, Eyal Lebedinsky wrote:
>> >> > From time to time I get non-zero mismatch_count in the weekly scrub=
. The way I handle
>> >> > it is to run a check around the stripe (I have a background job pri=
nting the mismatch
>> >> > count and /proc/mdstat regularly) which should report the same coun=
t.
>> >> >=20
>> >> > I now drill into the fs to find which files use this area, deal wit=
h them and delete
>> >> > the bad ones. I then run a repair on that small area.
>> >> >=20
>> >> > I now found about raid6check which can actually tell me which disk =
holds the bad data.
>> >> > This is something raid6 should be able to do assuming a single erro=
r.
>> >> > Hoping it is one bad disk, the simple solution now is to recover th=
e bad stripe on
>> >> > that disk.
>> >> >=20
>> >> > Will a 'repair' rewrite the bad disk or just create fresh P+Q which=
 may just make the
>> >> > bad data invisible to a 'check'? I recall this being the case in th=
e past.
>> > "repair" should fix the data which is assumed
>> > to be wrong.
>> > It should not simply correct P+Q, but really
>> > find out which disk is not OK and fix it.
>> >=20
>> Having just looked at the man page and the source to raid6check as found
>> online ...
>>=20
>> "man raid6check" says that it does not write to the disk. Looking at the
>> source, it appears to have code that is intended to write to the disk
>> and repair the stripe. So what's going on?
>
> There was a patch adding the write capability,
> but likely only for the C code, not the man page.
>
>>=20
>> I can add it to the wiki as a little programming project, but it would
>> be nice to know the exact status of things - my raid-fu isn't good
>> enough at present to read the code and work out what's going on.
>>=20
>> It would be nice to be able to write "parity-check" or somesuch to
>> sync_action, and then for raid5 it would check and update parity, or
>> raid6 it would check and correct data/parity.
>
> At that time, the agreement with Neil was to do
> such things in user space and not inside the
> md raid "driver" (so to speak) in kernal space.

This is correct.

With RAID6 it is possible to determine, with high reliability, if a
single device is corrupt.  There is a mathematical function that can be
calculated over a set of bytes, one from each device.  If the result is
a number less than the number of devices in the array (including P and
Q), then the device with that index number is corrupt (or at least, both
P and Q can be made correct again by simply changing that one byte).  If
we compute that function over all 512 (or 4096) bytes in a stripe and
they all report the same device (or report that there are no errors for
some bytes) then it is reasonable to assume the block on the identified
device is corrupt.

raid6check does this and provides very useful functionality for a
sysadmin to determine which device is corrupt, and to then correct that
if they wish.

However, I am not comfortable with having that be done transparently
without any confirmation from the sysadmin.  This is because I don't
have a credible threat model for how the corruption could have happened
in the first place.  I understand how hardware failure can make a whole
device unaccessible, and how media errors can cause a single block to be
unreadable.  But I don't see a "most likely way" that a single block can
become corrupt.

Without a clear model, I cannot determine what the correct response is.
The corruption might have happened on the write path ... so re-writing
the block could just cause more corruption.  It could have happened on
the read path, so re-writing won't change anything.  It could have
happened in memory, so nothing can be trusted.  It could have happened
due to buggy code.  Without knowing the cause with high probability, it
is not safe to try to fix anything.

The most likely cause for incorrect P and Q is if the machine crashed
which a stipe was being updated. In that case, simply updating P and Q
is the correct response.  So that is the only response that the kernel
performs.

For more reading, see http://neil.brown.name/blog/20100211050355

NeilBrown


>
> So, as far as I know, the kernel md code can
> check the parity and, possibily, re-write.
>
> "raid6check" can detect errors *and*, if only one,
> where it is, so a "data repair" capability is possible.
>
> bye,
>
> pg
>=20=20
>> Cheers,
>> Wol
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --=20
>
> piergiorgio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhyv5IACgkQOeye3VZi
gblFkxAAl7FjNaXlYkHnrNkEVgHSpEYSLzpw7T9BY05LoddhibOXquwSYeiodYOr
oXMvq8688UxF+isf1bbfYEsErbR79+HNaaSoPWAgtCDgL53Bvgd8vIRB35sKh3q0
Ryg6PQeic7RJyrMygTgg0s/0eounhFKYbfHiLI1HCfUd/XapU8iUdE1SFBCXom+U
+3lpDRUboS9bDPPhlrnzoTaogC4OW7feIRi00XQkV5/RCGN/itCQb1XLXSBLHyzB
rJ4ybFulKiBTR/U/SxRbeRUFTh/ElKbdqkQPgO52HvDr08la1o23l4Z02vJILVLs
bY+WvE8sp4/oxVvqeKzp1XIDk/yhAlX6Qlmxi/vcuX7H1h9ml8idlO8sul54p5x9
PuXQf0rRnrPRe4/3EiphTaPmFrcasena7VOi/u5wKFqfAePqQSUyzv2VKim03Dt+
THaCILMNdWxviPkzvXcL55gpyVCS5mzEowqmS62MD+Eh+osariI7FC7HEnhn18Fd
7tFN4SPpc8eNkPi9+OMmhfpefauvJp7ybxvNmFVUe5uCRtfHJnTy+9IRRT4/z/r5
QSbdpO4byXomND0yT5XkcP9fotUbF0btOVriMvToIKSIJsD7d92wvagN9SZu4CyB
ZboXPFwJ2a9fLS1OuHRVrojtFgs4QQ0EkXKJduE0k04+dbA1Bxo=
=6N9r
-----END PGP SIGNATURE-----
--=-=-=--
