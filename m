From: John Gehring <john.gehring@gmail.com>
Subject: RAID6 - repeated hot-pulls issue
Date: Fri, 2 Dec 2011 09:34:40 -0700
Message-ID: <CALwOXvL6avy3f76TcpMdMxqObCRY-SphRErjo-j1=iun-etBpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am having trouble with a hot-pull scenario.

- linux 2.6.38.8
- LSI 2008 sas
- RAID6 via md
- 8 drives (2 TB each)

Suspect sequence:

1 - Create Raid6 array using all 8 drives (/dev/md1). Each drive is
partitioned identically with two partitions. The second partition of
each drive is used for the raid set. The size of the partition varies,
but I have been using a 4GB partition for testing in order to have
quick re-sync times.
2 - Wait for raid re-sync to complete.
3 - Start read-only IO against /dev/md1 via following command:=A0 dd
if=3D/dev/md1 of=3D/dev/null bs=3D1=A0 This step insures that pulled dr=
ives
are detected by the md.
4 - Physically pull a drive from the array.
5 - Verify that the md has removed the drive/device from the array.
mdadm --detail /dev/md1 should show it as faulty and removed from the
array.
6 - Remove the device from the raid array:=A0 mdadm /dev/md1 -r /dev/sd=
[?]2
7 - Re-insert the drive back into the slot.
8 - Take a look at dmesg to see what device name has been assigned.
Typically has the same letter assigned as before.
9 - Add the drive back into the raid array: mdadm /dev/md1 -a
/dev/sd[?]2=A0=A0 Now some folks might say that I should use --re-add, =
but
the mdadm documentation states that re-add will be used anyway if the
system detects that a drive has been 're-inserted'. Additionally, the
mdadm response to this command shows that an 'add' or 'readd' was
executed depending on the state of the disk inserted.
--All is apparently going fine at this point. The add command succeeds
and cat /proc/mdstat shows the re-sync in progress and it eventually
finishes.
--Now for the interesting part.
10 - Verify that the dd command is still running.
11 - Pull the same drive again.

This time, the device is not removed from the array, although it is
marked as faulty in the /proc/mdstat report.

In mdadm --detail /dev/md1, the device is still in the raid set and is
marked as "faulty spare rebuilding". I have not found a command that
will remove drive from the raid set at this point. There were a couple
of instances/tests where after 10+ minutes, the device came out of the
array and was simply marked faulty, at which point I could add a new
drive, but that has been the exception. Usually, it remains in the
'faulty spare rebuilding' mode.

I don't understand why there is different behavior the second time the
drive is pulled. I tried zeroing out both partitions on the drive,
re-partitioning, mdadm --zero-superblock, but still the same behavior.
If I pull a drive and replace it, I am able to do a subsequent pull of
the new drive without trouble, albeit only once.

Comments? Suggestions? I'm glad to provide more info.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
