From: NeilBrown <neilb@suse.com>
Subject: Re: raid0 vs. mkfs
Date: Wed, 30 Nov 2016 08:14:18 +1100
Message-ID: <87d1he7zv9.fsf@notabene.neil.brown.name>
References: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com> <87oa108a1x.fsf@notabene.neil.brown.name> <286a5fc1-eda3-0421-a88e-b03c09403259@scylladb.com> <87inr880au.fsf@notabene.neil.brown.name> <df73ebc4-9b78-09b5-022b-089c30dea17c@scylladb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <df73ebc4-9b78-09b5-022b-089c30dea17c@scylladb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Avi Kivity <avi@scylladb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 28 2016, Avi Kivity wrote:
>> If it is easy for the upper layer to break a very large request into a
>> few very large requests, then I wouldn't necessarily object.
>
> I can't see why it would be hard.  It's simple arithmetic.

That is easy to say before writing the code :-)
It probably is easy for RAID0.  Less so for RAID10.  Even less for
RAID6.


>
>> But unless it is very hard for the lower layer to merge requests, it
>> should be doing that too.
>
> Merging has tradeoffs.  When you merge requests R1, R2, ... Rn you make=20
> the latency request R1 sum of the latencies of R1..Rn.  You may gain=20
> some efficiency in the process, but that's not going to make up for a=20
> factor of n.  The queuing layer has no way to tell whether the caller is=
=20
> interested in the latency of individual requests.  By sending large=20
> requests, the caller indicates it's not interested in the latency of=20
> individual subranges.  The queuing layer is still free to internally=20
> split the request to smaller ranges, to satisfy hardware constraints, or=
=20
> to reduce worst-case latencies for competing request streams.

I would have thought that using plug/unplug to group requests is a
fairly strong statement that they can be handled as a unit if that is
convenient.


>
> So I disagree that all the work should be pushed to the merging layer.=20=
=20
> It has less information to work with, so the fewer decisions it has to=20
> make, the better.

I think that the merging layer should be as efficient as it reasonably
can be, and particularly should take into account plugging.  This
benefits all callers.

If it can be demonstrated that changes to some of the upper layers bring
further improvements with acceptable costs, then certainly it is good to
have those too.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlg976sACgkQOeye3VZi
gbn1chAAsnv3WGdAv7m+wsH1bl6xO1zVpRL1fjMHC1sod0uGwTrVa2QzC6SvWeHg
teNnoEapacf3MDftIi97BdYoJwOtZ5faEmu1FkMjHfsRPagdj0RtkoUY468ZfgJm
VSIlImTXTzukXO09v13/EVDkHkPyD0V++Ik+4In4pkepLdUc0x8wzdDcr6N/j3CC
oeAFL7LaIO4t7p5F7anMwV5pRGtQeMTiBOT0GkbcEUMEyzwfYiGYWbMw47cLA6wY
ksmzCDD7+CERiHzc4tXuSTP3gnUnKrpL+8CooVoTmCmYOrg0Nc8ZswWYgwj3Wzpf
rfgKo8+m9jL67zKUhxxWJbbSKmPucr/8m069pX/+1H7LxvKZ9aPrEu/XdhQuBvpE
V4tsUTqxJ3GLtCKp0Sas9LC6KPaDXPw4k9biFKFcpEJKM/tnYbOQ/c0ci1mFxKmd
C32navJem6+4ykwvlIB7AQC9HjadY2RJlZ7kxtrYp8/AXgn+0qA65Vp5kFHRnVBX
e5y9sHhcVbQGI6/GRwwb+nGvJi+5c6oz3ymR0Pc20Y4vamrePZyBEbHP990hcMni
CMwTUP+Qv8sSUxjUw6c3qQ8u1L19sPXva3JzyvTo3S0zHAyB+c0KAQbvaaic56r7
MCDucCog8LWHN4LqR/sWAL29jsSu9KgCyqJjVZ0dGPpK6erk+aw=
=OBX9
-----END PGP SIGNATURE-----
--=-=-=--
