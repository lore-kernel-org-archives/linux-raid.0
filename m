From: Avi Kivity <avi@scylladb.com>
Subject: Re: raid0 vs. mkfs
Date: Mon, 28 Nov 2016 09:38:30 +0200
Message-ID: <286a5fc1-eda3-0421-a88e-b03c09403259@scylladb.com>
References: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com>
 <87oa108a1x.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87oa108a1x.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/28/2016 07:09 AM, NeilBrown wrote:
> On Mon, Nov 28 2016, Avi Kivity wrote:
>
>> mkfs /dev/md0 can take a very long time, if /dev/md0 is a very large
>> disk that supports TRIM/DISCARD (erase whichever is inappropriate).
>> That is because mkfs issues a TRIM/DISCARD (erase whichever is
>> inappropriate) for the entire partition. As far as I can tell, md
>> converts the large TRIM/DISCARD (erase whichever is inappropriate) into
>> a large number of TRIM/DISCARD (erase whichever is inappropriate)
>> requests, one per chunk-size worth of disk, and issues them to the RAID
>> components individually.
>>
>>
>> It seems to me that md can convert the large TRIM/DISCARD (erase
>> whichever is inappropriate) request it gets into one TRIM/DISCARD (erase
>> whichever is inappropriate) per RAID component, converting an O(disk
>> size / chunk size) operation into an O(number of RAID components)
>> operation, which is much faster.
>>
>>
>> I observed this with mkfs.xfs on a RAID0 of four 3TB NVMe devices, with
>> the operation taking about a quarter of an hour, continuously pushing
>> half-megabyte TRIM/DISCARD (erase whichever is inappropriate) requests
>> to the disk. Linux 4.1.12.
> Surely it is the task of the underlying driver, or the queuing
> infrastructure, to merge small requests into large requests.

Here's a blkparse of that run.  As can be seen, there is no concurrency, 
so nobody down the stack has any chance of merging anything.

259,1   10     1090     0.379688898  4801  Q   D 3238067200 + 1024 
[mkfs.xfs]
259,1   10     1091     0.379689222  4801  G   D 3238067200 + 1024 
[mkfs.xfs]
259,1   10     1092     0.379690304  4801  I   D 3238067200 + 1024 
[mkfs.xfs]
259,1   10     1093     0.379703110  2307  D   D 3238067200 + 1024 
[kworker/10:1H]
259,1    1      589     0.379718918     0  C   D 3231849472 + 1024 [0]
259,1   10     1094     0.379735215  4801  Q   D 3238068224 + 1024 
[mkfs.xfs]
259,1   10     1095     0.379735548  4801  G   D 3238068224 + 1024 
[mkfs.xfs]
259,1   10     1096     0.379736598  4801  I   D 3238068224 + 1024 
[mkfs.xfs]
259,1   10     1097     0.379753077  2307  D   D 3238068224 + 1024 
[kworker/10:1H]
259,1    1      590     0.379782139     0  C   D 3231850496 + 1024 [0]
259,1   10     1098     0.379785399  4801  Q   D 3238069248 + 1024 
[mkfs.xfs]
259,1   10     1099     0.379785657  4801  G   D 3238069248 + 1024 
[mkfs.xfs]
259,1   10     1100     0.379786562  4801  I   D 3238069248 + 1024 
[mkfs.xfs]
259,1   10     1101     0.379800116  2307  D   D 3238069248 + 1024 
[kworker/10:1H]
259,1   10     1102     0.379829822  4801  Q   D 3238070272 + 1024 
[mkfs.xfs]
259,1   10     1103     0.379830156  4801  G   D 3238070272 + 1024 
[mkfs.xfs]
259,1   10     1104     0.379831015  4801  I   D 3238070272 + 1024 
[mkfs.xfs]
259,1   10     1105     0.379844120  2307  D   D 3238070272 + 1024 
[kworker/10:1H]
259,1   10     1106     0.379877825  4801  Q   D 3238071296 + 1024 
[mkfs.xfs]
259,1   10     1107     0.379878173  4801  G   D 3238071296 + 1024 
[mkfs.xfs]
259,1   10     1108     0.379879028  4801  I   D 3238071296 + 1024 
[mkfs.xfs]
259,1    1      591     0.379886451     0  C   D 3231851520 + 1024 [0]
259,1   10     1109     0.379898178  2307  D   D 3238071296 + 1024 
[kworker/10:1H]
259,1   10     1110     0.379923982  4801  Q   D 3238072320 + 1024 
[mkfs.xfs]
259,1   10     1111     0.379924229  4801  G   D 3238072320 + 1024 
[mkfs.xfs]
259,1   10     1112     0.379925054  4801  I   D 3238072320 + 1024 
[mkfs.xfs]
259,1   10     1113     0.379937716  2307  D   D 3238072320 + 1024 
[kworker/10:1H]
259,1    1      592     0.379954380     0  C   D 3231852544 + 1024 [0]
259,1   10     1114     0.379970091  4801  Q   D 3238073344 + 1024 
[mkfs.xfs]
259,1   10     1115     0.379970341  4801  G   D 3238073344 + 1024 
[mkfs.xfs]


No merging was happening.  This is an NVMe drive, so running with the 
noop scheduler (which should still merge).   Does the queuing layer 
merge trims?

I don't think it's the queuing layer's job, though.  At the I/O 
scheduler you can merge to clean up sloppy patterns from the upper 
layer, but each layer should try to generate the best pattern it can.  
Large merges mean increased latency for the first request in the chain, 
forcing the I/O scheduler to make a decision which can harm the 
workload.  By generating merged requests in the first place, the upper 
layer removes the need to make that tradeoff (splitting the requests 
removes information: "we are interested only in when all of the range is 
trimmed, not any particular request").

