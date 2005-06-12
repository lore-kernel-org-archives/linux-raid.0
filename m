From: "John Madden" <jmadden@ivytech.edu>
Subject: Re: md multipath restart problem
Date: Sun, 12 Jun 2005 11:31:00 -0500 (EST)
Message-ID: <4383.10.0.14.177.1118593860.squirrel@postal2.ivytech.edu>
References: <59129.10.0.15.208.1118441273.squirrel@postal2>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59129.10.0.15.208.1118441273.squirrel@postal2>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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

