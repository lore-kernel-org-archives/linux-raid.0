From: Sandro Dentella <sandro@e-den.it>
Subject: Re: 3ware 9500s-8 & negative numbers...
Date: Mon, 20 Sep 2004 17:42:53 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040920154253.GA7720@bluff>
References: <20040916120440.GA19566@bluff> <Pine.LNX.4.58.0409160807560.6936@chaos.egr.duke.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0409160807560.6936@chaos.egr.duke.edu>
To: Joshua Baker-LePain <jlb17@duke.edu>
Cc: Sandro Dentella <sandro@e-den.it>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >   I'd like to know if 3ware 9500s SATA controller is supported by
> >   3w-xxxx module. 

> No, it isn't.  You need 3w-9xxx, which you can download from 3ware.


Thanks, I compiled. Now I have a module that loads, recognizes the array but
sees a negative number of cylinder:

   root@argo-cd scsi # parted /dev/sda
   GNU Parted 1.4.24
   Copyright (C) 1998, 1999, 2000, 2001, 2002 Free Software Foundation, Inc.
   This program is free software, covered by the GNU General Public License.

   This program is distributed in the hope that it will be useful, but WITHOUT ANY
   WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
   PARTICULAR PURPOSE.  See the GNU General Public License for more details.

   Using /dev/scsi/host0/bus0/target0/lun0/disc
   Information: The operating system thinks the geometry on
   /dev/scsi/host0/bus0/target0/lun0/disc is 151963/255/63.  Therefore, cylinder
   1024 ends at 8032.499M.
   (parted) print
   Disk geometry for /dev/scsi/host0/bus0/target0/lun0/disc: 0.000-1192040.000 megabytes
   Disk label type: msdos
   Minor    Start       End     Type      Filesystem  Flags
   1          0.031     23.532  primary   ext2        boot
   2         23.533 -905118.019  extended              
   5         23.563   1004.062  logical   linux-swap  
   6       1004.093  10589.721  logical   reiserfs    
   7      10589.752 -905118.019  logical   reiserfs    


This same problems (guessing...) is reported bu GRUB that reports:
   'Error 24: Attempt to access block outside partition'
as you can see below. What possible couse do you see?

Thanks In Advance.
sandro
*:-)



   grub> root (hd0,0)
    Filesystem type is ext2fs, partition type 0x83

   grub> setup (hd0)
    Checking if "/boot/grub/stage1" exists... no
    Checking if "/grub/stage1" exists... yes
    Checking if "/grub/stage2" exists... yes
    Checking if "/grub/e2fs_stage1_5" exists... yes
    Running "embed /grub/e2fs_stage1_5 (hd0)"...  16 sectors are embedded.
   succeeded
    Running "install /grub/stage1 d (hd0) (hd0)1+16 p (hd0,0)/grub/stage2 /grub/me
   nu.lst"... failed

   Error 24: Attempt to access block outside partition




-- 
Sandro Dentella  *:-)
e-mail: sandro@e-den.it 
http://www.tksql.org                    TkSQL Home page - My GPL work
