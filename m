From: Sandeep K Sinha <sandeepksinha@gmail.com>
Subject: Re: Requesting replace mode for changing a disk
Date: Wed, 13 May 2009 09:38:44 +0530
Message-ID: <37d33d830905122108k245c44ccgf3dfd0d2b0d60af9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>"Leslie Rhorer" <lrhorer@satx.rr.com> writes:

>> This is one of many things proposed occasionally here, no real
>> objection, sometimes loud support, but no one actually *does* the co=
de.
>
> 	At the risk of being a metoo, I would really love this feature.
>
>> You have described the problem exactly, and the solution is still to=
 do
>> it manually. But you don't need to fail the drive long term, if you =
can
>> stop the array for a few moments. You stop the array, remove the sus=
pect
>> drive,
>
> Um, how, exactly?  That is to say, after stopping the array, how does=
 one
> remove the drive?  From the next step in your suggestion, it doesn't =
seem
> tome you are talking about physically removing the drive, so how does=
 one
> remove a drive from a stopped array for this purpose?  I didn't think=
 that
> either
>
> 	mdadm -r <drive> <array>
> or
>
> 	mdadm -f <drive> <array>
>
> could be used on a stopped array.  Am I mistaken?
>
>> create a raid1 of the suspect drive marked write-mostly and the
>> new spare,
>
> But doesn't creating the array with the drive wipe the contents?  If =
so, it
> doesn't seem to me this provides much redundancy.
>
>> then add the raid1 in place of the suspect drive.
>
> Before starting the array?  If so, how?  Or should one do an assemble
> including the newly minted RAID1?  I thought mdadm would take the new=
ly
> added drive to be blank, even if it isn't.
>
>> For any
>> chunks present on the new drive the reads will go there, reducing
>
> Huh?  Are you saying any read which finds one chunk missing will
> automatically write back the missing data (doing a spot rebuild), or
> something else?
>

Yes, this is one of concepts that used while using a mirrored configura=
tion.
I am not sure though, that even md has it. Even a read fails on one of
the part of the mirror
then it is served from the mirror. Also, a write is sent back to keep
the mirror in sync.
This should ideally happen, as if a read fails on the device which is
being mirrored, you are
aware that there is something wrong and you should try to recover from
it silently.


>> access, while data is copied from the old to the new in resync, and
>
> See my query above.  It seems to me you are saying the RAID1 can be c=
reated
> without wiping the drive.
>
>> writes still go to the old suspect drive so if the new drive fails y=
ou
>> are no worse off.
>
> I think I would expect the old drive to be more likely to fail than t=
he new.
>
>> When the raid1 is clean you stop the main array and
>> back the suspect drive out.
>
> OK, basically the same question.  How does one disassemble the RAID1 =
array
> without wiping the data on the new drive?

> I think he ment this:
>
> mdadm --stop /dev/md0
> mdadm --build /dev/md9 --chunk=3D64k --level=3D1 --raid-devices=3D2 /=
dev/suspect /dev/new
> mdadm --assemble /dev/md0 /dev/md9 /dev/other ...

> MfG
>        Goswin

Now the point here is that is it so simple to offline an array and
just assimilate it back with a different raid level.
IMO, may be on desktop environment it is acceptable but not when
deployed on a larger scale.

What I believe here is that there should be an option to fail to a
disk gradually. This can be invoked the moment you start getting to
know that your disk is faulty and is soon going to be blown away.
The first approach is to start copying the contents of that disk to a
spare disk. And once completed, the faulty disk should be replaced
with the newly constructed disk.

In the course of construction, write must go on both the devices and
read must be served from the original faulty disk.
I am not sure whether we have a similar mechanism implemented in md or
not, but this will sound better for a long term goal.

If not I believe failing should be provided with this extra
functionality of "immediate" or "gradual" failure. As both should
ideally start reconstruction.

Comments please.


--
Regards,
Sandeep.






=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
