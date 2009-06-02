From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Awful RAID5 random read performance
Date: Tue, 2 Jun 2009 21:47:04 +0200
Message-ID: <20090602194704.GA30639@rap.rap.dk>
References: <20090531154159405.TTOI3923@cdptpa-omta04.mail.rr.com> <200905311056.30521.tfjellstrom@shaw.ca> <4A25754F.5030107@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A25754F.5030107@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: tfjellstrom@shaw.ca, lrhorer@satx.rr.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 02, 2009 at 02:54:07PM -0400, Bill Davidsen wrote:
> Thomas Fjellstrom wrote:
>>
>> When I get around to it I may utilize the raid10 module for the VM's 
>> and backups. Though that may decrease performance a little bit in the 
>> small random io case.   

> The accesses on the VM will be similar to a real disk, so you want the  
> VM on whatever you would use for bare iron. I run on raid10, many of my  
> machines are on VM (including this one, my main desktop). Raid10 is a  
> good general use array, I use it for a lot, other than cases where I  
> need cheap space and use raid[56] to get more bytes/$ and don't need  
> blinding speed. Archival storage, for instance.

My perception is that raid10,f2 is probably the fastest also for small random
reads because of the lower latency, and faster transfer times due to only
using the outer disk sectors. For writes the elevator evens out the
ramdom access. Benchmarks may not show this effect as they are often
done on clean file systems, where the files are allocated in the
beginning of the fs.

For cases where you need cheap disk space, and have big files like
.iso's then raid5 could be a good choice because it has the most space
while maintaining fair to good performance for big files. 

In your case, using 3 disks, raid5 should give about 210 % of the nominal
single disk speed for big file reads, and maybe 180 % for big file
writes. raid10,f2 should give about 290 % for big file reads and 140%
for big file writes. Random reads should be about the same for raid5 and
raid10,f2 - raid10,f2 maybe 15 % faster, while random writes should be
mediocre for raid5, and good for raid10,f2.

best regards
keld
