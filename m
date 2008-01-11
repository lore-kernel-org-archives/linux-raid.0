From: Neil Brown <neilb@suse.de>
Subject: Re: md rotates RAID5 spare at boot
Date: Fri, 11 Jan 2008 11:24:07 +1100
Message-ID: <18310.46887.913553.247401@notabene.brown>
References: <47852984.5040707@ultralame.com>
	<4786844D.4010104@tmr.com>
	<478685DA.8070701@ultralame.com>
	<18310.38343.339990.718263@notabene.brown>
	<4786AD9F.5050400@ultralame.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jed Davidow on Thursday January 10
Sender: linux-raid-owner@vger.kernel.org
To: Jed Davidow <jed@ultralame.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 10, jed@ultralame.com wrote:
> One quick question about those rules.  The 65-mdadm rule looks like it 
> checks ACTIVE arrays for filesystems, and the 85 rule assembles arrays.  
> Shouldn't they run in the other order?
> 

They are fine.  The '65' rule applies to arrays.  I.e. it fires on an
array device once it has been started.
The '85' rule applies to component devices.

They are quite independent.

NeilBrown


> 
> 
> 
> distro: Ubuntu 7.10
> 
> Two files show up...
> 
> 85-mdadm.rules:
> # This file causes block devices with Linux RAID (mdadm) signatures to
> # automatically cause mdadm to be run.
> # See udev(8) for syntax
> 
> SUBSYSTEM=="block", ACTION=="add|change", ENV{ID_FS_TYPE}=="linux_raid*", \
>         RUN+="watershed /sbin/mdadm --assemble --scan --no-degraded"
> 
> 
> 
> 65-mdadm.vol_id.rules:
> # This file causes Linux RAID (mdadm) block devices to be checked for
> # further filesystems if the array is active.
> # See udev(8) for syntax
> 
> SUBSYSTEM!="block", GOTO="mdadm_end"
> KERNEL!="md[0-9]*", GOTO="mdadm_end"
> ACTION!="add|change", GOTO="mdadm_end"
> 
> # Check array status
> ATTR{md/array_state}=="|clear|inactive", GOTO="mdadm_end"
> 
> # Obtain array information
> IMPORT{program}="/sbin/mdadm --detail --export $tempnode"
> ENV{MD_NAME}=="?*", SYMLINK+="disk/by-id/md-name-$env{MD_NAME}"
> ENV{MD_UUID}=="?*", SYMLINK+="disk/by-id/md-uuid-$env{MD_UUID}"
> 
> # by-uuid and by-label symlinks
> IMPORT{program}="vol_id --export $tempnode"
> OPTIONS="link_priority=-100"
> ENV{ID_FS_USAGE}=="filesystem|other|crypto", ENV{ID_FS_UUID_ENC}=="?*", \
>                         SYMLINK+="disk/by-uuid/$env{ID_FS_UUID_ENC}"
> ENV{ID_FS_USAGE}=="filesystem|other", ENV{ID_FS_LABEL_ENC}=="?*", \
>                         SYMLINK+="disk/by-label/$env{ID_FS_LABEL_ENC}"
> 
> 
> I see.  So udev is invoking the assemble command as soon as it detects 
> the devices.  So is it possible that the spare is not the last drive to 
> be detected and mdadm assembles too soon?
> 
> 
> 
> Neil Brown wrote:
> > On Thursday January 10, jed@ultralame.com wrote:
> >   
> >> It looks to me like md inspects and attempts to assemble after each 
> >> drive controller is scanned (from dmesg, there appears to be a failed 
> >> bind on the first three devices after they are scanned, and then again 
> >> when the second controller is scanned).  Would the scan order cause a 
> >> spare to be swapped in?
> >>
> >>     
> >
> > This suggests that "mdadm --incremental" is being used to assemble the
> > arrays.  Every time udev finds a new device, it gets added to
> > whichever array is should be in.
> > If it is called as "mdadm --incremental --run", then it will get
> > started as soon as possible, even if it is degraded.  With the
> > "--run", it will wait until all devices are available.
> >
> > Even with "mdadm --incremental --run", you shouldn't get a resync if
> > the last device is added before the array is written to.
> >
> > What distro are you running?
> > What does
> >    grep -R mdadm /etc/udev
> >
> > show?
> >
> > NeilBrown
> >
> >   
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
