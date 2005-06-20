From: "Nagpure, Dinesh" <Dinesh.Nagpure@stratus.com>
Subject: RE: md multipath restart problem
Date: Mon, 20 Jun 2005 10:34:53 -0400
Message-ID: <92952AEF1F064042B6EF2522E0EEF4376EE2F2@EXNA.corp.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: John Madden <jmadden@ivytech.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John,

Have you found a solution to the problem? If not then which kernel version are you using. The problem you are talking about seems like a bug in md that got fixed recently. 

-dinesh 

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org]On Behalf Of John Madden
Sent: Sunday, June 12, 2005 12:31 PM
To: linux-raid@vger.kernel.org
Subject: Re: md multipath restart problem


> When I stop it manually, then re-activate it:
>
> # ./mdadm -A /dev/md0
> mdadm: device 1 in /dev/md0 has wrong state in superblock, but
> /.dev/scsi/host1/bus0/target0/lun0/part1 seems ok
> mdadm: failed to add /.dev/scsi/host0/bus0/target0/lun0/part1 to /dev/md0:
> Device or resource busy
> mdadm: /dev/md0 has been started with 1 drive (out of 2).

FWIW, I found after more playing with it that rather than using -A, if I use
--build, I'm able to bring the raidset back up with both IO paths active.  Is
there a bug in -A with it not unlocking the devices a it traverses them to bring
them into the array?

Thanks,
  John



-- 
John Madden
UNIX Systems Engineer
Ivy Tech Community College of Indiana
jmadden@ivytech.edu

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
