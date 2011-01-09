From: NeilBrown <neilb@suse.de>
Subject: Re: What exactly does echo check > /sys/block/mdX/md/sync_action
 do?
Date: Mon, 10 Jan 2011 10:26:13 +1100
Message-ID: <20110110102613.692fa2e3@notabene.brown>
References: <4D2A3B25.6050504@digadd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D2A3B25.6050504@digadd.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Schmidt <charlie@digadd.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 09 Jan 2011 23:48:05 +0100 Christian Schmidt <charlie@digadd.de>
wrote:

> Hi all,
> 
> As the subject says, I'm wondering what issuing the "check" command to a
> raid array does.
> The wiki says it starts a full read of the raid array. However I wonder
> if all members, especially the parts of the drives containing the
> redundancy information, will be read, and possibly the validity of the
> redundancy data will be checked?

May I suggest
   man 4 md

and search for 'check'
???

       md/sync_action
              This can be used to monitor and control the resync/recovery pro-
              cess  of MD.  In particular, writing "check" here will cause the
              array to read all data block and check that they are  consistent
              (e.g.  parity  is correct, or all mirror replicas are the same).
              Any discrepancies found are NOT corrected.

              A count of problems found will be stored in md/mismatch_count.

              Alternately, "repair" can be written which will cause  the  same
              check to be performed, but any errors will be corrected.

              Finally, "idle" can be written to stop the check/repair process.


Does that answer your question?

A more recent man page says:

       md arrays can be scrubbed by writing either check or repair to the file
       md/sync_action in the sysfs directory for the device.

       Requesting a scrub will cause md to read every block on every device in
       the  array,  and  check  that  the  data  is consistent.  For RAID1 and
       RAID10, this means checking that the copies are identical.  For  RAID4,
       RAID5,  RAID6  this  means checking that the parity block is (or blocks
       are) correct.

       If a read error is detected during this process, the normal  read-error
       handling  causes  correct data to be found from other devices and to be
       written back to the faulty device.  In many case this will  effectively
       fix the bad block.

       If  all  blocks  read  successfully but are found to not be consistent,
       then this is regarded as a mismatch.


> 
> A possibly related question is: why did this member turn into "spare"
> role? The system was fully functional and in daily use for about a year.
> It was declared to be a four drive raid 5 with no spares. If I remember
> level 5 correctly there is no single drive for the redundancy data to
> avoid bottlenecks, right?

One would need to see the history of the whole array, not just the current
state of a single device, to be able to guess the reason for the current
state.

And yes:  RAID5 distributes the parity blocks to avoid bottlenecks.

> 
> alpha md # mdadm --examine --verbose /dev/sdh2
> /dev/sdh2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : fa8fb033:6312742f:0524501d:5aa24a28
>            Name : sysresccd:1
>   Creation Time : Sat Jul 17 02:57:27 2010
>      Raid Level : raid5
>    Raid Devices : 4
> 
>  Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
>      Array Size : 11714780160 (5586.04 GiB 5997.97 GB)
>   Used Dev Size : 3904926720 (1862.01 GiB 1999.32 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 172eb49b:03e62242:614d7ed3:1fb25f65
> 
>     Update Time : Sun Jan  9 19:55:09 2011
>        Checksum : a991f168 - correct
>          Events : 34
> 
>          Layout : left-symmetric
>      Chunk Size : 512K
> 
>    Device Role : spare
>    Array State : AAAA ('A' == active, '.' == missing)
> 
> Too bad that 1.2 superblocks don't contain the full array information
> like 0.90 did.

The extra information that 0.90 stored was not (and could not be) reliable.

This device thinks that that the array is functioning correctly with no
failed devices, and that this device is a spare - presumably a 5th device?
It doesn't know the names of the other devices (and if it thought it did, it
could easily be wrong as names changed).  What do the other devices think of
the state of the array?

NeilBrown

