From: Arshavir Grigorian <ag@m-cam.com>
Subject: Re: [PERFORM] Postgres on RAID5
Date: Mon, 14 Mar 2005 16:03:43 -0500
Message-ID: <4235FC2F.9060000@m-cam.com>
References: <4231F5F2.6000509@m-cam.com> <87hdje7sjm.fsf@stark.xeocode.com> <33c6269f050314115339b6861d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <33c6269f050314115339b6861d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Turner <armtuk@gmail.com>
Cc: Greg Stark <gsstark@mit.edu>, linux-raid@vger.kernel.org, pgsql-performance@postgresql.org
List-Id: linux-raid.ids

Alex Turner wrote:
> a 14 drive stripe will max out the PCI bus long before anything else,
> the only reason for a stripe this size is to get a total accessible
> size up.  A 6 drive RAID 10 on a good controller can get up to
> 400Mb/sec which is pushing the limit of the PCI bus (taken from
> offical 3ware 9500S 8MI benchmarks).  140 drives is not going to beat
> 6 drives because you've run out of bandwidth on the PCI bus.
> 
> The debait on RAID 5 rages onward.  The benchmarks I've seen suggest
> that RAID 5 is consistantly slower than RAID 10 with the same number
> of drivers, but others suggest that RAID 5 can be much faster that
> RAID 10 (see arstechnica.com) (Theoretical performance of RAID 5 is
> inline with a RAID 0 stripe of N-1 drives, RAID 10 has only N/2 drives
> in a stripe, perfomance should be nearly double - in theory of
> course).
> 
> 35 Trans/sec is pretty slow, particularly if they are only one row at
> a time.  I typicaly get 200-400/sec on our DB server on a bad day.  Up
> to 1100 on a fresh database.

Well, by putting the pg_xlog directory on a separate disk/partition, I 
was able to increase this rate to about 50 or so per second (still 
pretty far from your numbers). Next I am going to try putting the 
pg_xlog on a RAID1+0 array and see if that helps.

> I suggested running a bonnie benchmark, or some other IO perftest to
> determine if it's the array itself performing badly, or if there is
> something wrong with postgresql.
> 
> If the array isn't kicking out at least 50MB/sec read/write
> performance, something is wrong.
> 
> Until you've isolated the problem to either postgres or the array,
> everything else is simply speculation.
> 
> In a perfect world, you would have two 6 drive RAID 10s. on two PCI
> busses, with system tables on a third parition, and archive logging on
> a fourth.  Unsurprisingly this looks alot like the Oracle recommended
> minimum config.

Could you please elaborate on this setup a little more? How do you put 
system tables on a separate partition? I am still using version 7, and 
without tablespaces (which is how Oracle controls this), I can't figure 
out how to put different tables on different partitions. Thanks.


Arshavir



> Also a note for interest is that this is _software_ raid...
> 
> Alex Turner
> netEconomist
> 
> On 13 Mar 2005 23:36:13 -0500, Greg Stark <gsstark@mit.edu> wrote:
> 
>>Arshavir Grigorian <ag@m-cam.com> writes:
>>
>>
>>>Hi,
>>>
>>>I have a RAID5 array (mdadm) with 14 disks + 1 spare. This partition has an
>>>Ext3 filesystem which is used by Postgres.
>>
>>People are going to suggest moving to RAID1+0. I'm unconvinced that RAID5
>>across 14 drivers shouldn't be able to keep up with RAID1 across 7 drives
>>though. It would be interesting to see empirical data.
>>
>>One thing that does scare me is the Postgres transaction log and the ext3
>>journal both sharing these disks with the data. Ideally both of these things
>>should get (mirrored) disks of their own separate from the data files.
>>
>>But 2-3s pauses seem disturbing. I wonder whether ext3 is issuing a cache
>>flush on every fsync to get the journal pushed out. This is a new linux
>>feature that's necessary with ide but shouldn't be necessary with scsi.
>>
>>It would be interesting to know whether postgres performs differently with
>>fsync=off. This would even be a reasonable mode to run under for initial
>>database loads. It shouldn't make much of a difference with hardware like this
>>though. And you should be aware that running under this mode in production
>>would put your data at risk.
>>
>>--
>>greg
>>
>>
>>---------------------------(end of broadcast)---------------------------
>>TIP 9: the planner will ignore your desire to choose an index scan if your
>>      joining column's datatypes do not match
>>


-- 
Arshavir Grigorian
Systems Administrator/Engineer
M-CAM, Inc.
ag@m-cam.com
+1 703-682-0570 ext. 432
Contents Confidential
