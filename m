From: "Patrick Tschackert" <Killing-Time@gmx.de>
Subject: Re: problems with dm-raid 6
Date: Mon, 21 Mar 2016 23:42:00 +0100
Message-ID: <trinity-226526b2-6058-40bf-a276-9c1b47a80b3b-1458600120646@3capp-gmx-bs35>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: lists@colorremedies.com, Andreas.Klauer@metamorpher.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Chris,

> From what I understand, no, the smartctl are after the scrub check.
That's correct, I ran those shortly before sending the OP.

> But it's an open question how long after device failure he
> actually noticed it before doing the rebuild and how he did that
> rebuild;

I noticed something was wrong directy after the reboot. I opened the LUKS container (which worked) and tried to mount the btrfs filesys, which didn't. After noticing the raid was in the state "clean, degraded", I triggered the restore by running mdadm --run, because i already had two hotspares present in the raid. So one of the hotspares was used to do the restore.
After that, i ran mdadm --readwrite /dev/md0, because the raid was set to read only. The problem with mounting the btrfs filesys still occurred.

> But at this point we need to hear back from Patrick.
Sorry for taking so long, long day at work :(

> You should not assemble the original RAID anymore anyhow, anything
> you write to the array at this point will likely only increase
> damages. The overlay allows you to experiment in read-"write"
> mode without actually changing anything on your disks.

> Agreed. If it turns out there are some repairs needed within Btrfs
> it's better with the overlay because it's unclear based on the errors
> thus far what repair step to use next, and some of these repair
> attempts can still sometimes make things worse (which are of course
> bugs, but nevertheless...)

I'll look into overlays and try that tomorrow, it's too late and i don't want to further screw this up by doing this half asleep :/
Based on your advice, I'll use an overlay on the array and then try to fix the btrfs filesystem. If I understand correctly, the dm overlay file would enable me to revert to the current state, in case the btrfs repair goes wrong?

Regards,
Patrick
