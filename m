From: Brian Schwarz <Brian.Schwarz@veritas.com>
Subject: RE: cluster RAID
Date: Tue, 27 May 2003 12:47:05 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <C587FF391BCAD411B8120008C7864670057DA55D@mtvxch07.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Steven Dake' <sdake@mvista.com>, Neil Brown <neilb@cse.unsw.edu.au>
Cc: Kai-Min Sung <k@kaisung.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'll apologize in advance for the blatant marketing.

Steven is correct, a clusterized volume manager with built in RAID
functionality would be ideal in this situation. VERITAS is plans to release
a software suite that includes clusterized versions of our volume manager
and the VERITAS File System. 

The VERITAS File System and Volume Manager are available today on Linux.
This includes RAID, online config changes, multi-pathing, etc... The
clusterized versions will be available towards the end of this year. The
clusterized versions use some of the clustering infrastructure from our
VERITAS Cluster Server offering, which is available today on Linux as well. 

For more info:
www.veritas.com/linux
www.veritas.com/forlinux

or contact me directly.

Regards,

-Brian

-----Original Message-----
From: Steven Dake [mailto:sdake@mvista.com]
Sent: Tuesday, May 27, 2003 12:25 PM
To: Neil Brown
Cc: Kai-Min Sung; linux-raid@vger.kernel.org
Subject: Re: cluster RAID


Cluster RAID (accessing one storage device from multiple nodes) is 
useful when using a clustered volume manager or clustered filesystem.  
Without clustered RAID underneath, it is difficult to provide redundancy 
unless the clustered volume manager provides this functionality (which 
it currently does not).

It is possible to deal with the consistency issue but requires node-node 
communication within the cluster, and hence, a cluster framework.

Thanks
-steve

Neil Brown wrote:

>On Sunday May 25, k@kaisung.com wrote:
>  
>
>>Hi,
>>	I have a shared storage environment (2 disks accessible by 2
>>nodes through iSCSI) and am trying to assemble the same RAID-1 array on
>>both nodes. Whenever I try to assemble the RAID-1 array on the second
>>node, it always begins reconstructing the mirror. My guess for why it's
>>doing this is that after the first node assembles the array, it marks a
>>dirty flag in the RAID metadata blocks on disk. (It only resets the
>>dirty flag when it deactivates the array). When the second node tries to
>>assemble the same array, it reads the metadata blocks and sees that it
>>is dirty. Then it proceeds with reconstruction. My question is does
>>reconstruction happen, simply because the dirty flag is set? Why doesn't
>>it first check if the checksums on all the mirror disks match (i.e. the
>>array is consistent) and bypass reconstruction? Btw, I plan for both
>>nodes to be accessing different partitions in the array, so there
>>shouldn't be any synchronization problems. Also, I'm using mdadm-1.2.0
>>for my testing.
>>    
>>
>
>What you are doing doesn't really make sense (at least not to me).
>
>Having two hosts both trying to control a raid1 array cannot work as
>neither host can make an guarantees about consistancy.
>
>If you plan for both nodes to be accessing different partitions on the
>array, why not be up-front about that and have two different raid1
>arrays.
>
>e.g. If your two drives are sda and sdb, then partition them into
>  sda1, sda2, sdb1, sdb2
>
>and then make md0 on node X from sda1 and sdb1, and
>   md3 (or whatever) on node Y from sda2 and sdb2.
>
>
>To answer your question - yes, the second node reconstucts because the
>super block is marked dirty.  I'm not sure what you mean by "check if
>the checksums on all mirror disks match".  What checksums?
>  checksums of all data blocks?  That is as much work as a complete resync
>  checksums of super blocks?  That wouldn't tell us anything useful.
>
>NeilBrown
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>  
>

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
