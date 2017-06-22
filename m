From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: make suspend range wait timed out
Date: Fri, 23 Jun 2017 07:54:27 +1000
Message-ID: <87fuer1yek.fsf@notabene.neil.brown.name>
References: <d95473d287e196a86a83390cb9c136913643bd61.1497037210.git.shli@fb.com> <877f0c7gvr.fsf@notabene.neil.brown.name> <20170616155204.myffyxp5tuoctcoo@kernel.org> <87vant3rw5.fsf@notabene.neil.brown.name> <20170620005443.hil23ffizavctgkq@kernel.org> <alpine.LRH.2.02.1706211007560.29243@file01.intranet.prod.int.rdu2.redhat.com> <20170621160704.xyiy6fea4rokag72@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170621160704.xyiy6fea4rokag72@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 21 2017, Shaohua Li wrote:

> On Wed, Jun 21, 2017 at 10:09:08AM -0400, Mikulas Patocka wrote:
>>=20
>>=20
>> On Mon, 19 Jun 2017, Shaohua Li wrote:
>>=20
>> > > Write errors only get back to the application if it calls fsync(), a=
nd
>> > > many don't do that.  Write errors can easily cause a filesystem to go
>> > > read-only, and require an fsck.  I think we should be very cautious
>> > > about triggering write errors.
>> > >=20
>> > > NFS will hang indefinitely rather then return an error if the server=
 is
>> > > not available.  That can certainly be annoying, but the alternative =
has
>> > > been tried, and it leads to random data corruption.
>> > > The two cases are only comparable at a very high level, but I think
>> > > this result should encourage substantial caution.
>> >=20
>> > It's hard to say if an IO error or an infinite wait is better, but sin=
ce there
>> > is better option in this case, I don't want to argue. I'll repost a pa=
tch to
>> > reset suspend range after a timeout, assume this is your suggestion.
>> >=20
>> > Thanks,
>> > Shaohua
>>=20
>> Automatically resetting the suspend range could result in data corruptio=
n,=20
>> so it is even worse than a deadlock.
>
> depending on how you look at this. a deadlock means you will eventually h=
ard
> reset the system, and that will result in data corruption.

But in that circumstance (purely hypothetical at this stage) the
sysadmin knows that something has gone wrong.  In the other, they might
not.
Invisible data corruption is much worse that visible.

The suspend functionality is used by user-space programs.  If you think
the current interface is not ideal, maybe it would be better to design
an interface that a user-space program can use which is safe to use, but
also fails safe.  Maybe it could give the kernel a PID with the meaning
"if you have to invalidate my suspend request, please kill the pid
first".  That would have risks of its own of course.

The suspend interface is currently used:
 - to enable backup of a region which it is being reshaped in-place.
   As time goes on, this will be used less and less as the
   change-data-offset approach to reshape doesn't need this.
 - to stablise a region while raid6check performs parity calculations
   and possibly "corrects" one block.

You at least need to analyse the failure modes of these before you can
justify making any change to the interface they use.
But again, I really don't think there is a problem that needs fixing.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllMPJUACgkQOeye3VZi
gbmYmxAApRcFggd1TcBTB5clpwhgFjBeUnbpmnaZDUO3XhGl9amPCCodY5JAD0QH
xu8F4mjCm6LkOs2hoBZxFy83NpbEsNMIUBoHQd5eMS7zE+o7qiA+3cJmctue1zXc
7MEGcNLusJPnXYbNPu5a5+i4ITDhAk0u37mNEOmveDrdc6OtnYq+PZtkngG/hhVN
a8IqntDvwZMUv9src8VwvKuiRIYpfnGQfx0iWRBS7VFXtCRgEu/bujJHYTcNCOv4
r97wiahnO5/gBcjh5tCK8eA4YEVn+qtvKAerYwHNiwlGASYV3HbqxU2V7JP0EbXN
P65SUyIK721aPBah5txzlKX0bTP1uOJmDd7pI6uDtKAfRy4K3ialee6xaWCePMEc
jE6Zjvfjwh66W0qgBFiBb26EnpwPibQ7AH0wfWgu6iBJETnGOhoWuuxX3c7tbVfQ
baeiTn3FuqmtHfy87TPQ3mEvD6pusLHLmDjBCUk610QEJk8VE6ETDPLwnJm95DiW
TLoONXKT46K/JEoMqPE2vA0YY7iJDC4Q7FpQanmwm8gLI/3TJJqi0qRmWZIF2CY7
7ADQtNxYctdxrM3PfAIpMb7rjf8PAIsc8a4hSt9W59/SjkZir+CBh2ocrBkwk1wI
B7/5HIo7AMhtkqnb9iDytNy8HVH/2EHGVNKWEKGPijKZ5jFJ6gQ=
=wA6z
-----END PGP SIGNATURE-----
--=-=-=--
