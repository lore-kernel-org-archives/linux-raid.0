From: David Greaves <david@dgreaves.com>
Subject: Re: Raid Recovery after Machine Failure
Date: Sun, 13 Mar 2005 09:47:49 +0000
Message-ID: <42340C45.7060905@dgreaves.com>
References: <94a5aa6f5e94171df4c070e741014f02@stanford.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <94a5aa6f5e94171df4c070e741014f02@stanford.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Can Sar <csar@stanford.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I *think* this is correct.
I'm a user, not a coder.
If nothing else it should help you search the archives for clarification :)

In general I think the answer lies around md's superblocks

Can Sar wrote:

> Hi,
>
> I am working with a research group that is currently building a tool 
> to automatically find bugs in file systems, and related questions. We 
> are trying to check whether file systems really guarantee the 
> consistencies they promise, and one aspect we are looking at is 
> running them on top of Raid devices. In order to do this we have to 
> understand a few things about the Linux Raid driver/tools and I 
> haven't been able to figure this out from the documention/source code, 
> so maybe you can help me.
> I asked this same question a few days ago, but I think I didn't really 
> state it clearly, so let me try to rephrase it.
>
> For Raid 4-6 and for say 5 disks say we write a block that is striped 
> across all the disks, and after 4 of the disks write their part of the 
> block to disk the machine crashes without the 5th disk being able to 
> complete the write. Because of this, the checksum for this stripe 
> should be incorrect, right?

If I understand correctly, the superblocks are updated after each device 
sync - in this case superblock on disk 5 is different to 1-4. This means 
that disk 5 is kicked on restart and the array re-syncs using 1-4 to 
verify or write (not sure) disk 5.

> The raid array is a Linux soft raid array set up using mdadm, and none 
> of the disks actually crashed or wrote had any errors during this 
> operation (the machine crashed for some other reason) We then reboot 
> the machine and recreate the array,

this should be 'automatic'
It's not so much 'recreate' (special recovery related meaning in md 
terminology) as 'start the md device'

> then remount it and then try to read the sector that was previously 
> written (that has an incorrect checksum). At what point will the raid 
> driver discover that something is wrong?

as it starts it checks the superblock sequence number, notices that one 
disk is wrong and not use it.

> Will it ever (I feel that it should discover this during the read at 
> latest). Will it try to perform any kind of recovery or simply fail?

so, since the superblock is wrong it starts in 'degraded' mode and resyncs.

> How would this change if only 3 of the 5 disk writes made it to disk? 
> Fixing the error would be impossible of course (at least with Raid 4 
> and 5, i know little about 6), but detection should still work. Will 
> the driver complain?

I don't know what happens if the superblock fails to update on say, 3 
out of 6 disks in an array.
The driver _will_ complain.

Newer kernels have an experimental fail facility that you may be 
interested in:
CONFIG_MD_FAULTY:
The "faulty" module allows for a block device that occasionally returns
read or write errors.  It is useful for testing.

HTH

David
