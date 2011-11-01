From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: possibly silly question (raid failover)
Date: Mon, 31 Oct 2011 20:38:16 -0400
Message-ID: <4EAF3F78.5060900@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Folks,

I've been exploring various ways to build a "poor man's high 
availability cluster."  Currently I'm running two nodes, using raid on 
each box, running DRBD across the boxes, and running Xen virtual 
machines on top of that.

I now have two brand new servers - for a total of four nodes - each with 
four large drives, and four gigE ports.

Between the configuration of the systems, and rack space limitations, 
I'm trying to use each server for both storage and processing - and been 
looking at various options for building a cluster file system across all 
16 drives, that supports VM migration/failover across all for nodes, and 
that's resistant to both single-drive failures, and to losing an entire 
server (and it's 4 drives), and maybe even losing two servers (8 drives).

The approach that looks most interesting is Sheepdog - but it's both 
tied to KVM rather than Xen, and a bit immature.

But it lead me to wonder if something like this might make sense:
- mount each drive using AoE
- run md RAID 10 across all 16 drives one one node
- mount the resulting md device using AoE
- if the node running the md device fails, use pacemaker/crm to 
auto-start an md device on another node, re-assemble and republish the array
- resulting in a 16-drive raid10 array that's accessible from all nodes

Or is this just silly and/or wrongheaded?

Miles Fidelman

-- 
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


