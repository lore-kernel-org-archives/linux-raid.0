From: Troy Benjegerdes <hozer@drgw.net>
Subject: on-disk superblock sanity checking
Date: Sun, 11 Aug 2002 02:17:56 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020811071755.GF3215@altus.drgw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have recently run into a case where a kernel bug appears to have written 
a bogus value into the raid superblock structure (in particular, 
sb->disks[26].raid_disk was 0xd7e56000).

This caused the following code in raid1_run() to kernel panic..

        for (i = 0; i < MD_SB_DISKS; i++) {

                //descriptor = sb->disks+i;
                descriptor = &sb->disks[i];
                disk_idx = descriptor->raid_disk;
                disk = conf->mirrors + disk_idx;


'mkraid --force /dev/md0' appears to have cleaned up the panic on boot 
problem.. but I wonder if it wouldn't be a good idea to have some 
additional sanity checking? 

-- 
Troy Benjegerdes | master of mispeeling | 'da hozer' |  hozer@drgw.net
-----"If this message isn't misspelled, I didn't write it" -- Me -----
"Why do musicians compose symphonies and poets write poems? They do it
because life wouldn't have any meaning for them if they didn't. That's 
why I draw cartoons. It's my life." -- Charles Schulz
