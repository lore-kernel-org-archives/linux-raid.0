From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: Re: Best option for SSD caching on a md raid array?
Date: Mon, 08 Feb 2016 16:45:27 +0100
Message-ID: <20160208164528.Horde.B-479OtKefXcjPgYlB52n2q@www3.nde.ag>
References: <1670804.QnHtKWfib8@nell> <56B85390.9050505@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56B85390.9050505@hesbynett.no>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Thomas Fjellstrom <thomas@fjellstrom.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi *,

Zitat von David Brown <david.brown@hesbynett.no>:
> Hi,
>
> If the server is going to have reasonably long uptimes, then lots of ram
> could easily be a better choice than an SSD caching system.
> [...] But the key point of an SSD cache is to get fast
> access to common data with random access patterns, since a raid array
> will give you plenty of bandwidth for large serial accesses.  And while
> an SSD is fast for random reads, having the data in the server's cache
> is even faster.

to me, the key point of SSD caching was fast (persistent) writes and  
optimization of expensive partial writes for RAID. Using memory  
caching helped, but keeping that much dirty data in RAM wasn't my cup  
of tea (it's what I had before moving to bcache).

Thomas, I decided to go the bcache route and am running two SAN/NAS  
servers for months, serving a mix of NFS (i.e. for home directories  
and large software compilation scenarios across multiple servers),  
Samba (for a few SMB-dependent machines), iSCSI and Fibre Channel  
(both via SCST) to serve various virtual disks to about 40 VMs, and a  
vanishing amount of other services.

I have not further explored the other options you name - but up to  
now, I've been sufficiently happy with bcache to see no need to run  
intensive compares.

Mateusz named pros and cons - for bcache, the lack of maintainer got  
somewhat resolved by others jumping in and i.e. SUSE putting an  
up-to-date (patched) bcache version in their kernels. What I feel  
missing in Mateusz' list is bcache's current lack of a live resizing  
feature: Even if you live-resize the back-end storage (i.e. RAID),  
you'll currently have to re-init the bcache device (i.e. by rebooting  
the node) for it to recognize the changed back-end size. Not good for  
your uptime.

Regards,
Jens

