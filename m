From: Nicolas Tellier <telliern@gmail.com>
Subject: Re: Failed Raid 5 due to OS mbr written on one of the array drives
Date: Tue, 3 Nov 2015 15:21:19 +0100
Message-ID: <CAArDwD9SDbH-Xdi6hRciLcYkWzY+Kv3JtgtWCyvELffJ=gv+0w@mail.gmail.com>
References: <CAArDwD-7=Vmo16K3GH0dxZie=RAiSavZNfMNvabf4X6G4fK34w@mail.gmail.com>
 <5637A92B.5010305@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5637A92B.5010305@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil, and thanks for taking the time to reply to me.

I'm not sure I understood you advice correctly.
When you say leave off /dev/sdd, do you mean I should recreate a 3
disks array like this :
mdadm --create --verbose --assume-clean /dev/md0 --level=3D5
--metadata=3D1.2 --chunk=3D128 --data-offset=3D262144 --raid-devices=3D=
3
/dev/sda1 /dev/sdb1 /dev/sdc1

Or a 4 disks array with no mention of /dev/sdd, like this (my instinct
tell me that wouldn't work) :
mdadm --create --verbose --assume-clean /dev/md0 --level=3D5
--metadata=3D1.2 --chunk=3D128 --data-offset=3D262144 --raid-devices=3D=
4
/dev/sda1 /dev/sdb1 /dev/sdc1

Or, as I was thinking originally, to put /dev/sdd as missing, like so :
mdadm --create --verbose --assume-clean /dev/md0 --level=3D5
--metadata=3D1.2 --chunk=3D128 --data-offset=3D262144 --raid-devices=3D=
4
/dev/sda1 /dev/sdb1 /dev/sdc1 missing /dev/sdd


In the eventuality of having to start back from scratch, I'll be sure
to clean everything (zero-superblock and all) and check the health of
all the devices. Raid 6 might be more suited to withstand some of my
episodic stupidity :)

I'm tempted to subscribe to the mailing list, but I'm afraid of the
volume of e-mail I'm going to get. I originally tried to search
through the archives, but couldn't find anything relevant to my case.
I'm looking right now at the "timeout mismatch" results.

Thanks again.

Nico

2015-11-02 19:19 GMT+01:00 Phil Turmel <philip@turmel.org>:
> Good afternoon Nicolas,
>
> On 11/02/2015 12:02 PM, Nicolas Tellier wrote:
>> I'm looking for advices regarding a failed (2 disc down) Raid 5 arra=
y
>> with 4 disks. It was running in a NAS for quite some time but after =
I
>> came back from a trip, I found out that the system disk was dead.
>> After replacing the drive, I reinstalled the OS (OpenMediaVault for
>> the curious). Sadly the mbr was written to one of the raid disk
>> instead of the OS one. This would not have been too critical if, aft=
er
>> booting the system, I didn't realized that the array was already
>> running in degraded mode prior to the OS disk problem. Luckily I hav=
e
>> a backup for most of the critical data on that array. There is nothi=
ng
>> that I cannot replace, but it would still be quite inconvenient. I
>> guess it's a good opportunity to learn more about raid :)
>
> Very good.  Many people don't understand that RAID !=3D Backup.
>
>>  mdadm --stop /dev/md0 and removing the boot flag from the wrongly
>> written raid disk are the only stuff that I did so far.
>
> Good.
>
> [trim /]
>
>> Now, /dev/sda is more interesting. The partition is still present an=
d
>> looks intact, it seems like it's just missing the superblock because
>> of the mbr shenanigan. Also the two healthy drives still see it as
>> active.
>
> The superblock isn't anywhere near the MBR, so something more than ju=
st
> grub-install must have happened.  Be prepared to have lost more of
> /dev/sda1 than you've yet discovered.
>
>> After looking around on the internet, I found people suggesting to
>> re-create the raid. It seems a bit extreme to me, but I cannot find
>> any other solution=E2=80=A6
>
> Unfortunately, yes.  You are past the point of a forced assembly or
> other normal operations.
>
>> Luckily I saved the original command used to create this array. Here
>> is the one I think would be relevant in this case :
>>
>> mdadm --create --verbose --assume-clean /dev/md0 --level=3D5
>> --metadata=3D1.2 --chunk=3D128 --raid-devices=3D4 /dev/sda1 /dev/sdb=
1
>> /dev/sdc1 missing /dev/sdd
>
> 1) Leave off /dev/sdd
> 2) Include --data-offset=3D262144
>
> If it runs and you can access the filesystem (I suspect not), set up =
a
> partition on sdd and add that to your array.  Use zero-superblock to
> blow away the stale superblock on sdd.
>
> If it doesn't work due to more sda1 damage and you end up starting ov=
er,
> consider wiping all of those partition tables and creating the new ar=
ray
> on all bare devices.  That'll minimize the chance of a misidentified
> device later.
>
> You'll want to investigate the health of sdd.  If it's healthy, then =
its
> drop-out must have been for some other reason.  You'll want to ensure
> that doesn't happen again.
>
> Consider browsing the archives and/or subscribing to learn the many
> pitfalls for the unwary (hint: try searching for "timeout mismatch").
>
> Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
