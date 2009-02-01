From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: problem growing raid-1
Date: Sun, 1 Feb 2009 01:58:52 -0500
Message-ID: <1989AD8217A4498F99113912FB734520@m5>
References: <6d344ffd0901312134q623be8ffi4cec4b6c39dd6216@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6d344ffd0901312134q623be8ffi4cec4b6c39dd6216@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Troy Cauble' <troycauble@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Years ago I had a problem booting with a failed disk.  I was told to add
this to the kernel command line.

md-mod.start_dirty_degraded=1

For me the file to edit is this:  /boot/grub/grub.conf

I think the above should be the default.  During a failure is not the time
to learn this!  Or it should be an attribute of the array, so you can have
some arrays that can start degraded and some that can't.

Guy

} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Troy Cauble
} Sent: Sunday, February 01, 2009 12:35 AM
} To: linux-raid@vger.kernel.org
} Subject: problem growing raid-1
} 
} I want to replace both disks in a RAID-1 with larger ones using the
} instructions here:
} http://linux-
} raid.osdl.org/index.php/Growing#Extending_an_existing_RAID_array
} 
} It looks straightforward: mdadm -f, mdmadm -r, swap a drive, etc., etc.
} 
} Except if I -f & -r a drive, I won't know which physical drive to pull.
} (And I have no spare SATA ports.)
} 
} So I figure I'll pull a drive first, then -f & -r whatever mdadm tells
} me is missing.
} But when I pull the drive, connect a new one and boot, I get dropped
} into a repair
} shell with:
} 
} fsck.ext3: Unable to resolve 'UUID=806153bf-6917-440d-ae48-553418cfbbeb'
} 
} which is the UUID of the raid filesystem.
} 
} I put the drive back in and reboot, and everything is fine.
} 
} 1)  So why doesn't my RAID-1 survive pulling a drive?
} Seems like a standard failure mode.
} 
} 2)  How do I proceed with the upgrade?
} 
} Thanks,
} -troy
} --
} To unsubscribe from this list: send the line "unsubscribe linux-raid" in
} the body of a message to majordomo@vger.kernel.org
} More majordomo info at  http://vger.kernel.org/majordomo-info.html

