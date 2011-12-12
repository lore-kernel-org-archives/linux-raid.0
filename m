From: Anssi Hannula <anssi.hannula@iki.fi>
Subject: Re: raid6 rebuild not starting
Date: Mon, 12 Dec 2011 09:25:30 +0200
Message-ID: <CAP+ghc+smxZQ3EKD2jaGNRu-hE3yxRQcG8MU55-Oqo4aXsU7HA@mail.gmail.com>
References: <4EE455B2.2040105@iki.fi>
	<20111212140119.35dbf92e@notabene.brown>
	<CAP+ghcLLkAbPVy8LO4Hq6ncNr3=tvGGHB1tJ9Wih=Cjbty+zuw@mail.gmail.com>
	<20111212164240.01e8d1fb@notabene.brown>
	<CAP+ghcLtZQeAR3n4x_8MuGJrEtkOaMWcNKHRin=A+tuDC7aZ5Q@mail.gmail.com>
	<20111212172453.57bee40c@notabene.brown>
	<CAP+ghcKYdEnBmUB5kiOzbMvU6_t3+DuV06xBdPZau8MuiDDV4g@mail.gmail.com>
	<20111212181036.52860cc3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111212181036.52860cc3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Dec 12, 2011 at 9:10 AM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 12 Dec 2011 08:42:49 +0200 Anssi Hannula <anssi.hannula@iki.f=
i> wrote:
>
>> On Mon, Dec 12, 2011 at 8:24 AM, NeilBrown <neilb@suse.de> wrote:
>> > On Mon, 12 Dec 2011 08:02:33 +0200 Anssi Hannula <anssi.hannula@ik=
i.fi> wrote:
>> >
>> >> On Mon, Dec 12, 2011 at 7:42 AM, NeilBrown <neilb@suse.de> wrote:
>> >> > On Mon, 12 Dec 2011 07:22:17 +0200 Anssi Hannula <anssi.hannula=
@iki.fi> wrote:
>> >> >
>> >> >> On Mon, Dec 12, 2011 at 5:01 AM, NeilBrown <neilb@suse.de> wro=
te:
>> >> >> > On Sun, 11 Dec 2011 09:03:14 +0200 Anssi Hannula <anssi.hann=
ula@iki.fi> wrote:
>> >> >> >
>> >> >> >> Hi!
>> >> >> >>
>> >> >> >> After I rebooted during a raid6 rebuild, the rebuild didn't=
 start again.
>> >> >> >> Instead, there is a flood of "RAID conf printout"s that see=
mingly happen
>> >> >> >> on array activity.
>> >> >> >>
>> >> >> >> All the devices show up properly in --detail and two device=
s are marked
>> >> >> >> as "spare rebuilding", and I can access the contents of the=
 array just
>> >> >> >> fine, but the rebuild doesn't actually start. Is this a bug=
 or am I
>> >> >> >> missing something? :)
>> >> >> >>
>> >> >> >> I was initially on 2.6.38.8, but also tried 3.1.4 which see=
ms to have
>> >> >> >> the same issue. mdadm is 3.1.5.
>> >> >> >>
>> >> >> >> I'm not using start_ro and writing to the array doesn't tri=
gger a
>> >> >> >> rebuild either.
>> >> >> >>
>> >> >> >> Attached are --examine outputs before assembly, kernel log =
output on
>> >> >> >> assembly, /proc/mdstat and --detail after assembly (on 3.1.=
4).
>> >> >> >>
>> >> >> >
>> >> >> > Thank you for the very detailed problem report.
>> >> >>
>> >> >> Thanks for the quick response :)
>> >> >>
>> >> >> > Unfortunately it is a complete mystery to me what is happeni=
ng.
>> >> >> >
>> >> >> > The repeated "RAID conf printout" messages are almost certai=
nly coming from
>> >> >> > the end of raid5_remove_disk.
>> >> >> > It is being called from remove_and_add_spares for each of th=
e two devices
>> >> >> > that are being rebuilt. =A0raid5_remove_disk declines to rem=
ove them because it
>> >> >> > can keep rebuilding them.
>> >> >> >
>> >> >> > remove_and_add_spares then counts them and notes there are 2=
=2E
>> >> >> > md_check_recovery notes that this is > 0, so it should creat=
e a thread to run
>> >> >> > md_do_sync.
>> >> >> >
>> >> >> > md_do_sync should then print out a message like
>> >> >> > =A0md: recovery of RAID array md0
>> >> >> >
>> >> >> > but it doesn't. =A0So something went wrong.
>> >> >> > There are three reasons that md_do_sync might not print a me=
ssage:
>> >> >> >
>> >> >> > 1/ MD_RECOVERY_DONE is set. =A0As only md_do_sync ever sets =
it, that is
>> >> >> > =A0 =A0unlikely, and in any case md_check_recovery clears it=
=2E
>> >> >> > 2/ mddev->ro !=3D 0. =A0It is only ever set to 0, 1, or 2. =A0=
If it is 1 or 2
>> >> >> > =A0 then we would be able to see that in /proc/mdstat as a "=
(readonly)"
>> >> >> > =A0 status. =A0But we don't.
>> >> >> > 3/ MD_RECOVERY_INTR is set. Again, md_check_recovery clears =
this. =A0It does
>> >> >> > =A0 get set if kthread_should_stop() returns 'true', but tha=
t should only
>> >> >> > =A0 happen if kthread_stop() was called. =A0That is only cal=
led by
>> >> >> > =A0 md_unregister_thread and I cannot see any way that could=
 be call.
>> >> >> >
>> >> >> > So. =A0No idea.
>> >> >> >
>> >> >> > Are you compiling these kernels yourself?
>> >> >>
>> >> >> Nope (used Mageia kernels), but I did now (3.1.5).
>> >> >>
>> >> >> > If so, could you:
>> >> >> > =A0- put a printk in the top of md_do_sync to report the val=
ues of
>> >> >> > =A0 mddev->recovery and mddev->ro
>> >> >> > =A0- print a message whenever md_unregister_thread is called
>> >> >> > =A0- in md_check_recovery, in the
>> >> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (mddev->ro) {
>> >> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Only thing=
 we do on a ro array is remove
>> >> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * failed dev=
ices.
>> >> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
>> >> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mdk_rdev_t *r=
dev;
>> >> >> >
>> >> >> > =A0in statement, print the value of mddev->ro.
>> >> >> >
>> >> >> > Then see which of those printk's fire, and what they tell us=
=2E
>> >> >>
>> >> >> Only the last one does, and mddev->ro =3D=3D 0.
>> >> >>
>> >> >> For reference, attached is the used patch and resulting log ou=
tput.
>> >> >>
>> >> >
>> >> > Thanks.
>> >> >
>> >> > So it isn't running md_do_sync at all. Odd.
>> >> >
>> >> > Could please add:
>> >> > =A0- call "WARN_ON(1);" in print_raid5_conf() so we get a stack=
 trace and can
>> >> > =A0 =A0see who is calling it.
>> >> > =A0- print the value that remove_and_add_spares is going to ret=
urn.
>> >>
>> >> Attached. As you can see, remove_and_add_spare returns 0.
>> >>
>> >> --
>> >> Anssi Hannula
>> >
>> >
>> > Please add:
>> >
>> > diff --git a/drivers/md/md.c b/drivers/md/md.c
>> > index 5c95ccb..fa56ac5 100644
>> > --- a/drivers/md/md.c
>> > +++ b/drivers/md/md.c
>> > @@ -7328,8 +7328,10 @@ static int remove_and_add_spares(mddev_t *m=
ddev)
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> >
>> > + =A0 =A0 =A0 printk("degraded=3D%d\n", mddev->degraded);
>> > =A0 =A0 =A0 =A0if (mddev->degraded) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_for_each_entry(rdev, &mddev->d=
isks, same_set) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 printk("raid_disk=3D=
%d flags=3D%x\n", rdev->raid_disk, rdev->flags);
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rdev->raid_disk=
 >=3D 0 &&
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0!test_bit(I=
n_sync, &rdev->flags) &&
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0!test_bit(F=
aulty, &rdev->flags))
>> >
>> >
>> > 'degraded' must be 2 as dmesg contains
>> >
>> > [ =A0 45.544806] md/raid:md0: raid level 6 active with 8 out of 10=
 devices, algorithm 2
>> >
>> > and 'degraded' is exactly the difference between '8' and '10' ther=
e.
>> >
>> > raid disks 3 and 7 must have In_sync and Faulty clear as both of t=
hem just
>> > show "spare rebuilding" in the 'detail' output.
>> >
>> > so remove_and_add_spares "must" return 2.
>> >
>> > Hopefully the above patch will help me understand which of those i=
s wrong.
>>
>> The output is:
>> [ =A0 47.389379] md0: degraded=3D2
>> [ =A0 47.389380] md0: raid_disk=3D0 flags=3D4
>> [ =A0 47.389381] md0: raid_disk=3D-1 flags=3D0
>>
>> Full assemble log attached.
>>
>
> Bingo.
>
> This will fix it. =A0 We don't really need that 'break' there, and it=
 is a
> problem.
>
> Thanks.

Confirmed. Thanks for the quick fix :)

--=20
Anssi Hannula
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
