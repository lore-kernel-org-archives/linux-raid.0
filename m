From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: SOLVED Re: vess raid stripes disappear
Date: Fri, 10 May 2013 09:17:11 -0500
Message-ID: <518D0167.1070809@hardwarefreak.com>
References: <CANSWD74J9HZCbE4ba1Y5UMRQjjDDZiof21-tUJOKdJmHBvuyXw@mail.gmail.com> <518CA7F6.4000000@hardwarefreak.com> <CANSWD75Hp9caU92Gf5vUsh3W=9bJVJJrQ0ijHOJyn3eYyq8CWA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANSWD75Hp9caU92Gf5vUsh3W=9bJVJJrQ0ijHOJyn3eYyq8CWA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mashtin.bakir@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/10/2013 7:44 AM, mashtin.bakir@gmail.com wrote:
> Thanks for your reply. When I run the identical commands on the otherwise

We need to get on the same page here, using the same terminology.

What commands?  Are you referring to Linux commands or Promise RAID GUI
commands?  There are no Linux commands that you would execute WRT an
external hardware RAID device.

> identical raid, stripes do get created and retained. 

Please explain what you mean by "stripes do get created and retained".
Define "stripe" in this context.  Is this a term Promise uses in their
documentation?  I've used many brands of hardware RAID/SAN devices but
not Promise, which is pretty low end gear.

In industry standard parlance/jargon, with hardware RAID units, one
creates a RAID set consisting of a number of physical disks, a RAID
level, and a strip/chunk size.  One then creates one or more of what are
typically called logical drives or virtual drives which are portions
carved out of the RAID set capacity.  Then one assigns a LUN to each of
these logical/virtual drives and exports the LUN through one or more
external interfaces, be they SAS/SATA, fiber channel, or iSCSI.

> But just to eliminate the
> possibility, I re-created a couple of stripes without setting the raid flag and
> once again, when the raid chassis was rebooted, they disappeared. 

Why are you rebooting the RAID box?  That should never be necessary but
possibly after a firmware upgrade.  This sounds like a SCSI hot plug
issue.  You said this is with RHEL 5 correct?  Is your support contract
with Red Hat still active?  If so I'd definitely talk to them about
this.  If not, I'll do the best I can to assist.

> I'm
> thinking at this point that it's a hardware problem with the RAID controller.
> Does that sound likely?

It's possible, but the problem you're describing doesn't appear to be
hardware related, not in absence of errors in dmesg.  You've provided
none so I assume there are none.  It sounds like a GPT problem.
Eliminating the RAID flag should have fixed it.  Keep in mind my ability
to assist is limited by the quantity, accuracy, and relevance of the
information you provide.  Thus far you're "telling" us what appears to
be wrong but you're not "showing" us.  I.e. logs, partition tables, etc.

To eliminate possible partition issues as the cause of your problem,
directly format a LUN that has no partitions associated with it.  If you
do this by reusing a LUN that has already been partitioned, delete the
partitions first.  It is preferably to us a clean LUN though to
eliminate partitioning completely from the test.

-- 
Stan


> On Fri, May 10, 2013 at 3:55 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> On 5/9/2013 6:29 AM, mashtin.bakir@gmail.com wrote:
>>> I have an interesting problem with a Vessraid 1830s.
>>> We have a few of these that work fine but one seems
>>> to lose its filesets. The only difference between the
>>> good ones and the bad one is that the bad one has firmware
>>> version 3.06 while the good ones are at 3.05 (This may
>>> not be relevant).
>>
>> It's not a firmware problem Mashtin.  The problem here is incomplete
>> education.  More accurately, the problem is that you've confused
>> concepts of hardware RAID and Linux software RAID.  I will attempt to
>> help you separate these so you understand the line in the sand
>> separating the two.
>>
>>> Here's what happens. If I plug the raid into a 32 bit
>>> RHEL5 box with large files enabled, syslog does pick
>>> it up:
>>>
>>> kernel: Vendor: Promise  Model:VessRAID 1830s Rev: 0306
>>> Type: Direct-Access     ANSI SCSI revision: 05
>>> SCSI device sdc:2929686528 2048-byte hdwr sectors (5999998 MB)
>>
>> The kernel sees a single 6TB SCSI device/LUN presented by the Promise
>> array..
>>
>>> Using the web gui, I can carve out partitions,
>>
>> The Promise web gui doesn't create partitions.  That's the job of the
>> operating system.  What it does allow you to do is carve out multiple
>> virtual drives from a single RAID set and export them as individual LUNs.
>>
>>> I make three stripes across 4 disks of 2Terabytes each
>>> using RAID5.
>>
>> This is not possible with the Promise firmware.  I think you're simply
>> using incorrect terminology here.  According to your dmesg output above
>> you have created a single hardware RAID5 array of 4 disks, one 6TB
>> virtual drive, and exported it as a single LUN.
>>
>> ...
>>> I then use gnu-parted (v3.1) to make the
>>> filesets:
>>
>> parted doesn't create "filesets".  It creates partitions.  What are
>> "filesets"?
>>
>>> mklabel gpt
>>> mkpart primray 0 0
>>
>> Ok so you created a primary partition.
>>
>>> set 1 raid on
>>
>> ^^^^^^^^^^^^^^^
>>
>> THIS IS THE PROBLEM.  "set 1 raid on" is used exclusively with Linux
>> software RAID.  What this does is tell the Kernel to look for a software
>> RAID superblock on the partition and auto start the array.  You are not
>> using md/RAID, but hardware RAID, so the superblock doesn't exist.  This
>> is the source of your problem.  This is where you have confused hardware
>> and software RAID concepts.
>>
>>> I create the fileset using
>>
>> Ok so when you say "fileset" you actually mean "file system".
>>
>>> mkfs.ext3 -m0 /dev/sdc1
>>> I can then mount the FS and write to it.
>>>
>>> If I either reboot the RAID or the host, the FS disappears
>>> ie cat/proc/partitions   shows only sdc, not sdc1.
>>> If I go back into parted, the label is intact
>>> But I can't even mkfs without re-creating the label/partition,
>>> in wich case I get:
>>
>> This is a direct result of "set 1 raid on" as explained above.  You
>> should see other error messages in dmesg about no superblock being found.
>>
>>> ...Have been written, but we have been
>>> unable to
>>> inform the kernel of the change, probably because it/they are in use.  As a
>>> result, the old partition(s) will remain in use.  You should reboot now
>>> before
>>> making further changes.
>>> Ignore/Cancel? i
>>
>> Clearing the parted RAID flag on the partition should fix your problem,
>> assuming you haven't done anything else wonky WRT software RAID and this
>> partition that hasn't been presented here.
>>
>> Always remember this:  Any time your see "RAID" setup or configuration
>> referenced in Linux documentation or cheat sheets on the web, it is
>> invariably referring to a kernel software function, either md/RAID,
>> dm-raid, etc.  It is never referring to hardware RAID devices.  If you
>> have a hardware RAID device you will never configure anything RAID
>> related in Linux, whether it be parted, grub, md, dm, etc.
>>
>> --
>> Stan
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

