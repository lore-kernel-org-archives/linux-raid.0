From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: [Bugme-new] [Bug 4211] New: md configuration destroys disk GPT label
Date: Mon, 14 Feb 2005 14:10:01 -0500
Message-ID: <200502141910.j1EJA6911593@www.watkins-home.com>
References: <20050214101705.56507c64.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050214101705.56507c64.akpm@osdl.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Andrew Morton' <akpm@osdl.org>, linux-raid@vger.kernel.org
Cc: aspanke@gmail.com
List-Id: linux-raid.ids

Maybe I am confused, but if you use the whole disk, I would expect the whole
disk could be over-written!  What am I missing?

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Andrew Morton
Sent: Monday, February 14, 2005 1:17 PM
To: linux-raid@vger.kernel.org
Cc: aspanke@gmail.com
Subject: Fw: [Bugme-new] [Bug 4211] New: md configuration destroys disk GPT
label



Begin forwarded message:

Date: Mon, 14 Feb 2005 05:29:22 -0800
From: bugme-daemon@osdl.org
To: bugme-new@lists.osdl.org
Subject: [Bugme-new] [Bug 4211] New: md configuration destroys disk GPT
label


http://bugme.osdl.org/show_bug.cgi?id=4211

           Summary: md configuration destroys disk GPT label
    Kernel Version: 2.4.18-e.31smp
            Status: NEW
          Severity: high
             Owner: io_md@kernel-bugs.osdl.org
         Submitter: aspanke@gmail.com


Distribution: RedHat Advanced Server 2.1

Hardware Environment: NEC System, 4 CPU IA-64, 8 GB RAM, 
                      direct connected FC disks

Software Environment: OS + Oracle installation

Problem Description: 
md configuration based on complete disks instead of partitions destroys the
GPT
label of the used disks

Steps to reproduce:
Setup a Software Raid, raid level 0 or 1, based on complete disks,

raiddev /dev/md0
        raid-level      0
        nr-raid-disks   2
        persistent-superblock 1
        chunk-size      16
        device          /dev/sdb
        raid-disk       0
        device          /dev/sdc
        raid-disk       1

create the raiddevice, create a free choosable filesystem, I worked with
ext2,
and put some I/O load on the filesystem. 
After umounting raiddevice, try to print the partition table using 'parted',
you
will get 

[root@rumil /]# parted /dev/sdb print
Primary GPT is invalid, using alternate GPT.
Error: This disk contains a valid Alternate GUID Partition Table but the
Primary
GPT and Protective MBR are invalid.  This generally means that the disk had
GPT
partitions on it, but then a legacy partition editing tool was used to
change
the partition table stored in the MBR.
Which data is valid,  GPT or MBR?
Yes will assume that the GPT information is correct, and will rewrite the
PMBR
and Primary GPT.
No will assume that the MBR is correct, and erase the GPT information.
Ignore will assume that the MBR is correct, but not change the disk.
Yes No Ignore ? 

The same setup works fine, if I am using partitions instead of the hole disk
...

raiddev /dev/md0
        raid-level      0
        nr-raid-disks   2
        persistent-superblock 1
        chunk-size      16
        device          /dev/sdb1
        raid-disk       0
        device          /dev/sdc1
        raid-disk       1

[root@rumil /]# parted /dev/sdb print
Disk geometry for /dev/sdb: 0.000-34688.000 megabytes
Disk label type: GPT
Minor    Start       End     Filesystem  Name                  Flags
1          0.017  34687.500  ext2                              lba


Regards
 Alex

------- You are receiving this mail because: -------
You are on the CC list for the bug, or are watching someone who is.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

