From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: MDADM RAID 6 Bad Superblock after reboot
Date: Wed, 18 Oct 2017 20:40:59 +0100
Message-ID: <59E7AE4B.5000903@youngman.org.uk>
References: <6a0f0e0b-6b03-8ec1-b02f-b17b0447aff8@gmail.com>
 <AA5FDF15-8966-4793-9215-2814C1A6848D@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AA5FDF15-8966-4793-9215-2814C1A6848D@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Sean R. Funk" <sfunk1x@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/10/17 19:14, Sean R. Funk wrote:
> 
> 
> Hi there,

Hi,

First responding ...
> 
> After attempting to add a GPU to a VM running on a CentOS 7 KVM host I
> have, the machine forcibly rebooted. Upon reboot, my /dev/md0 raid 6 XFS
> array would not start.
> 
> Background:
> 
> Approximately 3 weeks ago I added 3 additional 3TB HDD's to my existing
> 5 disk array, and grew it using the *raw* disks as opposed to the
> partitions. Everything appeared to be working fine (raw disk was my
> mistake, as it had been a year since I had expanded this array
> previously, simply forgot steps) until last night. WHen I added the GPU
> via VMM, the host itself rebooted.

Raw disk shouldn't make any difference - mdadm/raid couldn't care less.
Mixing is not recommended primarily because it confuses the sysadmin -
not a good idea.
> 
> Unfortunately, the machine has no network access at the moment and I can
> only provide pictures of text from whats displayed on the screen. The
> system is booting into emergency mode and its failing because the
> /dev/md0 array isn't starting (and then NFS fails, etc).
> 
I'm guessing :-) that that means the array is degraded, therefore it
won't assemble/run and that obviously is knocking out the system.

> Smartctl shows no errors with any of the disks, and mdadm examine shows
> no superblocks on the 3 disks I added before. The array is in the
> inactive state, and it shows only 5 disks.

What does --detail tell us about the array?
> 
> To add to that, apparently I had grown the cluster while SELinux had
> been enabled as opposed to permissive - so there was a audit log of
> mdadm trying to modify /etc/mdadm.conf. I'm guessing it was trying to
> update the configuration file as to the drive configuration.

Are you sure the three drives were added? SELinux has a habit of causing
havoc. Did the available space on the array increase? Did you check?
> 
> Smartctl shows each drive is fine, and the first 5 drives have equal
> numbers of events. I'm presuming the data is all still intact.
> 
> Any advice on how to proceed? Thanks!

Firstly, make sure SELinux didn't interfere with the grow. My guess is
the add failed because SELinux blocked it, and in reality you've still
got a five-drive array, it just thinks it's an eight-drive array, so
when the system rebooted it said "five drives of eight? Not enough!" and
stopped.

The experts will chime in with more info, but

(a) don't do anything that alters the disks ...

(b) investigate that scenario, ie SELinux prevented the grow from
actually occurring.

If I'm right, recovery is hopefully a simple matter of disabling
SELinux, and re-assembling the array with either reverting the grow, or
firing it off so it can actually run and complete.

It certainly doesn't look a disastrous scenario at the moment.

Cheers,
Wol
