From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: A few mdadm questions
Date: Fri, 12 Nov 2004 23:21:53 -0500
Message-ID: <200411130421.iAD4LwN03759@www.watkins-home.com>
References: <419580D8.1020900@osiel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <419580D8.1020900@osiel.org>
Sender: linux-raid-owner@vger.kernel.org
To: 'Robert Osiel' <bob@osiel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

First, stop using the old raid tools.  Use mdadm only!  mdadm would not have
allowed your error to occur.

If you start the array with n-1 disk, it can't re-build.
I think you can recover.  I simulated your mistake.  See results:

Status of array before I started to trash it:
    Number   Major   Minor   RaidDevice State
       0       1        1        0      active sync   /dev/ram1
       1       1       14        1      active sync   /dev/ram14
       2       1       13        2      active sync   /dev/ram13
       3       1        0        3      active sync   /dev/ram0

Failed 1 disk:
# mdadm /dev/md3 -f /dev/ram14
mdadm: set /dev/ram14 faulty in /dev/md3

Attempt to remove another disk, but mdadm will not allow:
# mdadm /dev/md3 -r /dev/ram13
mdadm: hot remove failed for /dev/ram13: Device or resource busy

Fail another disk, the array is now in a vary bad state:
# mdadm /dev/md3 -f /dev/ram13
mdadm: set /dev/ram13 faulty in /dev/md3

Remove the second failed disk:
# mdadm /dev/md3 -r /dev/ram13
mdadm: hot removed /dev/ram13

Now I attempt to recover.

Stop the array:
# mdadm -S /dev/md3

Check the status:
# mdadm -D /dev/md3
mdadm: md device /dev/md3 does not appear to be active.

Now start the array, listing n-1 disks.
# mdadm --assemble --force /dev/md3 /dev/ram0 /dev/ram1 /dev/ram13
mdadm: forcing event count in /dev/ram13(2) from 66 upto 69
mdadm: clearing FAULTY flag for device 2 in /dev/md3 for /dev/ram13
mdadm: /dev/md3 has been started with 3 drives.

Add the disk that failed first:
# mdadm /dev/md3 -a /dev/ram14
mdadm: hot added /dev/ram14

After a re-sync the array is fine.

So, at this point, this is what you need to do:

Stop the array:
mdadm -S /dev/mdx

Start the array using the 4 good disks, not the disk that failed first.
mdadm --assemble --force <list the 4 good disks>

Your array should be up at this point.

You can now add the failed disk:
mdadm /dev/mdx -a /dev/xxx

Hope this helps!
If you have questions, just post again.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Robert Osiel
Sent: Friday, November 12, 2004 10:35 PM
To: linux-raid@vger.kernel.org
Subject: A few mdadm questions

Hello.
I have a five-disk RAID 5 array  in which one disk's failure went 
unnoticed for an indeterminate time.  Once I finally noticed, I did a 
raidhotremove on the disk -- or what I thought was the disk.  
Unfortunately, I can't count.  Now my array has one 'failed' disk and 
one 'spare' disk.  Aaargh.

Since then, I've learned a lot, but I haven't been able to find 
reassurances and/or answers elsewhere on a few issues.

The two big questions are:
1) How can I mark the 'spare' disk as 'clean' and get it back in the 
array?  If I read the mdadm source correctly, it looks like 'removed' 
disks are skipped when trying to assemble.
2) If I --assemble --force the array and just specify (n-1) disks, does 
that ensure that (if the array starts) it starts in degraded mode and 
won't start re-writing the parity information? 

Thanks a bunch in advance for any help.

Bob

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

