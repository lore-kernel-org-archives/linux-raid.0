From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Direct disk access on IBM Server
Date: Wed, 20 Apr 2011 23:10:49 -0500
Message-ID: <4DAFAE49.1020802@hardwarefreak.com>
References: <iok28i$tp6$1@dough.gmane.org> <4DADEBC3.9060404@hardwarefreak.com> <iomfkq$qqr$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iomfkq$qqr$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Brown put forth on 4/20/2011 6:24 AM:

> For this particular server, I have 4 disks.

Seems like a lot of brain activity going on here for such a small array.
;)

> First off, when I ran "lspci" on a system rescue cd, the card was
> identified as a "LSI Megaraid SAS 2108".  But running "lspci" on CentOS
> (with an older kernel), it was identified as a "MegaRAID SAS 9260".

This is simply differences in kernels/drivers' device ID tables.
Nothing to worry about AFAIK.

> I don't think there will be significant performance differences,
> especially not for the number of drives I am using.

Correct assumption.

> I have one question about the hardware raid that I don't know about.  I
> will have filesystems (some ext4, some xfs) on top of LVM on top of the
> raid.  With md raid, the filesystem knows about the layout, so xfs
> arranges its allocation groups to fit with the stripes of the raid. Will
> this automatic detection work as well with hardware raid?

See:

Very important infor for virtual machines:
http://xfs.org/index.php/XFS_FAQ#Q:_Which_settings_are_best_with_virtualization_like_VMware.2C_XEN.2C_qemu.3F

Hardware RAID write cache, data safety info
http://xfs.org/index.php/XFS_FAQ#Q._Should_barriers_be_enabled_with_storage_which_has_a_persistent_write_cache.3F

Hardware controller settings:
http://xfs.org/index.php/XFS_FAQ#Q._Which_settings_does_my_RAID_controller_need_.3F

Calculate correct mkfs.xfs parameters:
http://xfs.org/index.php/XFS_FAQ#Q:_How_to_calculate_the_correct_sunit.2Cswidth_values_for_optimal_performance

General XFS tuning advice:
http://xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesystems_for_.3Csomething.3E

> Anyway, now it's time to play a little with MegaCli and see how I get
> on.  It seems to have options to put drives in "JBOD" mode - maybe that
> would give me direct access to the disk like a normal SATA drive?

IIRC, using JBOD mode for all the drives will disable the hardware
cache, and many/most/all other advanced features of the controller,
turning the RAID card literally into a plain SAS/SATA HBA.  I believe
this is why Dave chose the RAID0 per drive option.  Check your docs to
confirm.

In parting, carefully read about filesystem data consistency issues WRT
virtual machine environments.  It may prove more important for you than
any filesystem tuning.

-- 
Stan
