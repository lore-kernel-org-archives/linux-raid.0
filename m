From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Problems with SCSI devices renaming...
Date: Tue, 19 Oct 2004 11:15:22 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410191515.i9JFFRN22583@www.watkins-home.com>
References: <001201c4b5ea$958f0790$30493c86@clever>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <001201c4b5ea$958f0790$30493c86@clever>
To: 'Martin Clauss' <clauss@neuro.informatik.uni-ulm.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If you are using raidstart to start your array, then yes common problem.
Raidstart is part of raidtools, which is obsolete.

Try mdadm.  You may need to install this.  It was easy for me on redhat 9.

Your device names are very odd to me!  What happened to /dev/sda1 and such?

The problem you are having is very similar to the problem you would have if
a disk were to fail such that it could not be seen by the system.  This is
what happened to me first.  I have also added disks since then with problems
like yours.  But in my case the device names changed.  So I am confused by
this also.  For example I had 3 devices sda, sdb and sdc.  If sdb were to
fail or be removed, on reboot sdc would change names to sdb.  Raidstart
can't handle this, at least not for me!  If my major minor/number changed, I
did not notice.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Martin Clauss
Sent: Tuesday, October 19, 2004 10:48 AM
To: linux-raid@vger.kernel.org
Subject: Problems with SCSI devices renaming...

Hi all,

i got a problem with my raid. Current setup:

        raiddev /dev/md/0
                raid-level              5
                nr-raid-disks           10
                nr-spare-disks          0
                persistent-superblock   1
                parity-algorithm        left-symmetric

                device /dev/scsi/host2/bus0/target0/lun0/part1
                raid-disk               0
                device /dev/scsi/host2/bus0/target1/lun0/part1
                raid-disk               1
                device /dev/scsi/host2/bus0/target2/lun0/part1
                raid-disk               2
                device /dev/scsi/host2/bus0/target3/lun0/part1
                raid-disk               3
                device /dev/scsi/host2/bus0/target4/lun0/part1
                raid-disk               4
                device /dev/scsi/host2/bus0/target8/lun0/part1
                raid-disk               5
                device /dev/scsi/host2/bus0/target9/lun0/part1
                raid-disk               6
                device /dev/scsi/host2/bus0/target10/lun0/part1
                raid-disk               7
                device /dev/scsi/host2/bus0/target11/lun0/part1
                raid-disk               8
                device /dev/scsi/host2/bus0/target12/lun0/part1
                raid-disk               9

This works very fine so far. But when I attach an additional device to this
DEC Storage Device, I get an additional target on this SCSI bus. Now this
doesn't matter for the devfs names, but the superblock of the RAID saves
major/minor numbers that are wrong now. So the raid won't start anymore....
Shouldn't autodetect handle exactly this problem? (Yes, partition type is
linux raid autodetect for all raid disks...)

I guess, this should be a quite common problem, so I hope to find some
answers here.

Greetz,
Martin Clauss

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

