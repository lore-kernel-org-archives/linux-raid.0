From: NeilBrown <neilb@suse.de>
Subject: Re: Suspicious test failure - mdmon misses recovery events on loop
 devices
Date: Mon, 29 Jul 2013 16:55:50 +1000
Message-ID: <20130729165550.53c33bf3@notabene.brown>
References: <51F2E2DD.8090204@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rRt2J.ide=wqdN.9LOsrHOe"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F2E2DD.8090204@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/rRt2J.ide=wqdN.9LOsrHOe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 26 Jul 2013 22:58:05 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> Hi Neil, everybody,
>=20
> I am currently pulling my hair over strange failures I am observing. I
> was trying to create a new unit test for DDF along the same lines as
> 09imsm-create-fail-rebuild. That's of course a very important test -
> making sure that an array can actually recover from a disk failure.
>=20
> The script does just that - create a container with 2 subarrays, fail a
> disk, add a spare, and expect everything to be recovered after that.
>=20
> What I find is that the recovery actually works, but sometimes the meta
> data is broken after the test has finished. The added disk is shown in
> "Rebuilding" state and/or one or both subarrays are considered
> "degraded" although the kernel log clearly shows that the recovery
> finished. The problem occurs almost always if the test is done on loop
> devices, as in mdadm's "test" script. Just did another test, failed
> 10/10 attempts on loop devices. If I use LVM logical volumes instead (on
> the same physical disk), the test never fails (0/10).
>=20
> In the success case, the script prints only one line (its log file). In
> the bad case, it will print some more lines of mdadm -E information. The
> log file contains all the details.
>=20
> I have come to the conclusion that if the failure occurs, mdmon simply
> misses one or more state changes of the arrays and/or disks. For mdmon
> to notice that the recovery has finished, it is crucial to see a
> situation where sync_action is "idle", and had been "recover" before,
> for both subarrays. This happens if I run the test on LVM, but not if I
> run it on a loop device.
>=20
> Thinking about it - what guarantee is there that mdmon catches a certain
> kernel status change? If I read the code correctly, mdmon will only
> catch it if
>  (a) the status change occurs while mdmon is in the select() call, and
>  (b) the status in sysfs doesn't change again between the return from
> select() and mdmon reading the sysfs file contents.
>=20
> I can see no guarantee that this always works, and with my loop device
> test case I seem to have found a scenario where it actually doesn't. I
> suppose that mdmon may be busy writing the DDF metadata while the kernel
> event about finished recovery is arriving.
>=20
> My first idea was that the the cause were the loop devices on my CentOS6
> kernel not supporting O_DIRECT properly (recovery finishes almost
> immediately in the page cache, perhaps too quickly for mdmon to notice),
> but running a more recent kernel with proper O_DIRECT in the loop
> device, I still see the problem, although the recovery takes longer now.
>=20
> There is still a chance that I messed something up in DDF (I haven't
> seen the problem with IMSM), but it isn't likely given that the test
> always works fine on LVM. I am pretty much at my wit's end here and I'd
> like to solicit some advice.
>=20
> I'd definitely like to understand exactly what's going wrong here, but
> it's very hard to debug because it's a timing issue involving the
> kernel, mdadm, mdmon, and the manager. Adding debug code changes the
> probability to hit the problem
>=20
> Thanks for reading this far, I hope someone has an idea.

Hi Martin.

 I don't think the state change needs to happen while mdmon is in the select
 call.  It just need to happen between one call to read_and_act, and the ne=
xt.
 And everything happens between one call and the next...

 If sync_action is 'recovery' one time and then something else that isn't
 'idle' the next time, then that would cause the transition to get lost.
 Can that ever happen?  Do you see a particular transition that bypasses
 'idle'?
 It is possible there is some race here...

 I'll try out your test script can see if I can reproduce  it.



>=20
> Martin
>=20
> PS: In that context, reading mdmon-design.txt, is it allowed at all to
> add dprintf() messages in the code path called by mdmon? That would also
> affect some DDF methods where I currently have lots of debug code.

Yes, you can have dprintf messages anywhere.  However if debugging is
enabled, then I don't promise that mdmon will even try to survive low memory
conditions.

NeilBrown

--Sig_/rRt2J.ide=wqdN.9LOsrHOe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUfYR9jnsnt1WYoG5AQJeAA//T5GrVv5fZVKN5yYHj2+HSEMSDFMk8Gb6
2xWuPqW5j/WT5W0zS/8DPqa65bpLtIXxd3AnE6OUs8pGAdWMPfYcPveOdDUuHNwe
hBjqawnRXVJ8EtBUbFRWMjPuDu3yGWGlzngTIW+lHCRc/UC5lEMx/WPmzOP+fbpA
z9o0ZCVBZBqAAwp5X8FDUM2OwHd5MdSA3uKDvnC/TrxqEgXtaCmC6LHY9SHOOq3G
Nmoxf4cxZ4eb6oo/4MUrqDWmn3NQnSEIXcFO4cv/eeHTxJpsRqpWhfDv/DJxw+i6
aqpnnxA1xoyCPUvc1HHkM8NvIF8DuR/G1IN10p2NDVkil8u4lWVgWgYeL+W75XoM
/Lk9XFzCWS3316yNDkw0KvMtoSNKrQkot4RN3uxKl4rPH8jextIOBXpfwlAAjkIs
WO/kUj0hjNLJ8hlSypQRFrz/sfmkD/KBqrLSGc0y3qrMdF5U/XeM1rfnRUMnq+nk
YlhGYFNQomXOSxS4ClqNTGQFpvHGlL1MslQC7MaGB5pacfo3PeEgX2BQWWVRSBbQ
5R+hxSZ+sEc0y12R1f2JR8Gkf8ofQ5fq7JfQRe/P4jsH2XWde4ZSkCHmh1qePZZC
RRl+22AzTUOF9V0ni7KuGC/iP3Zgkh36BUbZXz/aNSWppKGgV0/1hdVuKfOLzflL
WSDn60yKG04=
=dKzX
-----END PGP SIGNATURE-----

--Sig_/rRt2J.ide=wqdN.9LOsrHOe--
