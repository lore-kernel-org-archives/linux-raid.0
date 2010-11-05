From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: Upgraded grub, now confused about mirrored /boot
Date: Thu, 04 Nov 2010 21:42:12 -0400
Message-ID: <B7D38B69425949BEB83DAA2E8D656271@m5>
References: <AANLkTinnaRECf9grA6-VEAg7YNvN6M4cHWKBYsfj4v6B@mail.gmail.com>
	<4CCD7AE1.8000705@anonymous.org.uk> <20101031114655.36e627e3@notabene>
 <4CCF65F3.3040307@anonymous.org.uk> <9770F687FAE544F295B1A22155F2BBA6@m5>
 <4CD02D02.3060701@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4CD02D02.3060701@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: 'John Robinson' <john.robinson@anonymous.org.uk>
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

It worked!
/sbin/grub-install /dev/md0

Thanks,
Guy

} -----Original Message-----
} From: John Robinson [mailto:john.robinson@anonymous.org.uk]
} Sent: Tuesday, November 02, 2010 11:24 AM
} To: Guy Watkins
} Cc: 'Linux RAID'
} Subject: Re: Upgraded grub, now confused about mirrored /boot
} 
} On 02/11/2010 06:11, Guy Watkins wrote:
} > Hello,
} >
} > 	I upgraded my system from Red Hat FC10 to FC11.  The instructions
} > say to run this command:
} > /sbin/grub-install BOOTDEVICE
} >
} > And if it fails, run this:
} > /sbin/grub-install --recheck /dev/sda
} >
} > However, my boot disk (/boot) is mirrored on 4 disks and I think (or
} hope)
} > all 4 are bootable.  The mirrors were created at install time many years
} ago
} > when I installed FC5.  No idea if it really made more than 1 bootable.
} I
} > have assumed that if sda failed, I could still boot from sdb, sdc or
} sdd.
} > And I do understand that I might need to remove sda first, depending on
} the
} > type of failure.  Lucky for me, no drive has failed yet and I don't
} recall
} > if I tested booting off of any other disks.
} >
} > I do have this on the kernel line:
} > md-mod.start_dirty_degraded=1
} >
} > So, what do I do now?  Run that command on all 4 disks?  Or run it on
} > /dev/md0?
} 
} I don't know which grub version you get in FC10/11, but in CentOS 5
} (with grub 0.97), grub-install is a clever little script which does all
} the work for you, so you just
}    /sbin/grub-install /dev/md0
} and it will install grub on all of /dev/md0's constituent drives and
} generally get everything right.
} 
} You should be fine with metadata 0.90 or 1.0 as both store the
} superblock at the end of the device. 1.1 and 1.2 probably won't work
} because their constituent partitions don't look like bare filesystems.
} 
} What actually happens is that the BIOS boots off the first live disc,
} and so does grub 0.97, neither has any inherent support for RAID but
} they don't have to if it's a RAID-1 mirror because both (or all) parts
} of the mirror can be used on their own, at least for reading enough to
} boot with.
} 
} You should probably test booting up with your first drive disconnected,
} just to be sure!
} 
} Cheers,
} 
} John.

