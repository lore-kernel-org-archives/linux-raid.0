From: David Brown <david@westcontrol.com>
Subject: Re: Direct disk access on IBM Server
Date: Wed, 20 Apr 2011 13:24:01 +0200
Message-ID: <iomfkq$qqr$1@dough.gmane.org>
References: <iok28i$tp6$1@dough.gmane.org> <4DADEBC3.9060404@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DADEBC3.9060404@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19/04/2011 22:08, Stan Hoeppner wrote:
> David Brown put forth on 4/19/2011 8:21 AM:
>> I have recently got an IBM x3650 M3 server, which has a "Serveraid
>> M5014" raid controller.  Booting from a Linux CD (system rescue CD) and
>> running lspci identifies this raid controller as:
>>
>> LSI Logic/Symbus Logic Megaraid SAS 2108 [Liberator] (rev 03)
>>
>> The controller works fine for hardware raid - I can open its bios setup
>> utility, and set up a RAID5 (or whatever) with the disks I have.  The OS
>> then just sees a single virtual disk.
>>
>> But I would like direct access to the sata drives - I want to set up
>> mdadm raid, under my own control.  As far as I can see, there is no way
>> to put this controller into "JBOD" or "direct access" mode of any sort.
>
> FYI, the ServeRAID 5014 is a good quality real hardware RAID card w/
>
> PCIe 2.0 x8 interface
> 800 MHz LSI PowerPC RAID on Chip ASIC
> 256MB DDRII cache RAM
> 8 x 6Gb/s SAS ports via 2 SFF8087
> 32 drives maximum, 16 drives max per virtual disk (RAID group)
>
> If your card has the RAID6 feature key installed, mdraid will likely
> gain you little, if anything, over the card's inbuilt features.
>

Yes, I can see the card is good, and the test I ran with a 3 disk raid 5 
seems good so far.  I am not yet sure that whether I will go for mdadm 
raid or hardware raid - there are pros and cons to both solutions.

>> Does anyone here have experience with this card, or can give me any hints?
>
> I can point you to the documentation for the 5014:
>
> http://www.redbooks.ibm.com/technotes/tips0054.pdf
>
> ftp://ftp.software.ibm.com/systems/support/system_x_pdf/ibm_doc_sraidmr_1st-ed_5014-5015_quick-install.pdf
>
> ftp://ftp.software.ibm.com/systems/support/system_x_pdf/ibm_doc_sraidmr_1st-ed_5014-5015_user-guide.pdf
>

I had most of the IBM information already, but thanks anyway.

>
> Dave Chinner of Red Hat, one of the lead XFS developers, runs an 8 core
> test rig with a 512MB LSI card nearly identical to this ServeRAID 5014,
> with something like 16 drives, using mdraid.  The method he had to use
> to get mdraid working was putting each drive in its own RAID0 group
> (virtual disk).  He claimed the onboard cache RAM was still enabled for
> writes, I'm not sure about reads.
>

Yes, I've seen this idea on the net, and I also heard it from an IBM 
support technician.  It is certainly a possibility.

> For high load parallel XFS operations--think severe multiuser
> multithreaded test workloads designed to hammer XFS and force bugs to
> surface--he stated mdraid has a performance advantage vs the onboard
> RAID ASIC.  IIRC at lower disk counts and/or medium and lower load,
> there's little or no performance difference.  I.e. the workload has to
> saturate the 800Mhz LSI RAID ASIC before you notice performance tailing off.
>

I am not actually expecting a very large performance difference, nor it 
that going to be a critical factor.

> Join the XFS mailing list and ask Dave.  I'm sure he'd be glad to give
> you pointers even if it's a bit off topic.
>
> http://oss.sgi.com/mailman/listinfo/xfs
>
> Actually, I think it's an open list, so you should be able to simply
> send mail to xfs@oss.sgi.com and ask to be CC'd as you're not subscribed.
>
> Hope this information is helpful.
>

Yes, your information was helpful - thanks.  I have a few more questions 
which you might be able to help me with, if you have the time.  I'd also 
like to list some of the pros and cons of the hardware raid solution 
compared to md raid - I'd appreciate any comments you (or anyone else, 
of course) has on them.  I have no previous experience with hardware 
raid, so I'm learning a bit here.

For this particular server, I have 4 disks.  There will be virtual 
servers (using openvz) on it handling general file serving and an email 
server.  Performance requirements are not critical.  But I'm trying to 
make my comments more general, in the hope that they will be of interest 
and help to other people too.


First off, when I ran "lspci" on a system rescue cd, the card was 
identified as a "LSI Megaraid SAS 2108".  But running "lspci" on CentOS 
(with an older kernel), it was identified as a "MegaRAID SAS 9260". 
Looking at the LSI website, and comparing the pictures to the physical 
card, it seems very much that it is an LSI MegaRAID SAS 9260-8i card. 
Armed with this knowledge, I've come a lot further - LSI seems to have 
plenty of support for all sorts of systems (not just very specific RHEL, 
Suse, and Windows versions), and lots of information.  I am /much/ 
happier with LSI's software than I was with IBM's - the MegaCli command 
line program looks like it will give me the control I want from a 
command line interface, rather than using the card's BIOS screen.  I 
haven't yet tried fiddling with any settings using MegaCli, but the info 
dumps work.  MegaCli is pretty unfriendly and the documentation is not 
great (it could do with some examples), but it's much better than a bios 
screen.


Pros for hardware raid:

+ It can have battery backup (I don't have one at the moment - I have an 
excellent UPS for the whole system).
+ Rebuilds will be handled automatically by just adding new disks
+ The card supports online resizing and reshaping
+ It looks like the card supports caching with an SSD
+ The card supports snapshots of the virtual drives

Cons for hardware raid:

- The disks are tied to the controller, so if the machine or its 
controller fails, the data may not be recoverable (that's what external 
backups are for!).
- If a drive is used for a particular raid level, it is /all/ used at 
that level.  Thus no mixing of raid10 and raid5 on the same disk.
- It needs the MegaCli or other non-standard software for administration 
at run-time.
- Testing and experimentation is limited, because you can't fake an 
error (other than drive removal) and you can't fake drive size changes.


Pros for software raid:

+ It's flexible (such as raid1 for /boot, raid10 for swap, and raid5 for 
data - all within the same set of disks).
+ It uses standard software (any live CD or USB will work, as will any 
distribution).
+ You can put the disks in any Linux machine to recover the data if the 
main machine dies.
+ You can use standard disk administration software (smartctl, hddtemp, 
hdparm, etc.)
+ You can build layered raids, such as with one-disk mirrors at the 
bottom and top, for extra safety during risky operations.  You can also 
use external drives for such operations - they are slower, but easy to 
add for temporary changes.
+ You have more choices for raid levels (raid10,far is particularly 
useful, and you can have raid6 without an extra license key).


Cons for software raid:

- Adding replacement disks involves a few more changes, such as 
partitioning the disks and adding the right partitions to the right arrays.


I don't think there will be significant performance differences,
especially not for the number of drives I am using.


I have one question about the hardware raid that I don't know about.  I 
will have filesystems (some ext4, some xfs) on top of LVM on top of the 
raid.  With md raid, the filesystem knows about the layout, so xfs 
arranges its allocation groups to fit with the stripes of the raid. 
Will this automatic detection work as well with hardware raid?


Anyway, now it's time to play a little with MegaCli and see how I get 
on.  It seems to have options to put drives in "JBOD" mode - maybe that 
would give me direct access to the disk like a normal SATA drive?


mvh.,

David


