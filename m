From: David Brown <david.brown@hesbynett.no>
Subject: Re: Direct disk access on IBM Server
Date: Thu, 21 Apr 2011 13:19:49 +0200
Message-ID: <iop3sl$6rl$1@dough.gmane.org>
References: <iok28i$tp6$1@dough.gmane.org> <4DADEBC3.9060404@hardwarefreak.com> <iomfkq$qqr$1@dough.gmane.org> <4DAFAE49.1020802@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DAFAE49.1020802@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/04/11 06:10, Stan Hoeppner wrote:
> David Brown put forth on 4/20/2011 6:24 AM:
>
>> For this particular server, I have 4 disks.
>
> Seems like a lot of brain activity going on here for such a small array.
> ;)
>

I prefer to do my thinking and learning before committing too much - 
it's always annoying to have everything installed and /almost/ perfect, 
and then think "if only I'd set up the disks a little differently"!

And since it's my first hardware raid card (I don't count fakeraid on 
desktop motherboards), I have been learning a fair bit here.

>> First off, when I ran "lspci" on a system rescue cd, the card was
>> identified as a "LSI Megaraid SAS 2108".  But running "lspci" on CentOS
>> (with an older kernel), it was identified as a "MegaRAID SAS 9260".
>
> This is simply differences in kernels/drivers' device ID tables.
> Nothing to worry about AFAIK.
>

That was my thoughts.  I get the impression that the "SAS 2108" is the 
raid ASIC, while the "SAS 9260" is the name of a card.  That turned out 
to be more helpful in identifying the card on LSI's website.

>> I don't think there will be significant performance differences,
>> especially not for the number of drives I am using.
>
> Correct assumption.
>
>> I have one question about the hardware raid that I don't know about.  I
>> will have filesystems (some ext4, some xfs) on top of LVM on top of the
>> raid.  With md raid, the filesystem knows about the layout, so xfs
>> arranges its allocation groups to fit with the stripes of the raid. Will
>> this automatic detection work as well with hardware raid?
>
> See:
>
> Very important infor for virtual machines:
> http://xfs.org/index.php/XFS_FAQ#Q:_Which_settings_are_best_with_virtualization_like_VMware.2C_XEN.2C_qemu.3F
>
> Hardware RAID write cache, data safety info
> http://xfs.org/index.php/XFS_FAQ#Q._Should_barriers_be_enabled_with_storage_which_has_a_persistent_write_cache.3F
>
> Hardware controller settings:
> http://xfs.org/index.php/XFS_FAQ#Q._Which_settings_does_my_RAID_controller_need_.3F
>
> Calculate correct mkfs.xfs parameters:
> http://xfs.org/index.php/XFS_FAQ#Q:_How_to_calculate_the_correct_sunit.2Cswidth_values_for_optimal_performance
>
> General XFS tuning advice:
> http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E
>

I guess I should have looked at the FAQ before asking - after all, 
that's what the FAQ is for.  Many thanks for the links.

>> Anyway, now it's time to play a little with MegaCli and see how I get
>> on.  It seems to have options to put drives in "JBOD" mode - maybe that
>> would give me direct access to the disk like a normal SATA drive?
>
> IIRC, using JBOD mode for all the drives will disable the hardware
> cache, and many/most/all other advanced features of the controller,
> turning the RAID card literally into a plain SAS/SATA HBA.  I believe
> this is why Dave chose the RAID0 per drive option.  Check your docs to
> confirm.
>

My original thought was that plain old SATA is what I know and am used 
to, and I know how to work with it for md raid, hot plugging, etc.  So 
JBOD was what I was looking for.

However, having gathered a fair amount of information and done some 
testing, I am leaning heavily towards using the hardware raid card for 
hardware raid.  As you say, I've done a fair amount of thinking for a 
small array - I like to know what my options are and their pros and 
cons.  Having established that, the actual /implementation/ choice will 
be whatever gives me the functionality I need with the least effort (now 
and for future maintenance) - it looks like a hardware raid5 is the 
choice here.

> In parting, carefully read about filesystem data consistency issues WRT
> virtual machine environments.  It may prove more important for you than
> any filesystem tuning.
>

Yes, I am aware of such issues - I have read about them before (and they 
are relevant for the VirtualBox systems I use on desktops).  However, on 
the server I use openvz, which is a "lightweight" virtualisation - more 
like a glorified chroot than full virtualisation.  The host handles the 
filesystems - the guests just see a restricted part of the filesystem, 
rather than virtual drives.  So all data consistency issues are simple 
host issues.  I still need to make sure I understand about barriers, 
raid card caches, etc. (reading the xfs faq), but at least there are no 
special problems with virtual disks.

Thanks,

David

