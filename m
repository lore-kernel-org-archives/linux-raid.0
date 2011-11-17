From: David Brown <david.brown@hesbynett.no>
Subject: Re: Idea: Dynamic growth of the md array
Date: Thu, 17 Nov 2011 21:26:43 +0100
Message-ID: <ja3qm4$iaj$1@dough.gmane.org>
References: <D32ED83685BD7643AC872D3EFF80E6BB0127480448@dc-ex1.power.com> <20111117200400.GC1746@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111117200400.GC1746@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17/11/11 21:04, Robin Hill wrote:
> On Thu Nov 17, 2011 at 11:53:59AM -0700, Terrance Hutchinson wrote:
>
>> Hi,
>>
>> I know that mdadm supports growth of an array through the grow command
>> but I would like to take it a step further. When a certain threshold
>> is reach (user defined or default value) the user is emailed and the
>> array is the grown to incorporate the next available disk or specified
>> disk. This lets the user know what happened as well as prevent
>> unnecessary downtime.
>>
>> The idea is to make the growth automatic if the user wishes it do so,
>> otherwise the existing behavior would be used.
>>
>> Do you think this would be a good feature for mdadm? I've already
>> begun working on it but wanted the community's opinion. If the overall
>> consensus is that it's not a good idea, I'll post the diff on my
>> website for those who would like it.
>>
> Sounds like a job for a user-space program to me. md/mdadm has no idea
> about free space - that's a filesystem issue. It'd be far easier for a
> user-space program to monitor that and fire off the appropriate
> commands to grow the array, LVM volume, filesystem, etc. as required.
>
> Cheers,
>      Robin
>

I would also think it makes more sense to put all your disks into the 
array in the first place (at the very least, as hot spares rather than 
just extra disks).  It might not make sense to partition all this space 
- that's where LVM comes in.  When I set up a server, I typically put 
all the disks in an md raid array, and use that as an LVM physical 
volume.  I use openvz virtualisation, with each openvz machine having 
its own LVM logical partition and file system - that keeps everything 
neat and separated, and makes it very easy to control and monitor the 
disk space used by each virtual server.  As I add more virtual servers, 
I make new partitions, and as a virtual server runs low on space, I can 
grow its logical partition (and corresponding filesystem) - without any 
pauses or downtime.

A user-space program that monitored the free space on these partitions, 
and grew the logical partitions automatically as necessary, might be 
worth using.  But I can't see any use for something that messed around 
with raid array resizing automatically.


