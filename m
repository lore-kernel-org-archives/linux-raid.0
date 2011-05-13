From: Christopher White <linux@pulseforce.com>
Subject: Re: mdadm does not create partition devices whatsoever, "partitionable"
 functionality broken
Date: Fri, 13 May 2011 21:49:06 +0200
Message-ID: <4DCD8B32.9010901@pulseforce.com>
References: <4DCD4A83.8060202@pulseforce.com>	<4DCD6119.3080705@turmel.org>	<4DCD67EF.1070602@pulseforce.com>	<4DCD6B27.70402@pulseforce.com> <20110513234055.4307c536@natsu> <4DCD72AF.1070809@pulseforce.com> <4DCD75FE.8010703@turmel.org> <4DCD7E78.6050000@pulseforce.com> <4DCD800F.7080501@grumpydevil.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DCD800F.7080501@grumpydevil.homelinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, Roman Mamedov <rm@romanrm.ru>, Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/13/11 9:01 PM, Rudy Zijlstra wrote:
> Hi Chris,
>
>
> I've run paritioned MD disks for several years now. I do that on 
> systems where i use md for the system partitions. One mirror with 
> partitions for the different system aspects. I prefer that, as it 
> reflects best the actual physical configuration, and all partitions 
> will be degraded at the same time when 1 disk develops a problem 
> (which is unfortunately not the case when you partition the disk and 
> then mirror the partitions).
>
> As i am a bit lazy and have only limited wish to fight with 
> BIOS/bootloader conflicts / vagaries, these systems typically boot 
> from the network (kernel gets loaded from the network, from there 
> onwards all is on the local disk).
>
> Cheers,
>
>
>
> Rudy
Thank you for the information, Rudy,

Your experience of running partitioned MD arrays for years shows that it 
is indeed stable. The reason for wanting to skip LVM was that it's one 
less performance-penalty layer, one less layer to configure, one less 
possible point of failure, etc.

However, Phil again brings up the main fear that's been nagging me, and 
that is that MD's partitioning support receives less love (use) and 
therefore risks having bugs that go undiscovered for ages and (gasp) may 
even risk corrupting the data. People are just so used to LVM since MD 
used to be single-partition only, that LVM+single-partition MD array is 
far more mature and far more in use.

My main reason against LVM was the performance penalty, where I had read 
that it was in the 1-5% range, but I just did a new search and saw 
threads showing that any performance hit claim is outdated and that LVM2 
is extremely efficient. In fact the CPU load didn't seem to be impacted 
more than 0.1% or so in the graphs I saw.

By the way, Rudy, as for your boot conflicts and the fact that you 
resort to running a network boot, that was only a problem in the past 
when bootloaders did not support software RAID. Grub2 supports GPT, MD 
arrays with metadata 1.2, and can fully boot from a system (with /boot) 
installation located on your MD array. All you'll have to do is make 
sure your /boot partition (and the whole system if you want to) is on a 
RAID 1 (mirrored) array, and that you install the Grub2 bootloader on 
every physical disk. This means that it goes:

Computer starts up -> BIOS/EFI picks any of the hard drives to boot from 
-> GRUB2 loads -> GRUB2 sees the MD RAID1 array and picks ANY of the 
disks to boot from (since they are all mirrored) and treats it as a 
regular, raw disk as if you didn't use an array at all.

I think you may have to do some slight extra work to get the system disk 
to mount as RAID1 for the OS and RAID 5 for your other array(s) after 
the kernel has booted, I think you have to first boot into a ram 
filesystem to allow the disk to be unmounted and re-mounted as a RAID 1 
array, but it's not hard, there are guides for it. Just get a 2.6-series 
kernel, grub2, a RAID1 array for the OS, and a guide and you will be 
set. It will remove the need for you to keep a network PXE boot server.

On 5/13/11 9:22 PM, Phil Turmel wrote:
> Hi Christopher,
>
> On 05/13/2011 02:54 PM, Christopher White wrote:
>> Hello again Phil (and Roman). Thanks to your back-and-forth, the bug has now finally been completely narrowed down: It is a bug in (g)parted!
> Good to know.  A pointer to the formal bug report would be a good followup, when you have it.
I've submitted a detailed report to the bug-parted mailing list and want 
to sincerely thank ALL of you for your discussion to help narrow it 
down. Thank you very much! The bug-parted archive seems slow to refresh, 
but the posting is called "[Confirmed Bug] Parted does not notify kernel 
when modifying partition tables in partitionable md arrays" and was 
posted about 40 minutes ago. It contains a list of the steps to 
reproduce the bug and the theories of why it happens. It should show up 
here eventually: 
http://lists.gnu.org/archive/html/bug-parted/2011-05/threads.html
> I always use LVM.  While the lack of attention to MD partitions might justify that, the real reason is the sheer convenience of creating, manipulating, and deleting logical volumes on the fly.  While you may not need it *now*, when you discover that you *do* need it, you won't be able to use it.  Online resizing of any of your LVs is the killer feature.
>
> Also, I'd be shocked if the LVM overhead for plain volumes was close to 1%.  In fact, I'd be surprised if it was even 0.1%.  Do you have any benchmarks that show otherwise?
As I wrote above, you re-inforce the fear I have that the lack of 
attention to MD partitions is an added risk, compared to the 
ultra-well-maintained LVM2 layer. Now that the performance question is 
out of the way, I will actually go for it. Online resizing and so on 
isn't very interesting since I use the partitions for storage that isn't 
in need of 100% availability, but the fact that LVM can be trusted with 
my life whereas MD partitions are rarely used, and the fact that LVM(2) 
turned out to be extremely effective CPU-wise, just settles it.


Christopher
