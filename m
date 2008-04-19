From: "David Lethe" <david@santools.com>
Subject: RE: Software/ Hardware RAID info
Date: Fri, 18 Apr 2008 19:19:14 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C087DB6@34093-C3-EVS3.exchange.rackspace.com>
References: <1208560939.7243.146.camel@isis>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <1208560939.7243.146.camel@isis>
Sender: linux-raid-owner@vger.kernel.org
To: Rick Bragg <lists@gmnet.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The simple answer is that nobody can give you anything but a generic
answer unless you supply much more data.

Basically, you want to consider the RAID controller, logical disk(s),
HBA, file system, kernel settings, cache settings on O/S, disk drivers,
RAID controller, and queue depths, buffer memory, and such ... to
minimize the number of times it has to go to disk.  Are you cpu bound,
or I/O bound, what controllers do you have, 

Do you have 15K.5 SAS disks or are you using SATA drives?  Are you
interested I IOPS or throughput?  Large or small-block, or mixed? Video
streaming ???  Random or sequential?  Where are the hotspots and how big
are they?  Write intensive or read intensive.  What kernel? Using PCI-e,
PCI slots?  Running a mailserver, database, general accounting, video
streaming?  Ifyou have a primary application the system is running, then
first consult the software vendor. They know how their software
interacts with a file system and can generally make decent suggestions.

Effectively, you said you just bought a transportation device to take
things places.  At least by giving me the Dell model I can at least
recommend a train, hovercraft, car, or F16 .. but you certainly didn't
give me anything about destination, how much cargo you have, how quickly
it needs to get there, frequency of trips, or the insurance deductable
(analogy RAID1, RAID5, or RAID6).

I'm a little sarcastic now, sorry, don't really mean it.  You did the
write thing to ask before you set it up.  For what it is worth, if you
got a contract from Dell, then they will typically spend time on the
phone at least helping you figure out the basics. Drop me a private
message and if you want to call me for a few mins, I'll help you out. 

David @ santools ^com

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Rick Bragg
Sent: Friday, April 18, 2008 6:22 PM
To: linux-raid@vger.kernel.org
Subject: Software/ Hardware RAID info

Hi,

I am new to setting up RAID arrays, and I have experimented in the past
with software only RAID, but now I have a new Dell PowerEdge 1900 with a
SAS RAID controller daughter card.  

My question is: What is the difference in tools that I will use to
create and manage this hardware array?  Can I still use all the same
techniques and tools such as mdadm, LVM2, and GParted to manage my
array? or is it all in the bios.

Another question is how should I format these disks?  Typically I would
use a root file system, and a swap file system that is twice the size of
my memory.  Since all four of my disks are used for hardware RAID, can I
partition this into 2 array's? one for my root, and the other for
swap...

Any advice into setting this up is greatly appreciated.

Thanks
Rick

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


