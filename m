From: Javier Marcet <javier-ml-gmane@marcet.info>
Subject: RAID0 resizing problem
Date: Tue, 22 Jun 2004 16:54:40 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <cb9h7u$hmj$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys,
maybe some of you might help me with my RAID0 setup.

So far I had two 80GB drives in RAID0 (software raid), with two partitions
on each disk, 50GB + 30 GB.
Now I'd like to erase the 30GB partitions and fill the entire disks with
only one partition.
However, as soon as I remove the smaller partitions, the raid won't
start.

I've made a backup of the contents of the 30GB partitions --indeed, I moved
the data somewhere else--, but due to size constrains I could not make
a copy of the 50GB ones. Hence, I need to keep all the data already on
them.

Some other info you might find handy is I'm using ReiserFS. I've
succesfully resized reiserfs partitions in the past with resize_reiserfs
and/or resizefs.reiserfs. Yet for them to work the partition must first
be recognized as a valid ReiserFS partition, which, in the case of the
second disk in the array, are not.

Any help will be appreciated :))

Below you have some info from lsraid:

[dev   9,   0] /dev/md0         332B9AEC.F1F2E204.598B0271.4C75A675 online
[dev  22,   1] /dev/hdc1        332B9AEC.F1F2E204.598B0271.4C75A675 good
[dev  22,  65] /dev/hdd1        332B9AEC.F1F2E204.598B0271.4C75A675 good

[dev   9,   1] /dev/md1         713137E9.D7957AE8.A38E732C.CD562CFC online
[dev  22,   2] /dev/hdc2        713137E9.D7957AE8.A38E732C.CD562CFC good
[dev  22,  66] /dev/hdd2        713137E9.D7957AE8.A38E732C.CD562CFC good

[dev 22, 1] /dev/hdc1:
        md version              = 0.90.0
        superblock uuid         = 332B9AEC.F1F2E204.598B0271.4C75A675
        md minor number         = 0
        created                 = 1074489973 (Mon Jan 19 06:26:13 2004)
        last updated            = 1074792105 (Thu Jan 22 18:21:45 2004)
        raid level              = 0
        chunk size              = 32 KB
        apparent disk size      = 52950592 KB
        disks in array          = 2
        required disks          = 2
        active disks            = 2
        working disks           = 2
        failed disks            = 0
        spare disks             = 0
        position in disk list   = 0
        position in md device   = 0
        state                   = good

[dev 22, 2] /dev/hdc2:
        md version              = 0.90.0
        superblock uuid         = 713137E9.D7957AE8.A38E732C.CD562CFC
        md minor number         = 1
        created                 = 1074489960 (Mon Jan 19 06:26:00 2004)
        last updated            = 1074792105 (Thu Jan 22 18:21:45 2004)
        raid level              = 0
        chunk size              = 32 KB
        apparent disk size      = 25199936 KB
        disks in array          = 2
        required disks          = 2
        active disks            = 2
        working disks           = 2
        failed disks            = 0
        spare disks             = 0
        position in disk list   = 0
        position in md device   = 0
        state                   = good

[dev 22, 65] /dev/hdd1:
        md version              = 0.90.0
        superblock uuid         = 332B9AEC.F1F2E204.598B0271.4C75A675
        md minor number         = 0
        created                 = 1074489973 (Mon Jan 19 06:26:13 2004)
        last updated            = 1074792105 (Thu Jan 22 18:21:45 2004)
        raid level              = 0
        chunk size              = 32 KB
        apparent disk size      = 52950592 KB
        disks in array          = 2
        required disks          = 2
        active disks            = 2
        working disks           = 2
        failed disks            = 0
        spare disks             = 0
        position in disk list   = 1
        position in md device   = 1
        state                   = good

[dev 22, 66] /dev/hdd2:
        md version              = 0.90.0
        superblock uuid         = 713137E9.D7957AE8.A38E732C.CD562CFC
        md minor number         = 1
        created                 = 1074489960 (Mon Jan 19 06:26:00 2004)
        last updated            = 1074792105 (Thu Jan 22 18:21:45 2004)
        raid level              = 0
        chunk size              = 32 KB
        apparent disk size      = 25199936 KB
        disks in array          = 2
        required disks          = 2
        active disks            = 2
        working disks           = 2
        failed disks            = 0
        spare disks             = 0
        position in disk list   = 1
        position in md device   = 1
        state                   = good


-- 
The last time I saw him he was walking down Lover's Lane holding his own
hand.
                -- Fred Allen

Javier Marcet <wnivre@zneprg.vasb> (ROT13 encoded)

