From: Can Sar <csar@stanford.edu>
Subject: Raid Recovery after Machine Failure
Date: Sat, 12 Mar 2005 17:54:20 -0800
Message-ID: <94a5aa6f5e94171df4c070e741014f02@stanford.edu>
Mime-Version: 1.0 (Apple Message framework v619.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am working with a research group that is currently building a tool to 
automatically find bugs in file systems, and related questions. We are 
trying to check whether file systems really guarantee the consistencies 
they promise, and one aspect we are looking at is running them on top 
of Raid devices. In order to do this we have to understand a few things 
about the Linux Raid driver/tools and I haven't been able to figure 
this out from the documention/source code, so maybe you can help me.
I asked this same question a few days ago, but I think I didn't really 
state it clearly, so let me try to rephrase it.

For Raid 4-6 and for say 5 disks say we write a block that is striped 
across all the disks, and after 4 of the disks write their part of the 
block to disk the machine crashes without the 5th disk being able to 
complete the write. Because of this, the checksum for this stripe 
should be incorrect, right?

The raid array is a Linux soft raid array set up using mdadm, and none 
of the disks actually crashed or wrote had any errors during this 
operation (the machine crashed for some other reason) We then reboot 
the machine and recreate the array, then remount it and then try to 
read the sector that was previously written (that has an incorrect 
checksum). At what point will the raid driver discover that something 
is wrong? Will it ever (I feel that it should discover this during the 
read at latest). Will it try to perform any kind of recovery or simply 
fail?
How would this change if only 3 of the 5 disk writes made it to disk? 
Fixing the error would be impossible of course (at least with Raid 4 
and 5, i know little about 6), but detection should still work. Will 
the driver complain?

Thank you so very much for your help,
Can

