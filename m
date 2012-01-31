From: John Gehring <john.gehring@gmail.com>
Subject: Re: RAID6 - repeated hot-pulls issue
Date: Tue, 31 Jan 2012 08:46:31 -0700
Message-ID: <CALwOXvJMh0L3KFX8Ckfq_KLAFXBdJ-hJeRZj97_AoU_rrBhwAg@mail.gmail.com>
References: <CALwOXvL6avy3f76TcpMdMxqObCRY-SphRErjo-j1=iun-etBpA@mail.gmail.com>
	<20111205171540.4fe659e2@notabene.brown>
	<CAGRgLy6BkFhWS_2JfVgAuniLX3A1i3N_hBMjtnjAX3J0Ms8Xpg@mail.gmail.com>
	<CALwOXvL9c32=BstLn7BHF2PkwnS3UOM-cOGSRQep=eWX7FQiwA@mail.gmail.com>
	<CAGRgLy4TjDyQ9MH6sXBLrhmfd9D4dvSwqh4SB8J-vjowovrdYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy4TjDyQ9MH6sXBLrhmfd9D4dvSwqh4SB8J-vjowovrdYw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The fix still leaves me wondering why the drive pull works the first
time, but not the second.  Does a replacement drive have some other
property/flag/state that causes it to behave differently? I noticed
that I could reproduce this problem by:

- create and start an incomplete raid set (minus one drive) (8 drive ra=
id set)
- add the missing device and let it sync
- start IO
- pull a drive

In this case, the failure is on the first drive pull, but the
remaining common step in the test is the adding/resyncing of a device.
I'm wondering if when a device is added or re-added to a raid set if
some flag is left hanging in the wrong state.

Just to be clear, the fix
(http://www.spinics.net/lists/raid/msg34881.html) does take care of
the scenario described just above, but I'm still left a little
uncertain about what was wrong in the first place.

Regards,

John G

On Tue, Jan 31, 2012 at 3:49 AM, Alexander Lyakas
<alex.bolshoy@gmail.com> wrote:
>
> John,
> yes, your scenario is exactly the one we were hitting. Strangely I di=
d
> not see anybody else complaining about this issue.
>
> Alex.
>
>
> On Mon, Jan 30, 2012 at 10:55 PM, John Gehring <john.gehring@gmail.co=
m> wrote:
> > Alex,
> >
> > Thank you very much for bringing that thread to my attention! That =
fixed the
> > problem I outlined below in my earlier post. It also fixed another =
problem
> > which I'll briefly outline in case someone else is trying to connec=
t the
> > dots with the same issue:
> >
> > - linux 2.6.38.8
> > - 3 device RAID5 array
> > - mdadm zero-superblock each of the three devices
> > - mdadm create ...
> > - start IO on the new md device
> > - pull a device from the raid set
> >
> > At this point, raid gets stuck in a loop resyncing, then for some r=
eason,
> > resyncing again, and again, and ... And each resync would happen vi=
rtually
> > instantaneously.
> >
> > Thanks again.
> >
> > John G
> >
> > On Sat, Jan 21, 2012 at 10:16 AM, Alexander Lyakas <alex.bolshoy@gm=
ail.com>
> > wrote:
> >>
> >> Hi John,
> >> not sure if still relevant, but you may be affected by a bug in
> >> 2.6.38-8 kernel. We hit exactly the same issue with raid5/6.
> >>
> >> Please take a look at this (long) email thread:
> >> http://www.spinics.net/lists/raid/msg34881.html
> >>
> >> Eventually (please look towards the end of the thread) Neil provid=
ed a
> >> patch, which solved the issue.
> >>
> >> Thanks,
> >> =A0Alex.
> >>
> >>
> >>
> >>
> >> On Mon, Dec 5, 2011 at 8:15 AM, NeilBrown <neilb@suse.de> wrote:
> >> > On Fri, 2 Dec 2011 09:34:40 -0700 John Gehring <john.gehring@gma=
il.com>
> >> > wrote:
> >> >
> >> >> I am having trouble with a hot-pull scenario.
> >> >>
> >> >> - linux 2.6.38.8
> >> >> - LSI 2008 sas
> >> >> - RAID6 via md
> >> >> - 8 drives (2 TB each)
> >> >>
> >> >> Suspect sequence:
> >> >>
> >> >> 1 - Create Raid6 array using all 8 drives (/dev/md1). Each driv=
e is
> >> >> partitioned identically with two partitions. The second partiti=
on of
> >> >> each drive is used for the raid set. The size of the partition =
varies,
> >> >> but I have been using a 4GB partition for testing in order to h=
ave
> >> >> quick re-sync times.
> >> >> 2 - Wait for raid re-sync to complete.
> >> >> 3 - Start read-only IO against /dev/md1 via following command:=A0=
 dd
> >> >> if=3D/dev/md1 of=3D/dev/null bs=3D1=A0 This step insures that p=
ulled drives
> >> >> are detected by the md.
> >> >> 4 - Physically pull a drive from the array.
> >> >> 5 - Verify that the md has removed the drive/device from the ar=
ray.
> >> >> mdadm --detail /dev/md1 should show it as faulty and removed fr=
om the
> >> >> array.
> >> >> 6 - Remove the device from the raid array:=A0 mdadm /dev/md1 -r
> >> >> /dev/sd[?]2
> >> >> 7 - Re-insert the drive back into the slot.
> >> >> 8 - Take a look at dmesg to see what device name has been assig=
ned.
> >> >> Typically has the same letter assigned as before.
> >> >> 9 - Add the drive back into the raid array: mdadm /dev/md1 -a
> >> >> /dev/sd[?]2=A0=A0 Now some folks might say that I should use --=
re-add, but
> >> >> the mdadm documentation states that re-add will be used anyway =
if the
> >> >> system detects that a drive has been 're-inserted'. Additionall=
y, the
> >> >> mdadm response to this command shows that an 'add' or 'readd' w=
as
> >> >> executed depending on the state of the disk inserted.
> >> >> --All is apparently going fine at this point. The add command s=
ucceeds
> >> >> and cat /proc/mdstat shows the re-sync in progress and it event=
ually
> >> >> finishes.
> >> >> --Now for the interesting part.
> >> >> 10 - Verify that the dd command is still running.
> >> >> 11 - Pull the same drive again.
> >> >>
> >> >> This time, the device is not removed from the array, although i=
t is
> >> >> marked as faulty in the /proc/mdstat report.
> >> >>
> >> >> In mdadm --detail /dev/md1, the device is still in the raid set=
 and is
> >> >> marked as "faulty spare rebuilding". I have not found a command=
 that
> >> >> will remove drive from the raid set at this point. There were a=
 couple
> >> >> of instances/tests where after 10+ minutes, the device came out=
 of the
> >> >> array and was simply marked faulty, at which point I could add =
a new
> >> >> drive, but that has been the exception. Usually, it remains in =
the
> >> >> 'faulty spare rebuilding' mode.
> >> >>
> >> >> I don't understand why there is different behavior the second t=
ime the
> >> >> drive is pulled. I tried zeroing out both partitions on the dri=
ve,
> >> >> re-partitioning, mdadm --zero-superblock, but still the same be=
havior.
> >> >> If I pull a drive and replace it, I am able to do a subsequent =
pull of
> >> >> the new drive without trouble, albeit only once.
> >> >>
> >> >> Comments? Suggestions? I'm glad to provide more info.
> >> >>
> >> >
> >> > Yes, strange.
> >> >
> >> > The only think that should stop you being able to remove the dev=
ice is
> >> > if
> >> > there are outstanding IO requests.
> >> >
> >> > Maybe the driver is being slow in aborting requests the second t=
ime.
> >> > =A0Could
> >> > be a driver bug on the LSI.
> >> >
> >> > You could try using blktrace to watch all the requests and make =
sure
> >> > every
> >> > request that starts also completes....
> >> >
> >> > NeilBrown
> >> >
> >
> >
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
