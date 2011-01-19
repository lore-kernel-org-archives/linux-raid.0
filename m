From: Marc MERLIN <marc@merlins.org>
Subject: Re: How to force rewrite of a smart detected bad block with raid5: checkarray?
Date: Wed, 19 Jan 2011 09:31:50 -0800
Message-ID: <20110119173150.GB6823@merlins.org>
References: <20110119070419.GC31606@merlins.org> <alpine.DEB.1.10.1101190842170.13151@uplift.swm.pp.se> <20110119204115.0fe4b159@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110119204115.0fe4b159@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 19, 2011 at 08:41:15PM +1100, NeilBrown wrote:
> All you need to do is get md/raid5 to try reading the bad block.  Once it does
> that it will get a read error and automagically try to correct it.
 
So, if I get this right, raid5 only reads n-1 drives. Unless I'm unlucky
enough to have the bad disk be the parity stripe, just reading the file with
a bad stripe by luck would cause the kernel to recompute parity on the read
error and re-write the bad block?
(I also read in the online docs that raid4 actually reads all the blocks,
including parity, which is a bit slower, but would actually guarantee that
all blocks are read, and parity is still consistent at ready time?)


But back to your point: check, which I had started, will indeed do what I
was hoping it would, thanks.

> If you were really keen, you could 
>   cd /sys/block/mdXX/md
>   echo 3907029168 > sync_min
>   echo 3907029170 > sync_max
>   echo check > sync_action

I stopped the full check, and tried:
 
gargamel:/sys/block/md7/md# cat sync_min
244188936
gargamel:/sys/block/md7/md# cat sync_max
max
gargamel:/sys/block/md7/md# echo 3907029168 > sync_min
bash: echo: write error: Invalid argument

Any idea what went wrong here?

gargamel:/sys/block/md7/md# mdadm --detail /dev/md7
/dev/md7:
        Version : 1.02
  Creation Time : Thu Mar 25 20:15:00 2010
     Raid Level : raid5
     Array Size : 7814045696 (7452.05 GiB 8001.58 GB)
  Used Dev Size : 1953511424 (1863.01 GiB 2000.40 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

    Update Time : Wed Jan 19 09:27:57 2011
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
         
         Layout : left-symmetric
     Chunk Size : 512K
           
           Name : gargamel.svh.merlins.org:7  (local to host gargamel.svh.merlins.org)
           UUID : 5884576b:0e402a5d:8629093c:ec020760
         Events : 28714

    Number   Major   Minor   RaidDevice State
       0       8      129        0      active sync   /dev/sdi1
       1       8      145        1      active sync   /dev/sdj1
       2       8      161        2      active sync   /dev/sdk1
       3       8      177        3      active sync   /dev/sdl1
       5       8      113        4      active sync   /dev/sdh1


As for docs, a bit of googling before posting didn't help. I since then
found the new README.checkarray in my /usr/share/doc (debian), so that helps
although it doesn't talk about check vs repair.

Also, I didn't find anything about sync_action, check, and repair in the
mdadm man page (a pointer to
https://raid.wiki.kernel.org/index.php/RAID_Administration
would me useful).
Actually the above page still says that you can't check just a range of blocks.

Is there more up to date documentation that I should be reading somewhere?

Thanks for your answer,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems & security ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
