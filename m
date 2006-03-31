From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: mdadm and large RAID
Date: Fri, 31 Mar 2006 15:05:44 -0500 (EST)
Message-ID: <Pine.LNX.4.62.0603311504360.24968@chaos.egr.duke.edu>
References: <442D8ABE.9000608@bigred.unl.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <442D8ABE.9000608@bigred.unl.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Cesar Delgado <cdelgad2@bigred.unl.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 31 Mar 2006 at 2:02pm, Cesar Delgado wrote

> Here's the story.  We purchased a box with ~8TB space.  It has 2 fiber 
> connections so, we thought, to maximize throughput into the device we could 
> build 2 RAIDs in hardware, on the box, and export each one out each fiber 
> channel and then create a striped raid of the two devices at the hardware 
> level.  Due to the way we created the 2 RAIDs each export is ~3TB.
>
> What we've tried.  We tried making a RAID 0 with mdadm over the two devices. 
> There appears and entry en /dev/mdstats showing the RAID. Then we try to put 
> XFS on it, the machine hard locks.  We tried formatting each separate device 
> and there were no problems.  The machine just hard-locks when I try to put 
> the filesystem on the RAID.

You're missing a lot of vital information: what distribution are you 
using, what version of mdadm, what fiber adapter, etc.

> There's not errors in the logs.  The machine freezes up too quickly.

Have you tried a serial console and or remote syslog?

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
