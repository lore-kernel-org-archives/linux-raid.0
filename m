From: tron@monkii.net
Subject: RE: RAID Configuration For New Home Server
Date: Wed, 2 Jun 2010 09:51:52 +0200
Message-ID: <476c45239528b5580f83a826f1cbb766.squirrel@mail.monkii.net>
References: <C5.28.17309.03BF50C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C5.28.17309.03BF50C4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: 'Simon Matthews' <simon.d.matthews@gmail.com>, 'Mdadm' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>> On Tue, Jun 1, 2010 at 10:08 AM, Carlos Mennens <carloswill@gmail.com>
>> wrote:
>> > I built a new home server this weekend & am ready to load my O.S.
>> > (Arch Linux) on it today. It has 4 x 320 GB Seagate Barracuda's
>> > (SATA). I don't really have a specific function of this server at home
>> > beyond holding my data reliably and decent read / write performance.
>> > My question to you experts is what do you recommend I configure for
>> > this particular configuration? Should I run RAID 5 or RAID 10? To
>> > spare or not to spare? I really appreciate any best suggestions for
>> > general over all function on this matter.
>>
>> How about 2 drives in a RAID0 or LVM configuration and the other two
>> in another machine and used for backups?
>
> 	If down time is not an issue, and he is comfortable living with a
> single unprotected system in the event of a drive failure, that's not a
> bad
> solution, at all, especially given the small size of his arrays.  If it
> were
> me, I would invest in at least one more drive to make one of the arrays a
> RAID5 and the other a RAID0 (or LVM).  That way, in the event of a drive
> failure, he is still left with redundancy of one form or another.
> Additionally, if he makes the primary array the RAID5 array, the no single
> drive failure will take his server offline, and he can recover with no
> down
> time.  If performance is more important than zero down time, then he could
> make his backup the RAID5 array.  That way he doesn't have to worry so
> much
> about a second drive failure while he is restoring data to his failed
> primary array after it is repaired.  Indeed, a RAID5 array backed up by an
> LVM volume is precisely what I ran before my primary server exceeded 4T of
> data.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

There are about as many answers to this as there are people using your
setup so let's all agree that there's no "one way" of doing things.

With that being said let me share a setup I recently configured for a
slackbuild and slackbuild-storage server at home. I had 5x320gb SATA
drives to spare since I upgraded my main fileserver, since mdadm works on
partition level I started with creating my root (/) partition on one drive
and setting it to 20gb (/dev/sda1), then a partition for storage
(/dev/sda2 -> /var/storage) with the remaining diskspace. I preceded to
copy the partition table over to my other drives using sfdisk (sfdisk-d
/dev/sda|sfdisk /dev/sdX). Next I created a raid1 using all the /dev/sdX1
partitions (mdadm -C /dev/md0 -l 1 -n 5 /dev/sd[a,b,c,d,e]1) and after
that created the raid5 (mdadm -C /dev/md1 -l 5 -n 5 -x 0
/dev/sd[a,b,c,d,e]2) with no spares that's what the -x 0 is for.

This has the benefit of having a rock solid raid1 configuration for your /
and also benefiting from having a relatively safe storage using raid5.
Also it's real easy to setup and if you want to add more storage you can
just pop another drive in, copy the partition table using sfdisk and add
the new partitions to the existing raid-devices using mdadm.

- Hakan

