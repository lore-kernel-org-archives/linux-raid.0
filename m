From: Christopher White <linux@pulseforce.com>
Subject: Re: mdadm does not create partition devices whatsoever, "partitionable"
 functionality broken
Date: Fri, 13 May 2011 19:18:39 +0200
Message-ID: <4DCD67EF.1070602@pulseforce.com>
References: <4DCD4A83.8060202@pulseforce.com> <4DCD6119.3080705@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DCD6119.3080705@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil, thanks for the response!

On 5/13/11 6:49 PM, Phil Turmel wrote:
> Hi Christopher,
>
> On 05/13/2011 11:13 AM, Christopher White wrote:
>> Greetings.
>>
>> I have spent TEN hours trying everything other than regressing to a REALLY old version. I started out on 3.1.4 and have also tried manually upgrading to 3.2.1, but the bug still exists.
>>
>> Somewhere along the way, the "auto" partitionable flag has broken.
>>
>> sudo mdadm --create --level=raid5 --auto=part2 /dev/md1 --metadata=1.2 --raid-devices=4 /dev/sda2 /dev/sdb2 /dev/sdc2 /dev/sdd2
>>
>> This only creates /dev/md1. It is of course possible to create one big partition as /dev/md1p1 with any partitioning program, but FORGET about trying to create /dev/md1p2.
> What exactly did fdisk or parted report when you tried to partition /dev/md1 ?
I run "sudo gparted /dev/md1" to access the whole RAID array, since I 
like the GUI for precisely creating partitions. When making two ext4 
partitions and applying the changes, it successfully creates /dev/md1p1 
(which does not exist before this operation is performed). It then goes 
on to trying to create md1p2 and it sends the commands to the md1 
device, but md1p2 is never created. After the step of creating the 
partition (which failed, but gparted does not know that), it tries to 
set up the file system, which fails since there is no md1p2:
mkfs.ext4 -j -O extent -L "" /dev/md1p2
"mke2fs 1.41.14 (22-Dec-2010)
Could not stat /dev/md1p2 --- No such file or directory"
>> The problem is that the RAID array is NOT created in partitionable mode, and only supports one large partition, despite ALL attempts at EVERY format of the --auto option, you name it, -a part2, --auto=mdp2, --auto=part2, --auto=p2, --auto=mdp, --auto=part, --auto=p, --auto=p4, you name it and I've tried it!
>>
>> My guess is the functionality of creating partitionable arrays literally DID break somewhere prior to/at version 3.1.4 which is the earliest version I tried.
> The mdadm<==>  kernel interface for this might be broken, but as a side-effect of the change to make all md devices support conventional partition tables.  I don't recall exactly when this changed, but it was several kernels ago.
>
> What kernel are you running?
Linux Mint 11 RC, which uses 2.6.38-8-generic.
>> I'm giving up and creating physical n-1 sized partitions on the source disks and creating two RAID 5 arrays from those partitions instead, but decided I really MUST report this bug so that other people don't bang their head against the wall for ten hours of their life as well. ;-)
> Consider trying "mdadm --create" without the "--auto" option at all, then fdisk on the resulting array.
>
> Phil
I've tried that as well during my testing since some postings suggested 
that leaving out the option will create a partitionable array, but it 
didn't.


Christopher
