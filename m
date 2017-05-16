From: NeilBrown <neilb@suse.com>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 16 May 2017 13:20:08 +1000
Message-ID: <87h90lmqs7.fsf@notabene.neil.brown.name>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee> <590B3039.3060000@youngman.org.uk> <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee> <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk> <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee> <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk> <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org> <87vapb6s9h.fsf@esperi.org.uk> <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk> <87inla73vz.fsf@esperi.org.uk> <5911A371.3030008@hesbynett.no> <878tm65kyx.fsf@esperi.org.uk> <5911AED4.9030007@hesbynett.no> <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com> <59121C1C.1050101@youngman.org.uk> <CAJCQCtR0y-g+8dKC2-fykmFnOPKMA5YQs-Hku67c79SMECQrEg@mail.gmail.com> <59129BC1.2090005@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59129BC1.2090005@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Chris Murphy <lists@colorremedies.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, May 10 2017, Wols Lists wrote:

> On 10/05/17 04:53, Chris Murphy wrote:
>>=20
>> The data is already corrupted by definition. No additional damage to
>> data is done. What does happen is good P and Q are replaced by bad P
>> and Q which matches the already bad data.
>
> Except, in my world, replacing good P & Q by bad P & Q *IS* doing
> additional damage! We can identify and fix the bad data. So why don't
> we? Throwing away good P & Q prevents us from doing that, and means we
> can no longer recover the good data!
>>=20
>> And nevertheless you have the very real problem that drives lie about
>> having committed data to stable media. And they reorder writes,
>> breaking the write order assumptions of things. And we have RMW
>> happening on live arrays. And that means you have a real likelihood
>> that you cannot absolutely determine with the available information
>> why P and Q don't agree with the data, you're still making probability
>> assumptions and if that assumption is wrong any correction will
>> introduce more corruption.
>>=20
>> The only unambiguous way to do this has already been done and it's ZFS
>> and Btrfs. And a big part of why they can do what they do is because
>> they are copy on write. IIf you need to solve the problem of ambiguous
>> data strip integrity in relation to P and Q, then use ZFS. It's
>> production ready. If you are prepared to help test and improve things,
>> then you can look into the Btrfs implementation.
>
> So how come btrfs and ZFS can handle this, and md can't? Can't md use
> the same techniques. (Seriously, I don't know the answer.

Security theater?
I don't actually know what, specifically, btrfs and ZFS do, so I cannot
say for certain.  But I am far from convinced by what I know.

I come back to the same question I always come back to.  Is there a
likely cause for a particular anomaly, and does a particular action
properly respond to that cause.  I don't like addressing symptoms, I
like addressing causes.

In the case of a resync after an unclean shutdown, if I find a stripe in
which P and Q are not consistent with the data, then a likely cause is
that some, but not all, blocks in a new stripe were written just before
the crash.  If the array is not degraded, it is likely that the data is
all valid and P and Q are not needed.  So it makes sense to regenerate P
and Q.  Other responses might also make sense, but they don't make
*more* sense.  And regenerating P and Q is obvious and easy.  If the
array is degraded and a Data block is lost, there is no reliable way to
recover that block.  So md refuses the start the array by default.

If you find an inconsistent data block during a scrub, then I have no
idea what could have caused that, so I cannot suggest anything
(actually I have lots of ideas, but most of them suggest you should
replace your hardware and test your backups). Maybe there is a way to
recover data, maybe there is no need.  I cannot tell.  raid6recover is a
tool that can be used by a sysadmin to explore options.  Maybe not a
perfect tool, but it has some uses.

>                                                           But, like Nix,
> when I feel I'm being fed the answer "we're not going to give you the
> choice because we know better than you", I get cheesed off. If I get the
> answer "we're snowed under, do it yourself" then that is normal and
> acceptable.)

The main reason I have never implemented your idea of "validate every
block before reporting a successful read" is that I genuinely don't
think many people would use it.  Writing code that won't be used is not
very rewarding.
The simple way to provide evidence to the contrary is to turn the
interest into cash.  If 1000 people all give $10 to get it done, I
suspect we could make it happen.

>>=20
>> Otherwise I'm sure md and LVM folks have a feature list that
>> represents a few years of work as it is without yet another pile on.
>>=20
>>>
>>> Report the error, give the user the tools to fix it, and LET THEM sort
>>> it out. Just like we do when we run fsck on a filesystem.
>>=20
>> They're not at all comparable. One is a file system, the other a raid
>> implementation, they have nothing in common.
>>=20
>>=20
> And what are file systems and raid implementations? They are both data
> store abstractions. They have everything in common.
>
> Oh and by the way, now I've realised my mistake, I've taken a look at
> the paper you mention. In particular, section 4. Yes it does say you
> can't detect and correct multi-disk errors - but that's not what we're
> asking for!
>
> By implication, it seems to be saying LOUD AND CLEAR that you CAN detect
> and correct a single-disk error. So why the blankety-blank won't md let
> you do that!
>
> Neil's point seems to be that it's a bad idea to do it automatically. I
> get his logic. But to then actively prevent you doing it manually - this
> is the paternalistic attitude that gets my goat.

I'm certainly not actively preventing you.  I certainly wouldn't object
to a patch which reports the details of mismatches.  I myself was never
motivated enough to write one. That might be inactively preventing you,
but not actively preventing you.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkab+gACgkQOeye3VZi
gbml7RAAqP6LLo/xR2y3n0Ymhqz63Q2erfh4QBkkVJAH/VekEcF5BTUUh6ihGxIM
RdAz7PimnnN07iOj6jgXhajWnRRPmrQchJTfbnQ+GuwmbzefyJC5fWUYtjp8tft8
QgWTsXlQdfoburKGQB/rSQH9nMCaeETHi4imk6BiOrPyJ3clWG1cLJtPddlceh4m
SorTMOcpnmO/bckuFcFcZkIWjJdZIOzJRRt8/b4g754RnVv5B20GxVtV0lWB8K3w
/LqoghABsvcK0cV20wmSsE4P3E50Q8rhQ6EZ61jD2m/F/kiyLX4pZsZyc3B05f4E
IFcKPq5ybK3sDFsFXMJfkt19RiUm0T1ln60ri5nhUuYjDyw6T2ttxhqtxYOQk5H2
To21fya/CibEQN59Q0ur+GzZFupQ6G1AAwIYfRDeTr3kJ0AFEe2UoXrVVOT6CmBC
7XU0HxVcNwikGZ/qhyESwCBa5n9ymO0f1ciVT3O6RH5ySwtgrl19tGcy6TSe9xvq
excCtl7ackPj7tQ0AvNE5dA6jqa0vKQSY5gEgEoUKqCsRmmQNmbppk5ktu1vEPF1
F2q0/wwhFXRHltIsKwMUlALWVrYYgYcPkUodGWQd9m40/MAFnfdVltx2I4wabAHI
qP2pHKOdiMhbFnk6wY0Z88W8V1zwZ2vMmWbSQgsCZmc4ppmCTic=
=gC/4
-----END PGP SIGNATURE-----
--=-=-=--
