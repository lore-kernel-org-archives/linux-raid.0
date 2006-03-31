From: Cesar Delgado <cdelgad2@bigred.unl.edu>
Subject: mdadm and large RAID
Date: Fri, 31 Mar 2006 14:02:06 -0600
Message-ID: <442D8ABE.9000608@bigred.unl.edu>
Reply-To: cdelgad2@bigred.unl.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I've been trying to create a very large RAID and have not been 
successful.  I thought this might be a good place to ask.

Here's the story.  We purchased a box with ~8TB space.  It has 2 fiber 
connections so, we thought, to maximize throughput into the device we 
could build 2 RAIDs in hardware, on the box, and export each one out 
each fiber channel and then create a striped raid of the two devices at 
the hardware level.  Due to the way we created the 2 RAIDs each export 
is ~3TB.

What we've tried.  We tried making a RAID 0 with mdadm over the two 
devices.  There appears and entry en /dev/mdstats showing the RAID. 
Then we try to put XFS on it, the machine hard locks.  We tried 
formatting each separate device and there were no problems.  The machine 
just hard-locks when I try to put the filesystem on the RAID.

Then I read somewhere that mdadm might not like having the individual 
parts that make up the RAID be >2TB.  We broke each one of the hardware 
~3TB partitions in half at the hardware level, so now we have four 
~1.5TB devices.  When we try to build a RAID 0 over these with mdadm we 
have the same result.  The machine hard locks when we try to format it.

There's not errors in the logs.  The machine freezes up too quickly.

Any help would be greatly appreciated.

-Cesar
