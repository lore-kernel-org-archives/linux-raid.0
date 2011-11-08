From: Peter Zieba <pzieba@networkmayhem.com>
Subject: Re: Impending failure?
Date: Mon, 7 Nov 2011 18:04:47 -0600 (CST)
Message-ID: <be5301e8-f76b-4733-8071-27458273a38e@large-turd>
References: <CAB1R3sgM6aMTpR3=VN3u1C5hFHnvxFi6C69kGEtuEx2nxcGnMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3sgM6aMTpR3=VN3u1C5hFHnvxFi6C69kGEtuEx2nxcGnMA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <mysqlstudent@gmail.com>
Cc: Mathias =?utf-8?Q?Bur=C3=A9n?= <mathias.buren@gmail.com>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok, so first I'll explain what a pending sector is. It is not "pending =
defective sectors". It could be defective, but at the moment it's in a =
sort of limbo state. That's why it's called pending.

With pending sectors, basically, the drive is unable to read the given =
sector at-this-time -- but it's not necessarily a bad sector (this is a=
ctually a normal occurrence with large disks every once in a while). In=
 other words, if you tried to read it again, the drive might be able to=
 read it (due to temperature fluctuations, phase of the moon, etc. etc.=
). If it managed to succeed, the drive rewrites what should have been t=
here in the first place. Imagine something written very faintly on a pi=
ece of paper. If you look at it, you might not be able to read it. If y=
ou stare at it for a while and try a few times you might be able to fig=
ure out what was there. Or, you give up and come back to it a day later=
 and suddenly, it makes sense. Now, if the drive succeeds in figuring o=
ut what was there, it tries writing it back to the disk. If this fails,=
 now you have something more than just a pending sector. It's actually =
marked bad, and remapped to the spare sectors the drive has. This is a =
much better indicator of drive failure "5 Reallocated_Sector_Ct" or "19=
6 Reallocated_Event_Count" (not sure how these differ, but in any case,=
 they're worse than pending sectors).

Now, if the drive fails to determine what was supposed to be in this se=
ctor, the machine eventually gets notified of the failure to return the=
 sector, mdadm then reads the data from parity, and writes the proper d=
ata back to the original drive that failed to read the given sector. So=
, if the write succeeds, the sector is no longer pending, and the count=
 should be decremented by one. If the write fails, it should be remappe=
d to a spare sector and again the pending sector count should be decrem=
ented. Either case is transparent to the machine/mdadm.

So, with the "check" sync_action, you are forcing a read of all data an=
d parity data, on every drive. If there are pending sectors (and there =
could easily be ones you hit that the drive doesn't even know are pendi=
ng yet), they will naturally be corrected (either by the drive managing=
 to read it properly this time, or by it giving up and mdadm checking t=
he parity for what was supposed to be there.)

So, yes, pending sectors should be resolved by a check /as long as they=
're in use by mdadm/. It's important to understand that there might be =
sectors outside of what's being used by mdadm (partition table, and was=
ted space at the end of a drive). A "check" will not resolve these, but=
 they're also not an issue. The drive simply isn't sure what's written =
in a location that you don't care about.

A check should be safe to do remotely, provided you understand that it =
will generate a lot of I/O. IIRC, this I/O is of lower priority than ac=
tual I/O of the running system, and so it shouldn't cause a problem oth=
er than making regular I/O of the system a little slower. I believe a m=
inimum and maximum speed can be set for this check/repair. If you have =
severe problems that are lurking (in other words, they'll manifest soon=
er or later without changing anything), this could in theory kick out e=
nough drives to bring the array down. This is very unlikely, however.

If you want to run a check on an array with redundancy (Raid-1, Raid-5,=
 Raid-6, etc.), doing the following:
echo check > /sys/block/md0/md/sync_action

Will cause the array to check all of the data against the redundancy. T=
he actual intended purpose of this is to check that the parity data mat=
ches the actual data. In other words, this is for mdadm's housekeeping.=
 It happens to do a good job of housekeeping for the drives themselves =
due to forcing everything to be read, however. After running this comma=
nd, you can check on the progresss with:
cat /proc/mdstat

Once this is complete, "mismatch count" should be updated with how many=
 errors were found if you did a "check", which can be read from:
cat /sys/block/md0/md/mismatch_cnt

This should be zero.

If this turns up mismatches, they can be repaired with:
echo repair > /sys/block/md0/md/sync_action

Or, you can just run repair outright (and parity will be fixed as it is=
 found to be bad).

Having bad parity data isn't normal. Something like this would happen d=
ue to abnormal conditions (power outages, etc.).

The short answer to all of this is stop worrying about pending sectors =
(they are relatively normal), and run a "check" once a week, and all sh=
ould be well. On recent CentOS/Rhel this is a cron job, which is locate=
d in:
/etc/cron.weekly/99-raid-check

It is configured by:
/etc/sysconfig/raid-check

This wasn't always included in rhel/centos (it has been added in the la=
st year or two if I'm not mistaken.). No idea how other distros handle =
this (they simply might not, either).

To remove a disk properly:
mdadm --manage /dev/md0 --fail /dev/sda1
mdadm --manage /dev/md0 --remove /dev/sda1

If you managed to already remove a disk without telling mdadm you were =
going to do so, this might help:
mdadm --manage /dev/md0 --remove detached

If all the disks are happily functioning in the array currently (as in,=
 mdadm hasn't kicked any out of the running array), I'd recommend runni=
ng a "check" before removing any disks, to clean up any pending sectors=
 first.

Then if you still want to remove a disk to either replace it, or do som=
ething to it outside of what's healthy/sane to do to a disk in a runnin=
g array, go ahead with the remove.

Disclaimers and notes:
 - All commands assume you're dealing with "/dev/md0". Where applicable=
, all commands involving an operation on a specific drive assume you're=
 dealing with /dev/sda1 as the member of the array you want to act on.
 - These are my experiences and related to my particular configuration.=
 Your situation may warrant different action, in spite of my confidence=
 in the accuracy of what's written here.
 - I use "parity" when sometimes I'm simply referring to another copy o=
f the data (Raid-1, Raid-10.) for the sake of brevity.
 - I've heard of someone mention mismatch counts being normal in certai=
n weird situations somewhere on the list (something to do with swap???)
 - There are shorter ways of doing the fail/remove operations, and can =
also be done with one line (all in the man page).

Cheers

Peter Zieba


----- Original Message -----
=46rom: "Alex" <mysqlstudent@gmail.com>
To: "Peter Zieba" <pzieba@networkmayhem.com>
Cc: "Mathias Bur=C3=A9n" <mathias.buren@gmail.com>, "Mikael Abrahamsson=
" <swmike@swm.pp.se>, linux-raid@vger.kernel.org
Sent: Monday, November 7, 2011 3:17:54 PM
Subject: Re: Impending failure?

Hi guys,

> So, in my personal experience with pending sectors, it's worth mentio=
ning the following:
>
> If you do a "check", and you have any pending sectors that are within=
 the partition that is used for the md device, they should be read and =
rewritten as needed, causing the count to go down. However, I've notice=
d that sometimes I have pending sector counts on drives that don't go a=
way after a "check". These would go away, however, if I failed and then=
 removed the drive with mdadm, and then subsequently zero filled the /e=
ntire/ drive (as opposed to just the partition on that disk that is use=
d by the array). The reason for this is that there's a small chunk of u=
nused space that never gets read or written to right after the partitio=
n (even though I technically partition the entire drive as one large pa=
rtition (fd =C2=A0Linux raid auto).
>
> I think what actually happens in this case is that when the system re=
ads data from near the end of the array, the drive itself will do read-=
ahead and cache it. So, even though the computer never requested those =
abandoned sectors, the drive eventually notices that it can't read them=
, and makes a note of the fact. So, this is harmless.
>
> You could probably avoid the potential for false-positive on pending =
sectors if you used the entire disk for the array (no partitions), but =
I'm pretty sure that breaks the raid auto-detection.
>
> Currently, my main array has 8 2TB hitachi disks, in a raid 6. It is =
scrubbed once a week, and one disk consistently has 8 pending sectors o=
n it. I'm certain I could make those go away if I wanted, but, frankly,=
 it's purely aesthetic as far as I'm concerned. Some of my drives also =
have non-zero "196 Reallocated_Event_Count" and "5 Reallocated_Sector_C=
t", however, I have no drives with non-zero "Offline_Uncorrectable". I =
haven't had any problems with the disks or array (other than a temperat=
ure induced failure ... but that's another story, and I still run the s=
ame disks after that event). I used to have lots of issues before I sta=
rted scrubbing consistently.

I think I understand your explanation. You are basically saying that
if I recheck the drive, there's a possibility the pending defective
sectors may resolve themselves?

Given that I have an existing system, how do I check the integrity of
the partitions? What is the contents of the "check" script to which
you refer?

Is this safe to do remotely?

Is it necessary to set a disk faulty before removing it?

Thanks,
Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
