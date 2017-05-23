From: NeilBrown <neilb@suse.com>
Subject: Re: 4.11.2: reshape raid5 -> raid6 atop bcache deadlocks at start on md_attr_store / raid5_make_request
Date: Tue, 23 May 2017 11:20:04 +1000
Message-ID: <871srgjrnf.fsf@notabene.neil.brown.name>
References: <87lgppz221.fsf@esperi.org.uk> <87a865jf9a.fsf@notabene.neil.brown.name> <87o9ukykmk.fsf@esperi.org.uk> <592336E6.8080906@youngman.org.uk> <87k258y65b.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87k258y65b.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, May 22 2017, Nix wrote:

> On 22 May 2017, Wols Lists verbalised:
>
>> aiui, provided you're using a v1 superblock, the data offset means there
>> is spare space on the drives precisely for the purpose (one of then at
>> least) of keeping a backup. So the reshape will start reshaping into the
>> spare space and eliminate the need for the backup - the new version of
>> the stripe will be safely written before the space occupied by the old
>> stripe is required.
>
> But it's only a few KiB by default! The amount of seeking needed to
> reshape with such a small intermediate would be fairly horrific. (It was
> bad enough as it was: the reshape of 7TiB took more than two days,
> running at under 15MiB/s, though the component drives can all handle
> 220MiB/s easily. The extra time was spent seeking to and from the
> backup, it seems.)

If the space before were "only a few KiB", it wouldn't be used.
You need at least 1 full stripe, typically more.
Current mdadm leaves several megabytes I think.

>
>> Typically, the new layout will move the data offset, pushing the data
>> block up or down.
>
> Will it? Why? You'd need to move the data offset quite a long way to
> make enough space for the 500MiB backup file I saw being created during
> my last reshape.
>
> (Though, for me, this is somewhat redundant:
>
>     Data Offset : 262144 sectors
>
> because I set a data offset specifically to allow reshaping without
> having to move anything. Is the idea that reshaping that adds data
> spindles will move the data offset such that it is (still) on a chunk or
> stripe multiple? That's neat, if so, and means I wasted 128MiB on this,
> uh, 12TiB array. OK I'm not terribly blown away by this, particularly
> given that I'm wasting the same again inside the bcache partition for
> the same reason: I'm sure mdadm won't move *that* data offset.)

Data offset is always moved by a multiple of the chunk size.
When I create a 12-device raid5 on 1TB devices, then examine one of them,
it says:

    Data Offset : 262144 sectors
   Unused Space : before=3D262064 sectors, after=3D0 sectors
     Chunk Size : 512K

so there is 130Megabytes of space per device, enough for 255 chunks.
When mdadm moves the Data Offset to allow a reshape to happen without a
backup file, it aims to use half the available space.  So it would use
about 60Meg in about 120 chunks or 720Meg total across all devices.
This is more than the 500MiB backup file you saw.

NeilBrown

>
> --=20
> NULL && (void)

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkjjkUACgkQOeye3VZi
gbnfhg//Q4DXE4/bBggaxpeAOrPmQy4J4kO7b8GarlmlV5zNJEA/prC2hk5ob8Gj
7h0DMzMcsKzo4tlhmN3JiLkx3wFXbbHF2dpv31tfBtSOxFRyepNzzqA8sMOQUuu4
SpnIAsqqsUJEo+RUpdHUw58W+pw0UVlI3RnOD+kH+f56pPM1xUA6aINr4Btgf81j
p+uL36vEHBV/FgrwUy1aUaT+ou8GMk7TBFl1fM2S4Umvasxk/CpIe4DPtbhdZg9Z
uRHF6yfJZ37BtKPqMDsHmlC5MS2CQkAb8/aBNTbfW6qJLpSZngLJrRgnhep9Y5Cy
cVFjrioHnVpibHFJ6ei1DOA1ulYMuiNxXqjHUO+oEJfYtI5JknpusePAGQ4UfNqr
t0jl2l5vmBeZqdJkqx540jv7P0w7YnMJ3njjcflnW1YhtNSzTJwl/GedrVnDvcNo
jPHGEnbSuQPMf2UCK0AaHqkaw+J8HOJkzuo9D9ZSvW8xFiIri3vLc3/n0foK/KjJ
xU6BjL8tWkzcrzUvsfRmUWyf6OXNaisOrqU8Y6RhZDc79qiKbH5RgfVp/kdYi00E
lPLj2VoZUEg4SeVjoBc5pdCY0HQ+Kan4itsX+H5LyPxzZdmEBJhcjvHbZXc28Cth
s4ztZSlbANr4djqf9bw9m6d+wj8AAZ1jb7fnIdjCxSLmTaRFKew=
=kk0l
-----END PGP SIGNATURE-----
--=-=-=--
