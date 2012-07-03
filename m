From: Robert Buchholz <robert.buchholz@goodpoint.de>
Subject: Re: Find mismatch in data blocks during raid6 repair
Date: Tue, 03 Jul 2012 21:10:41 +0200
Message-ID: <2116390.poR22k1RqP@peanut>
References: <10900468.MPSjVn2C3J@peanut> <1436304.MN64neqUEr@peanut> <20120630114831.GA3034@lazy.lzy>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2581971.mImcTlUjuA"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120630114831.GA3034@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--nextPart2581971.mImcTlUjuA
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hey Piergiorgio,

On Saturday, June 30, 2012 01:48:31 PM Piergiorgio Sartor wrote:
> > the tool currently can detect failure of a single slot, and it
> > could automatically repair that, I chose to make repair an
> > explicit action. In fact, even the slice number and the two slots
> > to repair are given via the command line.
> > 
> > So for example, given this output of raid6check (check mode):
> > Error detected at 1: possible failed disk slot: 5 --> /dev/sda1
> > Error detected at 2: possible failed disk slot: 3 --> /dev/sdb1
> > Error detected at 3: disk slot unknown
> > 
> > To regenerate 1 and 2, run:
> > raid6check /dev/md0 repair 1 5 3
> > raid6check /dev/md0 repair 2 5 3
> > (the repair arguments require you to always rebuild two blocks,
> > one of which should result in a noop in these cases)
> 
> Why always two blocks?

The reason is simply to have less cases to handle in the code. There's 
already three ways to regenerate regenerate two blocks (D&D, D/P&Q and 
D&P), and there would be two more cases if only one block was to be 
repaired. With the original patch, if you can repair two blocks, that 
allows you to repair one (and one other in addition) as well.

> > Since for stripe 3, two slots must be wrong, the admin has to
> > provide a
> Well, "unknown" means it is not possible to detect
> which one(s).
> It could be there are more than 2 corrupted.
> The "unknown" case means that the only reasonable thing
> would be to rebuild the parities, but nothing more can
> be said about the status of the array.
> 
> Nevertheless, there is a possibility which I was thinking
> about, but I never had time to implement (even if the
> software has some already built-in infrastructure for it).
> Specifically, a "vertical" statistic.
> That is, if there are mismatches, and, for example, 90% of
> them belong to /dev/sdX, and the rest 10% are "unknown",
> then it could be possible to extrapolate that, for the
> "unknown", /dev/sdX must be fixed anyway and then re-check
> if the status is still "unknown" or some other disk shows
> up. If one disk is reported, then it could be fixed.
> Other cases, the parity must be adjusted, whatever this
> means in terms of data recovery.
> 
> Of course, this is just a statistical assumption, which
> means a second, "aggressive", option will have to be
> available, with all the warnings of the case.

As you point out, it is impossible to determine which of two failed 
slots are in error. I would leave such decision to an admin, but giving 
one or more "advices" may be a nice idea.

Personally, I am recovering from a simultaneous three-disk failure on a 
backup storage. My best hope was to ddrescue "most" from all three disks 
onto fresh ones, and I lost a total of a few KB on each disk. Using the 
ddrescue log, I can even say which sectors of each disk were damaged. 
Interestingly, two disks of the same model failed on the very same 
sector (even though they were produced at different times), so I now 
have "unknown" slot errors in some stripes. But with context 
information, I am certain I know which slots need to be repaired.

> > guess (and could iterate guesses, provided proper stripe backups):
> > raid6check /dev/md0 repair 3 5 3
> 
> Actually, this could also be an improvement, I mean
> the possibility to backup stripes, so that other,
> advanced, recovery could be tried and reverted, if
> necessary.

That is true. I was thinking about this too. Unfortunately, as I 
remember, the functions to save and restore stripes in restripe.c do not 
save P and Q, which we should in order to redo the data block 
calculation. But with stripe backups, one could even imagine doing 
verifications on upper layers -- such as verifying file(system) 
checksums. I may send another patch implementing this, but I wanted to 
get general feedback on inclusion of such changes first (Neil?).


> Finally, someone should consider to use the optimized
> raid6 code, from the kernel module (can we link that
> code directly?), in order to speed up the check/repair.

I am a big supporter of getting it to work, then make it fast. Since a 
full raid check takes the magnitude of hours anyway, I do not mind that 
repairing blocks from the user space will take five minutes when it 
could be done in 3. That said, I think the faster code in the kernel is 
warranted (as it needs this calculation very often when a disk is 
failed), and if it is possible to reuse easily, we sure should.


Cheers,

Robert

--nextPart2581971.mImcTlUjuA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABCgAGBQJP80OxAAoJECaaHo/OfoM5HtQP/RiEp4oM/p1zK5jMDXbrA7br
1fsERIDZH0PoD9oPqMCqslJQRfGxF2eiJidZcRom9/B6nQnI+rMJs81M/ZQE9q59
kYmbxMLxqJzdGtsjMLz0SntAeQv71xkzeRQSqIZM6dUBVOJNmgc/zbcaRQWJTq78
A0yl1WDExPZdTsWppZ2dAF52+WBoahrZ7zKR5S+7HISvPmBbOdAybMrzS/J/++Kw
Mhe9WUBAosiYrwIZ363AZYaz0IH4PgwPdV6k5z7yIM4PggOAgT7fnKrm8AQELiFz
exebH4KW21jG0TD1UioBk/6L4MGpMnI7rg0FDHgZ0a/k7xoH1cYRzg2AO8kjl6u0
VHPlM2EXcqrsBNrSMbuV6m17KKqas5eGjBSoNdDn8orKU3ypGhBpEEP8ZHCxVBO3
AEJzGVgFhNgk7xWFIOP0b6uejex9EOKp6Ug2HK4nCoy7MUE9jO4Ma+cBPz/AUznQ
Ah3acPQwAFMsF6IZFu3ZSA+x1SwMClY4vfbYSaKgSB4uLQlb7k6kqC1w9DtPICTP
s1zzfcAz+4GLh195ZG6JFt+ZJc8Y3qQLGL7MQVPrY6KnyWdCZ7zb0NLn0Qpksqm3
3Vcd6GXZkVp+p42aaB1ARm3JSmLtBBBPIOaAlBoMpwtOfAGjiZSIhw1LuUfRvVic
oqVTNp5BIK7wuRLWqj0Z
=Lwqe
-----END PGP SIGNATURE-----

--nextPart2581971.mImcTlUjuA--

