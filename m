From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: RAID6 - repeated hot-pulls issue
Date: Sat, 21 Jan 2012 19:16:48 +0200
Message-ID: <CAGRgLy6BkFhWS_2JfVgAuniLX3A1i3N_hBMjtnjAX3J0Ms8Xpg@mail.gmail.com>
References: <CALwOXvL6avy3f76TcpMdMxqObCRY-SphRErjo-j1=iun-etBpA@mail.gmail.com>
	<20111205171540.4fe659e2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111205171540.4fe659e2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: John Gehring <john.gehring@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi John,
not sure if still relevant, but you may be affected by a bug in
2.6.38-8 kernel. We hit exactly the same issue with raid5/6.

Please take a look at this (long) email thread:
http://www.spinics.net/lists/raid/msg34881.html

Eventually (please look towards the end of the thread) Neil provided a
patch, which solved the issue.

Thanks,
  Alex.




On Mon, Dec 5, 2011 at 8:15 AM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 2 Dec 2011 09:34:40 -0700 John Gehring <john.gehring@gmail.co=
m> wrote:
>
>> I am having trouble with a hot-pull scenario.
>>
>> - linux 2.6.38.8
>> - LSI 2008 sas
>> - RAID6 via md
>> - 8 drives (2 TB each)
>>
>> Suspect sequence:
>>
>> 1 - Create Raid6 array using all 8 drives (/dev/md1). Each drive is
>> partitioned identically with two partitions. The second partition of
>> each drive is used for the raid set. The size of the partition varie=
s,
>> but I have been using a 4GB partition for testing in order to have
>> quick re-sync times.
>> 2 - Wait for raid re-sync to complete.
>> 3 - Start read-only IO against /dev/md1 via following command:=A0 dd
>> if=3D/dev/md1 of=3D/dev/null bs=3D1=A0 This step insures that pulled=
 drives
>> are detected by the md.
>> 4 - Physically pull a drive from the array.
>> 5 - Verify that the md has removed the drive/device from the array.
>> mdadm --detail /dev/md1 should show it as faulty and removed from th=
e
>> array.
>> 6 - Remove the device from the raid array:=A0 mdadm /dev/md1 -r /dev=
/sd[?]2
>> 7 - Re-insert the drive back into the slot.
>> 8 - Take a look at dmesg to see what device name has been assigned.
>> Typically has the same letter assigned as before.
>> 9 - Add the drive back into the raid array: mdadm /dev/md1 -a
>> /dev/sd[?]2=A0=A0 Now some folks might say that I should use --re-ad=
d, but
>> the mdadm documentation states that re-add will be used anyway if th=
e
>> system detects that a drive has been 're-inserted'. Additionally, th=
e
>> mdadm response to this command shows that an 'add' or 'readd' was
>> executed depending on the state of the disk inserted.
>> --All is apparently going fine at this point. The add command succee=
ds
>> and cat /proc/mdstat shows the re-sync in progress and it eventually
>> finishes.
>> --Now for the interesting part.
>> 10 - Verify that the dd command is still running.
>> 11 - Pull the same drive again.
>>
>> This time, the device is not removed from the array, although it is
>> marked as faulty in the /proc/mdstat report.
>>
>> In mdadm --detail /dev/md1, the device is still in the raid set and =
is
>> marked as "faulty spare rebuilding". I have not found a command that
>> will remove drive from the raid set at this point. There were a coup=
le
>> of instances/tests where after 10+ minutes, the device came out of t=
he
>> array and was simply marked faulty, at which point I could add a new
>> drive, but that has been the exception. Usually, it remains in the
>> 'faulty spare rebuilding' mode.
>>
>> I don't understand why there is different behavior the second time t=
he
>> drive is pulled. I tried zeroing out both partitions on the drive,
>> re-partitioning, mdadm --zero-superblock, but still the same behavio=
r.
>> If I pull a drive and replace it, I am able to do a subsequent pull =
of
>> the new drive without trouble, albeit only once.
>>
>> Comments? Suggestions? I'm glad to provide more info.
>>
>
> Yes, strange.
>
> The only think that should stop you being able to remove the device i=
s if
> there are outstanding IO requests.
>
> Maybe the driver is being slow in aborting requests the second time. =
=A0Could
> be a driver bug on the LSI.
>
> You could try using blktrace to watch all the requests and make sure =
every
> request that starts also completes....
>
> NeilBrown
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
