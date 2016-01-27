From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH/RFC/RFT] md: allow resync to go faster when there is competing IO.
Date: Wed, 27 Jan 2016 12:12:53 +1100
Message-ID: <8760yf3jvu.fsf@notabene.neil.brown.name>
References: <CAByoP04f6YgzhXn+55iEpg0SrVnK3mUxOuEfp-Hki_mppOBieg@mail.gmail.com> <87si1k2do8.fsf@notabene.neil.brown.name> <20160126225222.GA29409@kernel.org> <87mvrs2b2a.fsf@notabene.neil.brown.name> <20160126232731.GA12721@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160126232731.GA12721@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Chien Lee <chienlee@qnap.com>, linux-raid@vger.kernel.org, owner-linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 27 2016, Shaohua Li wrote:

> On Wed, Jan 27, 2016 at 10:08:45AM +1100, Neil Brown wrote:
>> On Wed, Jan 27 2016, Shaohua Li wrote:
>>=20
>> > On Wed, Jan 27, 2016 at 09:12:23AM +1100, Neil Brown wrote:
>> >> On Tue, Jan 26 2016, Chien Lee wrote:
>> >>=20
>> >> > Hello,
>> >> >
>> >> > Recently we find a bug about this patch (commit No. is
>> >> > ac8fa4196d205ac8fff3f8932bddbad4f16e4110 ).
>> >> >
>> >> > We know that this patch committed after Linux kernel 4.1.x is inten=
ded
>> >> > to allowing resync to go faster when there is competing IO. However,
>> >> > we find the performance of random read on syncing Raid6 will come up
>> >> > with a huge drop in this case. The following is our testing detail.
>> >> >
>> >> > The OS what we choose in our test is CentOS Linux release 7.1.1503
>> >> > (Core) and the kernel image will be replaced for testing. In our
>> >> > testing result, the 4K random read performance on syncing raid6 in
>> >> > Kernel 4.2.8 is much lower than in Kernel 3.19.8. In order to find =
out
>> >> > the root cause, we try to rollback this patch in Kernel 4.2.8, and =
we
>> >> > find the 4K random read performance on syncing Raid6 will be improv=
ed
>> >> > and go back to as what it should be in Kernel 3.19.8.
>> >> >
>> >> > Nevertheless, it seems that it will not affect some other read/write
>> >> > patterns. In our testing result, the 1M sequential read/write, 4K
>> >> > random write performance in Kernel 4.2.8 is performed almost the sa=
me
>> >> > as in Kernel 3.19.8.
>> >> >
>> >> > It seems that although this patch increases the resync speed, the
>> >> > logic of !is_mddev_idle() cause the sync request wait too short and
>> >> > reduce the chance for raid5d to handle the random read I/O.
>> >>=20
>> >> This has been raised before.
>> >> Can you please try the patch at the end of=20
>> >>=20
>> >>   http://permalink.gmane.org/gmane.linux.raid/51002
>> >>=20
>> >> and let me know if it makes any difference.  If it isn't sufficient I
>> >> will explore further.
>> >
>> > I'm curious why we don't calculate the wait time. Say the target resyn=
c speed
>> > is speed_min. The wait time should be:
>> >
>> > (currspeed * SYNC_MARK_STEP - speed_min * SYNC_MARK_STEP) / speed_min
>> > =3D (currspeed / speed_min - 1) * SYNC_MARK_STEP
>> >
>> > if SYNC_MARK_STEP is too big and sync speed has drift, we can make it =
smaller.
>>=20
>> What do you hope this would achieve?
>
> The whole point is to throttle sync speed to specific speed. If we know t=
he
> target speed, for any given time interval, we can calculate the sync
> IO size.

Actually, no.  The main point is to not interfere with filesystem IO too
much.  Limiting to a low target is a fairly poor way to do that (but is
all we have) and as there is such a wide range of device speeds it is no
longer possible to choose a sensible default.

>=20=20
>> If I understand correctly, this might allow the thread to sleep for
>> longer instead of looping around every 500ms or so.  But we don't really
>> want to do that.  As soon as filesystem IO pauses, we want resync IO to
>> go back to full speed.
>>=20
>> The "speed_min" isn't really a "target".  It is only a "target" for
>> those times when there is no filesystem IO.
>
> Yep, target is a little bit hard to determine. I think we can do:
> if (curspeed > min) {
> 	if (!is_mddev_idle())
> 		targetspeed =3D minspeed;
> 	if (curspeed > max)
> 		targetspeed =3D maxspeed;
> 	sleep(max((currspeed / targetspeed - 1), 0) * SYNC_MARK_STEP)
> }
>
> This way we don't throttle if there is no filesystem IO. would this
> work?

But if there is filesystem IO, then we throttle for at least 3 seconds
(SYNC_MARK_STEP is 3*HZ).  The filesystem could go idle in 1 second and
then we would spend 2 seconds pointlessly doing nothing.  We could make
SYNC_MARK_STEP smaller, but if recent speed had been high we could still
throttle for a lot longer than needed.

Before the patch that caused the regression we would throttle for 500ms,
so if the filesystem went idle we would waste at most 500ms.
After the patch, we throttle until pending requests have completed.
This causes the delay to scale with the speed of the device, but doesn't
seem to be enough of a delay in some cases.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWqBmVAAoJEDnsnt1WYoG5Yg4P/0FTo6XzLJDrdRVLYw8oEdUy
CylmMPJXbCOW7iXtP+asvHQe/8wBCiIp3X2bVW5kmcybDBHbv80GpAbUouIFiYAI
VJ+iQbafzAAlq4o31YXn5faCCtTw/zuhe8Y7OwQDMMt9fx39g4Or3mqlkegFt0hb
Yb8M1vvarvRNM/Oo0PHu1vPYQab7aMeSGn2l8zAm7iGZoDb48ss6qsm31S0m5KZP
AudjTv8Xe486AJQmRGeK1PFZ4J21jgWA/T+8AxG+jRmvJC10O5NKdyzp9LHhpDBq
TDOYhNAigbkLbLxMkk69YEyFU/tbU8wAQq8HsLIgnwTRBWiW3THvY+xRqBDhAHr5
b5YnV45Q8vmRJ/kuIz1FjeIrWmyccV04sm77sz9aXRhOoPnVWewX/VY8vAoq5ICS
emLAWPTsHjy1LKp6lrEElPJDi+FcRjEVg4yCxVpW4IdVjKvpRqDNPFH+1/2XOSMt
Z08ZrGZk4Xj/2ICkBFkguFNlk29YgReQrL3Ha0V3ENAnz5ekORulNRypG533Eag8
xb/RTPa8NVXg4mxVySXueEn3/bv4JarerxeLorn//x/2ygwOHD2JVX0yO/97jXb8
XFZXrK/o9Uu6zzhf30H+x6PJxpPEwGCWpWh+sVxyWCJzRTNL4HYjsNWu82/Qg6Zd
hmNotJvbxvFPLOzSbMnc
=ts2q
-----END PGP SIGNATURE-----
--=-=-=--
