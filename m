From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: accessing windows raid with mdadm?
Date: Sat, 04 Nov 2006 11:53:57 -0500
Message-ID: <454CC5A5.4030202@steeleye.com>
References: <1162419372.4743.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1162419372.4743.6.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Shaya Potter <spotter@yucs.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Shaya Potter wrote:
> [please cc: me on responses]
> 
> if one read Documentation/fs/ntfs.txt in the linux kernel, it talks
> about accessing windows raid volumes in Linux
> 
> If one is using non raid-5, one can use the device mapper, but if one is
> using raid-5, one has to use the md driver. 
> 
> However, it seems to be about using raidtools (raidtab and the like).
> Can anyone who understand raidtools and mdadm translate the instructions
> to mdadm, as that would seem to be what most of us use today?

The biggest thing here is that, since Windows stores its RAID 
information in this LDM area, which is outside the partitions 
themselves, there is no room for an md superblock at the end of each 
partition (even if the RAID information was on each partition, it's 
doubtful there would be room for an md superblock). So you have to 
assemble the array without superblocks, or else the md superblocks will 
overwrite data.

There is currently no way to "Build" (i.e., assemble an array without 
using superblocks) a raid5 array using mdadm. I don't know if raidtools 
would allow that or not. Building arrays without superblocks is 
generally risky (since device states and roles are not persistently 
tracked) for anything other than simple non-RAID arrays, or read-only 
access to your data.

--
Paul
