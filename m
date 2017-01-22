From: Avi Kivity <avi@scylladb.com>
Subject: Re: raid0 vs. mkfs
Date: Sun, 22 Jan 2017 20:01:40 +0200
Message-ID: <06411e37-ee35-c8d9-a578-4a9cd2fbb0d9@scylladb.com>
References: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,


On 11/27/2016 05:24 PM, Avi Kivity wrote:
> mkfs /dev/md0 can take a very long time, if /dev/md0 is a very large 
> disk that supports TRIM/DISCARD (erase whichever is inappropriate).  
> That is because mkfs issues a TRIM/DISCARD (erase whichever is 
> inappropriate) for the entire partition. As far as I can tell, md 
> converts the large TRIM/DISCARD (erase whichever is inappropriate) 
> into a large number of TRIM/DISCARD (erase whichever is inappropriate) 
> requests, one per chunk-size worth of disk, and issues them to the 
> RAID components individually.
>
>
> It seems to me that md can convert the large TRIM/DISCARD (erase 
> whichever is inappropriate) request it gets into one TRIM/DISCARD 
> (erase whichever is inappropriate) per RAID component, converting an 
> O(disk size / chunk size) operation into an O(number of RAID 
> components) operation, which is much faster.
>
>
> I observed this with mkfs.xfs on a RAID0 of four 3TB NVMe devices, 
> with the operation taking about a quarter of an hour, continuously 
> pushing half-megabyte TRIM/DISCARD (erase whichever is inappropriate) 
> requests to the disk. Linux 4.1.12.
>

Did anyone pick this up by any chance?  The only thing I could find is 
more people complaining about the same issue.
