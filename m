From: David Greaves <david@dgreaves.com>
Subject: Badstripe proposal (was Re: Bad blocks are killing us!)
Date: Wed, 17 Nov 2004 13:21:20 +0000
Message-ID: <419B5050.1010501@dgreaves.com>
References: <200411162307.iAGN7lN28260@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200411162307.iAGN7lN28260@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Neil Brown' <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org, dean-list-linux-raid@arctic.org
List-Id: linux-raid.ids

Just for discussion...

Proposal:
md devices to have a badstripe table and space for re-allocation

Benefits:
Allows multiple block level failures on any combination of component md 
devices provided parity is not compromised.
Zero impact on performance in non-degraded mode.
No need for scanning (although it may be used as a trigger)
Works for all md personalities.

Overview:
Provide an 'on or off-array' store for any stripes impacted by block 
level failure.
Unlike a disk's badblock allocation this would be a temporary store 
since we'd insist on the underlying devices recovering fully from the 
problem before restoring full health.
This allows us to cope transiently and, in the event of non-recoverable 
errors, until the disk is replaced.

Downsides:
Resync'ing with multiple failing drives is more complex (but more resilient)
Some kind of store handler is needed.

Description:
I've structured this to look at the md driver, the userspace daemon, the 
store, failing drives and replacing and resync'ing drives.

md:
For normal md access the badstripe list has no entries and is ignored. A 
badstripe size check is required prior to each stripe access.

If a write error occurs, rewrite the stripe to a store noting, and 
marking bad, the originating (faulty) stripe (and offending 
device/block) in the badstripe table. The device is marked 'failing'.
If a read error occurs, attempt to reconstruct the stripe from the other 
devices then follow the write error path.

For normal md access against stripes appearing in the badstripe list:
* Lock the badstripe table against the daemon (and other md threads)
* Check the stripe is still in the bad stripe list
* If not then the userland daemon fixed it. Release lock. Carry on as 
normal.
* If so then read/write from the reserved area.
* Release badstripe lock.

Daemon:
A userland daemon could examine the reserved area, attempt a repair on a 
faulty stripe and, if it succeeds, could restore the stripe and mark the 
badstripe entry as clean thus freeing up the reserved area and restoring 
perfect health.
The daemon would:
* lock the badstripe table against md
* write the stripe back to the previously faulty area which shouldn't 
need locking against md since it's "not in use"
* correct the badstripe table
* release the lock
If the daemon fails then the badstripe entry is marked as unrecoverable.

If the daemon has failed to correct the error (unrecoverable in the 
badstripe table) then the drive should be kept as failing (not faulty) 
and should be replaced. The intention is to allow a failing drive to 
continue to be used in the event of a subsequent bad drive event.

The Store:
This could be reserved stripes at the start (?) of the component devices 
read/written using the current personality. Alternatively it could be a 
filesystem level store (possibly remote, on a resilient device or just 
in /tmp).

Failing drives:
 From a reading point of view it seems possible to treat a failing drive 
as a faulty drive - until the event of another read failure on another 
drive. In that case the read error case above could still access the 
failing drive to attempt a recovery. This may help in the event of 
recovery from a failing drive where you want to minimise load against 
it. It may not be worthwhile.
Writing would still have to continue to maintain sync.

Drive replacement + resync:
If multiple devices go 'failing' then how are they removed (since they 
are all in use). A spare needs to be added and then the resync code 
needs to ensure that one of the failing disks is synced to the spare. 
Then the failing disk is made faulty and then removed.

This could be done by having a progression:
failing
failing-pending-remove
faulty

As I said above a failing drive is not used for reads, only for writes.
Presumably a drive that is sync'ing is used for writes but not reads.
So if we add a good drive and mark it syncing and simultaneously mark 
the drive it replaces failing-pending-remove then the f-p-r drive won't 
be written to but is available for essential reads until the new drive 
is ready.

Some thoughts:
How much overhead is involved in checking each stripe read/write address 
against a *small* bad-stripe table. Probably none because most of the 
time, for a healthy md, the number of entries is 0.

Does the temporary space even have to be in the md space? Would it be 
easier to make it a file (not in the filesystem on the md device!!) This 
avoids any messing with stripe offsets etc.

I don't claim to understand md's locking - the stuff above is a 
simplistic start on the additional locking related to moving stuff in 
and out of the badstripes area. I don't know where contention is handled 
- md driver or fs.

This is essentially only useful for single (or at least 'few') badblock 
errors - is that a problem worth solving (from the thread title I assume 
so).

How intrusive is this? I can't really judge. It mainly feels like error 
handling - and maybe handing off to a reused/simplified loopback-like 
device could handle 'hits' against the reserved area.

I'm only starting to read the code/device drivers books etc etc so if 
I'm talking rubbish then I'll apologise for your time and keep quiet :)

David

Guy wrote:

>Neil said:
>"I hadn't thought about that yet.  I suspect there would be little
>point in doing a scan when there was no redundancy.  However a scan on
>a degraded raid6 that could still safely loose one drive would
>probably make sense."
>
>I agree.
>
>Also a RAID1 with 2 or more working devices.  Don't forget, some people have
>3 or more devices on the RAID1 arrays.  From what I have read anyway.
>
>Thanks,
>Guy
>
>-----Original Message-----
>From: Neil Brown [mailto:neilb@cse.unsw.edu.au] 
>Sent: Tuesday, November 16, 2004 6:04 PM
>To: Guy
>Cc: linux-raid@vger.kernel.org
>Subject: RE: Bad blocks are killing us!
>
>On Tuesday November 16, bugzilla@watkins-home.com wrote:
>  
>
>>This sounds great!
>>
>>But...
>>
>>2/  Do you intend to create a user space program to attempt to correct the
>>bad block and put the device back in the array automatically?  I
>>hope so.
>>    
>>
>
>Definitely.  It would be added to the functionality of "mdadm --monitor".
>
>  
>
>>If not, please consider correcting the bad block without kicking the
>>    
>>
>device
>  
>
>>out.  Reason:  Once the device is kicked out, a second bad block on
>>    
>>
>another
>  
>
>>device is fatal to the array.  And this has been happening a lot
>>lately.
>>    
>>
>
>This one of several things that makes it "a bit less trivial" than
>simply using the bitmap stuff.  I will keep your comment in mind when
>I start looking at this in more detail.  Thanks.
>
>  
>
>>3/  Maybe don't do the bad block scan if the array is degraded.  Reason:
>>    
>>
>If
>  
>
>>a bad block is found, that would kick out a second disk, which is fatal.
>>Since the stated purpose of this is to "check parity/copies are correct"
>>then you probably can't do this anyway.  I just want to be sure.  Also, if
>>during the scan, if a device is kicked, the scan should pause or abort.
>>    
>>
>The
>  
>
>>scan can resume once the array has been corrected.  I would be happy if
>>    
>>
>the
>  
>
>>scan had to be restarted from the start.  So a pause or abort is fine with
>>me.
>>    
>>
>
>I hadn't thought about that yet.  I suspect there would be little
>point in doing a scan when there was no redundancy.  However a scan on
>a degraded raid6 that could still safely loose one drive would
>probably make sense.
>
>NeilBrown
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>

