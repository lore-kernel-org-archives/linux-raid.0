From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Considering a complete rework of RAID on my home compute server
Date: Thu, 6 Jan 2011 10:17:28 -0800
Message-ID: <AANLkTikxViM45MfjZvMCDAobeVVwBqMZHrm_Ws-bsAQt@mail.gmail.com>
References: <AANLkTinsQoPVaYVe4H9kMK7_-GFzHoKt_Zdf4nUKc+C2@mail.gmail.com>
	<87.68.02631.5E6052D4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87.68.02631.5E6052D4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jan 5, 2011 at 4:03 PM, Leslie Rhorer <lrhorer@satx.rr.com> wro=
te:
>> 1) The Linux/MySQL stuff is a 3 drive RAID1. (sda/sdb/sdc)
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Well, RAID1 certainly offers the most robu=
st solution, especially
> with more than 1 mirror.
>
<SNIP>
>
>> 3) There is a second RAID1 (sda/sdb/sdc) used for backups of the
>> RAID0. The RAID0 is backed up to RAID1 nightly. If the RAID0 fails
>> then I lose 1 day's work.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Well, first of all, unless you meant to sa=
y sda1/sdb1/sdc1, etc,
> then this can't be different from the #1 RAID array above. =C2=A0Assu=
ming you are
> actually using partitions, then I don't really see the value of two s=
eparate
> arrays. =C2=A0Why not just one RAID1 array?
>

Sorry I wasn't very clear.

In #1 the RAID1 is my main Linux system on sda3/sdb3/sdc3.
In #3 the RAID1 is purely for backups on /swa6/sdb6/sdc6 and is used
only for the backup of the RAID0 data. It is not normally mounted
except when doing backups. I wanted the extra protection that if
something went wrong with the basic Linux box the backup partition
would not normally be mounted and the data hopefully a bit safer.


> =C2=A0 =C2=A0 =C2=A0 =C2=A0Also, I personally would reverse the backu=
p strategy. =C2=A0I would put
> the Windows VM on the (single) main RAID array and back up the data t=
o a
> single 1T hard drive.
>

I do this today backing up the existing RAID1 partitions to an
external eSATA 1TB drive.

>> =C2=A0 =C2=A0OK - the problems I have with this arrangement are:
>>
>> 1) I used the older v0.9 metadata.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0This may be necessary if you are booting f=
rom the array. =C2=A0The
> limitations of the 0.90 superblock may never impact you. =C2=A0That's=
 a small
> system with only a few drives.
>
>> 2) The RAIDs are assembled by the kernel automatically. I do not use
>> an initrd. (Because I don't know how/newer have)
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0How is that a problem? =C2=A0An initrd, or=
 lack thereof, won't prevent
> you from disabling the automatic assembly of one or more arrays, unle=
ss once
> again you boot from the array in question. =C2=A0Most modern distros =
default to
> using an initrd. =C2=A0What distro are you using?
>

The machines are Gentoo and an initrd/initramfs is up to the builder.
The new RAID6/superblock-1.2  boot uses one. The RAID1/superblock-0.9
does not.

>> 3) I think with 5 disks I could get better performance =C2=A0than I
>> currently get , with similar or better safety using maybe RAID5 or
>> RAID6.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0No, RAID1 is as safe as it gets. =C2=A0RAI=
D0 allows for better
> performance, but if you make the RAID0 into your backup solution, the
> performance won't matter much.
>

If I'm wrong about RAID6 please correct me as this understanding is
why I chose it.

1) A 5-drive RAID6 can survive losing 2 disks and still return good dat=
a.

2) A 5-drive RAID6 reads data as nearly fast as a 3-drive RAID0.

If those two aren't true then my choice of RAID6 doesn't improve my
system as I hoped.

3) My current 3-drive RAID1 can lose 2 disks and still return good
data making #1 equivalent to #3

4) #2 would be faster than my current 2-drive RAID0 and wouldn't have
the risk of a single drive loss.

If #3 & #4 aren't correct then maybe RAID6 isn't buying me anything.

> =C2=A0 =C2=A0 =C2=A0 =C2=A0Is performance a really big issue? =C2=A0A=
re you having problems with bad
> performance?
>

I think I am. On the current RAID0 side I'm running 4-5 Win XP VMs
doing number crunching. Each is sitting in a 20GB virtual disk which
is just files in VMWare or Virtualbox. Sometimes I run into moderate
periods of time (5-30 seconds) with disk activity lights flashing,
apparent loss of interactivity on the machine (mouse & keyboard not
responding quickly in Linux) even when the RAID1/Linux side isn't
doing anything. No cron jobs or anything like that running, just the
VMs sucking up CPU and disk. Most of the number crunching is reading
larger amounts of data, using the CPU and then writing some smallish
files out.

>> =C2=A0 =C2=A0Overall, as I see it, I can suffer no disk loss on the =
RAID0, and
>> can handle a 2 disk loss on the RAID1. (Is that correct?) I'm thinki=
ng
>> that with a 5-drive RAID6 I might well get better performance than
>> either of the current RAIDs and (from reading) more protection durin=
g
>> a rebuild if one of my drives goes bad.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0A single RAID5 or RAID6 solution is certai=
nly simpler, and there is
> significant value there. =C2=A0Read performance should be enhanced, b=
ut write
> performance will be impacted. =C2=A0You've also lost your backup solu=
tion in this
> scenario, though, so you will need to come up with something.
>

I have a local eSATA in my office and then a second machine in the
house with a 2-drive RAID1. I use them both for backups currently.

<SNIP>
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0You might consider an external enclosure. =
=C2=A0Enclosures for up to 5
> dives are quite economical.

I will give it some thought.

Thanks!

- Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
