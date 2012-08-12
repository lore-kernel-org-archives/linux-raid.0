From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: Disk Order
Date: Mon, 13 Aug 2012 01:16:25 +0200
Message-ID: <50283949.9050906@grumpydevil.homelinux.org>
References: <50281BB1.6030309@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50281BB1.6030309@abpni.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Tripathy <jonnyt@abpni.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jonathan,

On 12-08-12 23:10, Jonathan Tripathy wrote:
> Hi Everyone,
>
> Our server currently has 6 SATA ports on the motherboard filled with 6 
> drives in RAID10. I have a need to install an additional PCIe SATA 
> controller in a server in order to obtain 2 more SATA ports to install 
> an additional 2 new drives (As I want a new RAID1 array). However I 
> would like to move one of the current drives onto the new controller, 
> and one of the new drives onto the motherboard. This should give me a 
> little redundancy in case the new controller card were to fail (I 
> don't want the new controller to bring down 2 drives).
>
> When setting up MD RAID in this configuration, how would I go about 
> tell MD RAID which disk is which in the array (referring to the 
> near/far configurations)? I'm assuming by default that MD RAID just 
> uses alphabetical order in order to determine the drive order?
mdadm does not care about the disk ordering once the raid has been 
defined. It uses the raid metadata on the disks to figure out which disk 
is doing what. This includes which disk belongs to which raid.

There are 2 options:
- use metadata .90 (no longer suggested) and have the kernel autodetect 
during boot
- use a later metadata (1.2 is default now), and have  mdadm in the 
initrd. This will use a config file that has mdadm search on UID. Again, 
independent of which sdx the disks are.

You could test by swapping disk order in your current system. Although i 
would suggest to do testing with a test machine ;)

Cheers,


Rudy

