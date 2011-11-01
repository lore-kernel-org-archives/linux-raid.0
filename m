From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: possibly silly question (raid failover)
Date: Tue, 01 Nov 2011 13:33:53 +0000
Message-ID: <4EAFF541.8010002@anonymous.org.uk>
References: <4EAF3F78.5060900@meetinghouse.net> <20111101092659.GA12805@vault> <4EAFEDFC.8090001@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EAFEDFC.8090001@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/11/2011 13:02, Miles Fidelman wrote:
> Johannes Truschnigg wrote:
>> Hi Miles,
>>
>> On Mon, Oct 31, 2011 at 08:38:16PM -0400, Miles Fidelman wrote:
>>> Hi Folks,
>>>
>>> I've been exploring various ways to build a "poor man's high
>>> availability cluster." Currently I'm running two nodes, using raid
>>> on each box, running DRBD across the boxes, and running Xen virtual
>>> machines on top of that.
>>> [...]
>> while I do note that I don't answer your question at hand, I'm still
>> inclined
>> to ask if you do know Ganeti (http://code.google.com/p/ganeti/) yet?
>> It offers
>> pretty much everything you seem to want to have.
>
> Actually I do know Ganeti, and it does NOT come close to what I'm
> suggesting:
> - it supports migration but not auto-failover
> - DRBD is the only mechanism it provides for replicating data across
> nodes - which limits migration to a 2-node pair

It might still do what I think you want: think of each of the four 
servers running 3 VMs (or groups of VMs) normally, and three servers 
running 4 VMs when one of the servers fails. Then for each VM you 
replicate its storage to another server, as follows:

Node A: VM A1->Node B; VM A2->Node C; VM A3->Node D
Node B: VM B1->Node C; VM B2->Node D; VM B3->Node A
Node C: VM C1->Node D; VM C2->Node A; VM C3->Node B
Node D: VM D1->Node A; VM D2->Node B; VM D3->Node C

So each node needs double the storage, because as well as its own VMs is 
has copies of one from each of the other nodes. When any node goes down, 
your cluster management makes all three of the others start up one more 
VM - isn't that what Ganeti means by "quick recovery in case of physical 
system failure" and "automated instance migration across clusters"?

I'd probably do some kind of RAID over the 4 disks on each server as 
well, and do live migrations when a drive fails in any one machine, so 
that the VMs don't suffer from the degraded RAID and the machine's 
relatively quiet while you're replacing the failed drive, but now we're 
getting into having to have perhaps double the storage again, and it's 
not looking like it's a poor man's solution after all - can you buy 4 
cheap commodity servers with double the storage and enough spare RAM for 
less than you could have bought 3 classy bulletproof ones?

Cheers,

John.
