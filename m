From: SoulBlazer <soul@lamp-post.net>
Subject: Floating Spare
Date: Mon, 8 Apr 2002 13:41:30 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020408184316Z313731-22651+2106@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Can you share 2 or 3 'spare-disks' between multiple raid sets?

Eg. I have a 22 disk array chopped into multiple 4 disk raid-5 volumes, this 
leaves me with 2 disks left over..  Can I assign these two drives as floating 
spares incase of failure.. this will obviously be a 'first come first serve' 
scenario for raid failure.. but its better then not using them.

## Vol 00 ##
raiddev /dev/md/0
        raid-level              5
        nr-raid-disks           3
        nr-spare-disks          1
        persistent-superblock   1
        chunk-size              128
        parity-algorithm        left-symmetric

        device          /dev/scsi/host2/bus0/target0/lun0/part1
        raid-disk       0
        device          /dev/scsi/host2/bus0/target1/lun0/part1
        raid-disk       1
        device          /dev/scsi/host2/bus0/target2/lun0/part1
        raid-disk       2
        device          /dev/scsi/host2/bus0/target3/lun0/part1
        spare-disk      0

## Vol 01 ##
raiddev /dev/md/1
        raid-level              5
        nr-raid-disks           3
        nr-spare-disks          1
        persistent-superblock   1
        chunk-size              128
        parity-algorithm        left-symmetric

        device          /dev/scsi/host2/bus0/target4/lun0/part1
        raid-disk       0
        device          /dev/scsi/host2/bus0/target5/lun0/part1
        raid-disk       1
        device          /dev/scsi/host2/bus0/target6/lun0/part1
        raid-disk       2
        device          /dev/scsi/host2/bus0/target3/lun0/part1
        spare-disk      0


