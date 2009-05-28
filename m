From: Maxime Boissonneault <maxime.boissonneault@usherbrooke.ca>
Subject: Re: Upgrading a software RAID
Date: Thu, 28 May 2009 10:32:53 -0400
Message-ID: <4A1EA095.9090406@usherbrooke.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: robin@robinhill.me.uk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Robin Hill a =E9crit :
> On Mon May 25, 2009 at 01:05:15PM -0400, Maxime Boissonneault wrote:
>
>  =20
>> Hello,
>> I am using Ubuntu Hardy with 3x500GB drives and the following RAID
>> configuration :
>>
>> /boot is on a 100MB RAID1
>> / is on a 30GB RAID0
>> /home is on a 906GB RAID5
>>
>>    =20
> Ouch - why RAID0 for /?  If you lose a single drive then all the
> configuration, etc. is down the drain.  I'd suggest rethinking this
> while you're going through the rebuild process anyway.
>
>  =20
That is why I do backups of / on /home regularily. I first did a RAID0=20
for performance. I did some testing on performance of RAID0,1,5 and=20
RAID1 was pretty lousy (I put the results of my tests here :=20
http://cqed.physique.usherbrooke.ca/~mboisson/htpc.php?sec=3Draid_test =
)
I guess I should have used a RAID5, but RAID1 seems like a terrible ide=
a=20
considering the really bad performances.

>> I want to replace the 3 drives by 3 1TB drives.
>>
>> Here is how I planned to do it :
>> 0- Backup my /home on some external disk.
>> 1- backup / with something like :
>> sudo tar cvpzf /backup.tgz --exclude=3D/media --exclude=3D/proc
>> --exclude=3D/lost+found --exclude=3D/backup.tgz --exclude=3D/mnt --e=
xclude=3D/sys
>> --exclude=3D/home /
>> mv /backup.tgz $1
>>    =20
> You'll need to do the tar in single user mode (init 1) to ensure ther=
e's
> no open files when you're backing up (or use a bootable CD).
>
>  =20
I used this backup before to restore the system and it seemed to work=20
pretty well.
>> 2- Replace 1 disk
>> 3- Boot and let the RAID1 and RAID5 reconstruct
>>    =20
> You'll have to boot to a CD then - your root FS is trashed at this
> point.
>
>  =20
>> 4- Replace 1 other disk
>> 5- Boot and let the RAID1 and RAID5 reconstruct again
>> 6- Replace the last disk
>> 7- Boot and let the RAID1 and RAID5 reconstruct one last time
>> 8- Boot and restore the backup on the RAID0 / partition.
>> 9- Resize the /home partition to 1 TB.
>>
>> I suspect there will be a problem replacing the primary disk, but I =
guessed
>> that I could solve this simply by changing which is the primary disk=
 in the
>> BIOS.
>>
>> Is there any other problem that will or could happen ?
>>
>>    =20
> See above - your current plan is pretty much doomed I'm afraid.
>
>  =20
>> For example, I am not sure if the raid manager is on the /boot parti=
tion or
>> on the /. I guess if it is on /, it won't work at all since the raid=
=20
>> manager
>> itself won't be able to run ?
>> Also, is it possible to boot and access a command line to restore th=
e=20
>> backup
>> with a failed / partition ?
>>
>> I am also unsure about how I should proceed to resize the /home part=
ition.
>> Is this done through mdadm ?
>>
>>    =20
> No, you'll have to delete & recreate the partition using fdisk.
>
>  =20
>> Please enlight me on any problems that I will have.
>>
>>    =20
>
> An easier option (assuming you want to keep the arrays as currently
> setup) would be to boot from a CD and do a full copy of each of the
> 500GB disks to the 1TB disks.  You'll then just need to resize the
> last partition (assuming /home is set up on the last partition on the
> disks anyway) and grow the array and filesystem.
>
> A _better_ option (if possible) would be to install all the drives in
> the system concurrently, then you can boot from CD and create arrays =
on
> the new drives and copy the data across.  You'll also need to update
> mdadm.conf (and the initrd if you're using one) to indicate the new
> array IDs.
>
> HTH,
>     Robin
>  =20

I can not install more drives in the computer. It is a home theater=20
computer in a small case. I was expecting to be able to let the raid=20
manage the copies itself.

If the / was on a RAID5, would it be able to boot with 2 disks ?
If so, is it possible to convert my RAID0 to a RAID5 ?
=46or example, I could boot on a CD, backup / onto /home, delete the RA=
ID0=20
array and recreate it as RAID5, then restore the backup. Would this wor=
k ?


Thanks


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
