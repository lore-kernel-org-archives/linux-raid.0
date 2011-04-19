From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Direct disk access on IBM Server
Date: Tue, 19 Apr 2011 15:08:35 -0500
Message-ID: <4DADEBC3.9060404@hardwarefreak.com>
References: <iok28i$tp6$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iok28i$tp6$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Brown put forth on 4/19/2011 8:21 AM:
> I have recently got an IBM x3650 M3 server, which has a "Serveraid
> M5014" raid controller.  Booting from a Linux CD (system rescue CD) and
> running lspci identifies this raid controller as:
> 
> LSI Logic/Symbus Logic Megaraid SAS 2108 [Liberator] (rev 03)
> 
> The controller works fine for hardware raid - I can open its bios setup
> utility, and set up a RAID5 (or whatever) with the disks I have.  The OS
> then just sees a single virtual disk.
> 
> But I would like direct access to the sata drives - I want to set up
> mdadm raid, under my own control.  As far as I can see, there is no way
> to put this controller into "JBOD" or "direct access" mode of any sort.

FYI, the ServeRAID 5014 is a good quality real hardware RAID card w/

PCIe 2.0 x8 interface
800 MHz LSI PowerPC RAID on Chip ASIC
256MB DDRII cache RAM
8 x 6Gb/s SAS ports via 2 SFF8087
32 drives maximum, 16 drives max per virtual disk (RAID group)

If your card has the RAID6 feature key installed, mdraid will likely
gain you little, if anything, over the card's inbuilt features.

> Does anyone here have experience with this card, or can give me any hints?

I can point you to the documentation for the 5014:

http://www.redbooks.ibm.com/technotes/tips0054.pdf

ftp://ftp.software.ibm.com/systems/support/system_x_pdf/ibm_doc_sraidmr_1st-ed_5014-5015_quick-install.pdf

ftp://ftp.software.ibm.com/systems/support/system_x_pdf/ibm_doc_sraidmr_1st-ed_5014-5015_user-guide.pdf


Dave Chinner of Red Hat, one of the lead XFS developers, runs an 8 core
test rig with a 512MB LSI card nearly identical to this ServeRAID 5014,
with something like 16 drives, using mdraid.  The method he had to use
to get mdraid working was putting each drive in its own RAID0 group
(virtual disk).  He claimed the onboard cache RAM was still enabled for
writes, I'm not sure about reads.

For high load parallel XFS operations--think severe multiuser
multithreaded test workloads designed to hammer XFS and force bugs to
surface--he stated mdraid has a performance advantage vs the onboard
RAID ASIC.  IIRC at lower disk counts and/or medium and lower load,
there's little or no performance difference.  I.e. the workload has to
saturate the 800Mhz LSI RAID ASIC before you notice performance tailing off.

Join the XFS mailing list and ask Dave.  I'm sure he'd be glad to give
you pointers even if it's a bit off topic.

http://oss.sgi.com/mailman/listinfo/xfs

Actually, I think it's an open list, so you should be able to simply
send mail to xfs@oss.sgi.com and ask to be CC'd as you're not subscribed.

Hope this information is helpful.

-- 
Stan
