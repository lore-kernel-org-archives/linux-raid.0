From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Kicking Non-Fresh From Array
Date: Fri, 21 May 2004 09:55:54 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200405211355.i4LDtwB23899@www.watkins-home.com>
References: <40AD17C1.8010708@atella.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40AD17C1.8010708@atella.com>
To: 'Sevatio' <sevatio@atella.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It looks like you created a RAID1 with 1 disk.
The "[U]" shows that.

md1 : active raid1 hdc6[1] hda6[0]
       6144704 blocks [1/1] [U]

So, if you add more disks to the array they will be spares.  But that will
never work since you only have 1 disk in the array.

A tool called Raidreconf allows you to add disks to a RAID5 array.  I don't
know if it supports RAID1 arrays.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Sevatio
Sent: Thursday, May 20, 2004 4:41 PM
To: linux-raid@vger.kernel.org
Subject: Kicking Non-Fresh From Array

I can't figure out how to get a partition into a Raid1 array.  Syslog 
tells me "kicking non-fresh hdc6 from array".  Raidtab is set to assign 
/dev/hda6 & /dev/hdc6 to /dev/md1:

raiddev       /dev/md1
raid-level    1
chunk-size    64k
persistent-superblock 1
nr-raid-disks 2
     device    /dev/hda6
     raid-disk 0
     device    /dev/hdc6
     raid-disk 1

But mdstat only shows hda6 for md1.  Also, I tried raidhotadd but it 
doesn't show hdc6 as being active:

md1 : active raid1 hdc6[1] hda6[0]
       6144704 blocks [1/1] [U]

How do I fix this to get hdc6 to join md1?

Thanks,
Sevatio
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


