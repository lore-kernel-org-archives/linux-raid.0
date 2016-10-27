From: Santiago DIEZ <santiago.diez@caoba.fr>
Subject: Re: Fail to assemble raid4 with replaced disk
Date: Thu, 27 Oct 2016 16:11:24 +0200
Message-ID: <CAJh8RqXV4_v-zAu9Us_K6oTS_N_bR6vd97G4msN00qXn_vtXEQ@mail.gmail.com>
References: <CAJh8RqUjr7L_Of0fbW_mAXshmmgcPdXvhtsvhFXKF+XxjOTrFw@mail.gmail.com>
 <580F9B68.9010105@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <580F9B68.9010105@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Linux Raid LIST <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

Indeed, here is what I had in terms of event count:
/dev/sda10: 81589
/dev/sdb10: 81626
/dev/sdc10: 81589

Then the following procedure worked quite straightforward:
--------------------------------------------------------------------------------
# mdadm --assemble /dev/md10 --verbose --force /dev/sda10 /dev/sdb10 /dev/sdc10
# mdadm --manage /dev/md10 --add /dev/sdd10
--------------------------------------------------------------------------------

And 6h+ later:
--------------------------------------------------------------------------------
# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md10 : active raid5 sdd10[3] sda10[0] sdc10[2] sdb10[1]
      5778741888 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
--------------------------------------------------------------------------------

Then I ran:
--------------------------------------------------------------------------------
# e2fsck -f -n -t -v /dev/md10
e2fsck 1.42.5 (29-Jul-2012)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information

    15675837 inodes used (4.34%, out of 361177088)
      188798 non-contiguous files (1.2%)
       14751 non-contiguous directories (0.1%)
             # of inodes with ind/dind/tind blocks: 0/0/0
             Extent depth histogram: 15626455/47037/15
  1281308341 blocks used (88.69%, out of 1444685472)
           0 bad blocks
         101 large files

    15311457 regular files
      361754 directories
           0 character device files
           0 block device files
           0 fifos
           0 links
        2607 symbolic links (2310 fast symbolic links)
          10 sockets
------------
    15675828 files
Memory used: 50976k/1912k (20541k/30436k), time: 1304.00/334.06/ 8.00
I/O read: 4891MB, write: 0MB, rate: 3.75MB/s
--------------------------------------------------------------------------------

Does it look OK enough to launch the mount?

Regards and thanks for your help
-------------------------
Santiago DIEZ
Quark Systems & CAOBA
23 rue du Buisson Saint-Louis, 75010 Paris
-------------------------
