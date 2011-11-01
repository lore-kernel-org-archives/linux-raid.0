From: David Brown <david@westcontrol.com>
Subject: Re: possibly silly question (raid failover)
Date: Tue, 01 Nov 2011 10:14:43 +0100
Message-ID: <j8odkj$46h$1@dough.gmane.org>
References: <4EAF3F78.5060900@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EAF3F78.5060900@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/11/2011 01:38, Miles Fidelman wrote:
> Hi Folks,
>
> I've been exploring various ways to build a "poor man's high
> availability cluster." Currently I'm running two nodes, using raid on
> each box, running DRBD across the boxes, and running Xen virtual
> machines on top of that.
>
> I now have two brand new servers - for a total of four nodes - each with
> four large drives, and four gigE ports.
>
> Between the configuration of the systems, and rack space limitations,
> I'm trying to use each server for both storage and processing - and been
> looking at various options for building a cluster file system across all
> 16 drives, that supports VM migration/failover across all for nodes, and
> that's resistant to both single-drive failures, and to losing an entire
> server (and it's 4 drives), and maybe even losing two servers (8 drives).
>
> The approach that looks most interesting is Sheepdog - but it's both
> tied to KVM rather than Xen, and a bit immature.
>
> But it lead me to wonder if something like this might make sense:
> - mount each drive using AoE
> - run md RAID 10 across all 16 drives one one node
> - mount the resulting md device using AoE
> - if the node running the md device fails, use pacemaker/crm to
> auto-start an md device on another node, re-assemble and republish the
> array
> - resulting in a 16-drive raid10 array that's accessible from all nodes
>
> Or is this just silly and/or wrongheaded?
>
> Miles Fidelman
>

One thing to watch out for when making high-availability systems and 
using RAID1 (or RAID10), is that RAID1 only tolerates a single failure 
in the worst case.  If you have built your disk image spread across 
different machines with two-copy RAID1, and a server goes down, then the 
rest then becomes vulnerable to a single disk failure (or a single 
unrecoverable read error).

It's a different matter if you are building a 4-way mirror from the four 
servers, of course.

Alternatively, each server could have its four disks set up as a 3+1 
local raid5.  Then you combine them all from different machines using 
raid10 (or possibly just raid1 - depending on your usage patterns, that 
may be faster).  That gives you an extra safety margin on disk problems.

But the key issue is to consider what might fail, and what the 
consequences of that failure are - including the consequences for 
additional failures.

