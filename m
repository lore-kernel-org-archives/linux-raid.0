From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: mdadm issue adding components to an array (avail_size /     
 array_size issue).
Date: Mon, 11 May 2009 12:05:26 +0100
Message-ID: <4A080676.6080106@mpstor.com>
References: <4A02F95C.9000106@mpstor.com> <21ae4b77ea9418bc5a6cc3aac0250ad7.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21ae4b77ea9418bc5a6cc3aac0250ad7.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
> On Fri, May 8, 2009 1:08 am, Benjamin ESTRABAUD wrote:
>   
>> Hi,
>>
>> I am experiencing what seems to be a bug with mdadm which prevents me
>> from --add ing a disk in some specifics conditions.
>>
>> The current setup is as follow:
>>
>> -1 RAID 5 on 3* 26Gb block devices. > /dev/md/d0
>> -1 RAID 5 on 3*36Gb block devices. > /dev/md/d1
>> -1 RAID 5 on 3* 9Gb block devices. > /dev/md/d2
>>
>> No config file is being used. RAIDs are created as follow:
>>
>> mdadm - v2.6.9 - 10th March 2009
>>
>> ./mdadm --create -vvv --force --run --metadata=1.2 /dev/md/dX --level=5
>> --size=<sizeofraid> --chunk=64 --name=<name, like: 1356341> -n3
>> --bitmap=internal --bitmap-chunk=4096 --layout=ls /dev/<blockdev1>
>> /dev/<blockdev2> /dev/<blockdev3>
>>
>> - Several different size available block devices for adding to the
>> arrays (1*14Gb, 1*26Gb, 2*32Gb, etc.)
>>
>> If trying to --add a block device to the /dev/md/d0 RAID array after
>> degrading it, everything works fine as long as the device being added is
>> at least as big as the "component_size" size found in sysfs from
>> /dev/md_d0/md/component_size. Therefore, a 32Gb drive can be added to
>> the first array.
>>
>> However, trying to do the same procedure for the third RAID, using
>> either a 9Gb, 14Gb block device fails complaining that the device being
>> hot added is not large enough to join the array. Which is strange, since
>> after checking the /dev/md_d3/md/component_size, this value is much
>> lower than the size obtained for the block device being added.
>>
>> On another hand, degrading md/d1 and trying to add a 32Gb block device
>> to this array composed of 3*36Gb block devices does not complain that
>> the block device size is not large enough to join the array, and adds it
>> to /dev/md/d1, however, as a Failed (F) drive.
>>
>> In the second example, the hotAdd does not work on /dev/md/d1 that has
>> its smallest component size set to 9Gb as long as the drive being added
>> is not >= to the component size of /dev/md/d0's component size.
>>
>> After further checking in the mdadm source, I noticed that "array_size"
>> in Manage_subdevs from Manage.c is always the same, regardless of which
>> RAID we are trying to operate on.
>>
>> by examining the "get_component_size" method, I noticed the following:
>>
>>    if (major(stb.st_rdev) != get_mdp_major())
>>         sprintf(fname, "/sys/block/md%d/md/component_size",
>>             (int)minor(stb.st_rdev));
>>     else
>>         sprintf(fname, "/sys/block/md_d%d/md/component_size",
>>             (int)minor(stb.st_rdev)>>MdpMinorShift);"
>>
>>  >>> (int)minor(stb.st_rdev)>>MdpMinorShift) is always "0", therefore
>> the component size file is always the following:
>>
>> /sys/block/md_d0/md/component_size
>>
>> Whatever the md device is currently used, md/d1, or md/d2 etc.
>>     
>
> That is very odd.
> For /dev/md/d0, minor(stb.st_rdev) should be 0
> For /dev/md/d1, minor(stb.st_rdev) should be 64
> For /dev/md/d2, minor(stb.st_rdev) should be 128.
> so when shifted with >>MdpMinorShift, they should give values 0,1,2.
> So I cannot understand why it is always 0.
> And you put some more printfs in and see what the value of
> stb.st_rdev is in each case?
>
>
>   
Hi Neil,

Thank you very much for your reply, this is much appreciated.

This is technically my fault in this case, since I changed the default 
shifthing in md for testing purposes.

At least I know understand what went wrong there and can fix it on this 
system.

Thank you very much again for your help, which was very much 
appreciated, and sorry for reporting an issue with a non-standard kernel.

Ben.
>> The "get_component_size" seems to be using an integer, "fd" to find out
>> the size and return it.
>> However, fd is always the same value, "3", whatever RAID is being worked
>> on.
>>
>> this value seems to be generated in mdadm.c, in the main function:
>>
>> line 944: mdfd = open_mddev(devlist->devname, autof);
>>
>> This always returns "3" in my case.
>>     
>
> Yes.  mdfd is a "file descriptor".  It is simple a number use to identify
> a particular open file.  It will always be 3 in this case, but will
> refer to a different file (or device) depending on what
> devlist->devname was.
>
> NeilBrown
>
>
>   


