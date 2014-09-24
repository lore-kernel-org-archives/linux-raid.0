From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/5] Fixes for RAID1 resync
Date: Wed, 24 Sep 2014 14:49:31 +1000
Message-ID: <20140924144931.5f9f5fcd@notabene.brown>
References: <20140910062039.26400.36745.stgit@notabene.brown>
	<D96E0116-919C-4F4B-B4B6-2564B99449FB@redhat.com>
	<8697EC47-F648-4E66-B37C-4A2DC3030696@redhat.com>
	<20140915133006.14e57085@notabene.brown>
	<2C41CCF8-8B5C-486F-AE43-42D10EBAA0A5@redhat.com>
	<20140918174846.6a445eaf@notabene.brown>
	<398DA7BB-7BED-49E0-8178-0CA4384E8A84@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Xqe5ickHUXTzawdOppeeoGL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <398DA7BB-7BED-49E0-8178-0CA4384E8A84@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: Eivind Sarto <eivindsarto@gmail.com>, linux-raid@vger.kernel.org, majianpeng <majianpeng@gmail.com>
List-Id: linux-raid.ids

--Sig_/Xqe5ickHUXTzawdOppeeoGL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Sep 2014 23:25:12 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:


>=20
> Sorry, still not there yet.

No??  I was *sure* I had it that time!

>=20
> I'm sorry I haven't had more time to spend on this.  I'll try to get some=
 help (perhaps from Heinz) and see if we can pitch-in instead of making you=
 do all the work.

Could you include /proc/PID/stack for the two md kernel threads?  They are
unlikely to differ from what we have seen before but as they are the
strongest pointer to where the problem is, I like to be able to see them :-)

Also I'd like to see the disassembly of raise_barrier() just to be certain
which of the two 'wait's it is waiting in.

One thing that might be useful is to change the various wait_event_lock_irq=
()
calls to wait_event_lock_irq_cmd() with an extra argument 'dotrace(conf)'
where dotrace() is a new function that first calls
   schedule_timeout(60*HZ);
and then if that returns 0, prints out all fields that might be of interest.
Also get it to print which 'wait' it was called from (e.g. pass a string to
dotrace).

Thanks,
NeilBrown

--Sig_/Xqe5ickHUXTzawdOppeeoGL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCJNWznsnt1WYoG5AQIv9g//QcZLdgT2ITRoRa0AaiHPd5fQj9u0RYhR
D4LPtd9Wg19AseOQf3TvFml6MmNl4eSP2eVPmLowDHdLD/6dYehBn+Ef8ldJSoVK
2heKmDKKkPf3lHB3cJ38QVlQv53bb1gp7n1squZF7oUnLMomE1b5Gw4V2J1eqP5v
r4edcKObL4MHwGCY+xMX1+4OoPxEVhJj605/jfPx80EMb4ugDaMvPbEOAiQS7COA
7ByD5MkR3yunJNkF9xTwQm6ZaU8o6KUdZTsR1wYdJZQT1t8Pzm7ALqABik0J9cql
Gv7OSwjY863NGqHE0mkmVwI0h3HhDQ/f+k9DfpzaJUOjoPifSCwfI3W5EWO9WRbM
odEPfvsXWaPNet8t1wufV6o46tpTqmObM4OrW2kI94J7E2GTz5H9NiACCyhVhlRM
y7sHFh9dillYyM2I6+G/hutjww9crBT66Tpm9ozmfv0KbfPHv7qZLL/mmhBvn2II
tQ8+h70gxGF/6R5MwcfX4fUJYIr2CHVWST926doAR/9m6sBfhISYwjXcDB3+zEUd
wXEhTL2BZivrHOt5sOT/XsI7CC2+LcW16PorFjtpBYheivnQmG1rpihVl1iwZ+xX
1OsYTwCZ1vu/mfxn/idztT+4dAlBnXLQTj/MjiaQSeng7VX1a+HT1qGPvgJsSBSk
aJ4kUhbN9qU=
=zeLu
-----END PGP SIGNATURE-----

--Sig_/Xqe5ickHUXTzawdOppeeoGL--
