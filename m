From: Jean Jordaan <jean@upfrontsystems.co.za>
Subject: Re: Recovering RAID5 array
Date: Tue, 20 Jan 2004 15:28:54 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <400D2D16.2000503@upfrontsystems.co.za>
References: <400CD0BF.2010808@upfrontsystems.co.za> <200401201310.48900.maarten@vbvb.nl> <400D1DA6.80509@upfrontsystems.co.za> <200401201357.32747.maarten@vbvb.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200401201357.32747.maarten@vbvb.nl>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Maarten, Neil,

It worked! For the record, my rebuild-tree output is below.
It looks like that reiserfs was sick, sick, sick.

Thank you very much for your cautious, reasoned and calm
responses.

Everything ended up in lost+found, but I could retrieve the
one critical file, namely

/mnt/gentoo/raid/lost+found/2_5369/lib/zope/zope-pendrums/var/Data.fs

cdimage root # reiserfsck --rebuild-tree /dev/md0

<-------------reiserfsck, 2003------------->
reiserfsprogs 3.6.8

[...]
Will rebuild the filesystem (/dev/md0) tree
Will put log info to 'stdout'

Do you want to run this program?[N/Yes] (note need to type Yes if you do):Yes
Replaying journal..
0 transactions replayed
###########
reiserfsck --rebuild-tree started at Tue Jan 20 12:44:02 2004
###########

Pass 0:
####### Pass 0 #######
Loading on-disk bitmap .. ok, 647544 blocks marked used
Skipping 8790 blocks (super block, journal, bitmaps) 638754 blocks will be read
0%....20%....40%....60%....80%....100%                       left 0, 22026 /sec
193779 directory entries were hashed with "r5" hash.
         "r5" hash is selected
Flushing..finished
         Read blocks (but not data blocks) 638754
                 Leaves among those 38854
                 Objectids found 8553

Pass 1 (will try to insert 38854 leaves):
####### Pass 1 #######
Looking for allocable blocks .. finished
0%....20%....40%....60%....80%....100%                        left 0, 3532 /sec
Flushing..finished
         38854 leaves read
                 38778 inserted
                         - pointers in indirect items pointing to metadata 3 
(zeroed)
                 76 not inserted
####### Pass 2 #######

Pass 2:
0%....20%....40%....60%....80%....100%                           left 0, 0 /sec
Flushing..finished
         Leaves inserted item by item 76
Pass 3 (semantic):
####### Pass 3 #########
Flushing..finished
         Files found: 0
         Directories found: 2
Pass 3a (looking for lost dir/files):
####### Pass 3a (lost+found pass) #########
Looking for lost directories:
/2_4vpf-10680: The directory [2 4] has the wrong block count in the StatData (1) 
- corrected to (2)
vpf-10650: The directory [2 4] has the wrong size in the StatData (48) - 
corrected to (752)
/2_113get_next_directory_item: The entry ".." of the directory [2 113] pointes 
to [1 2], instead of [2 258218] - corrected
/2_5022get_next_directory_item: The entry ".." of the directory [2 5022] pointes 
to [1 2], instead of [2 258218] - corrected
/2_5212get_next_directory_item: The entry ".." of the directory [2 5212] pointes 
to [1 2], instead of [2 258218] - corrected
/2_5360get_next_directory_item: The entry ".." of the directory [2 5360] pointes 
to [1 2], instead of [2 258218] - corrected
/2_5365get_next_directory_item: The entry ".." of the directory [2 5365] pointes 
to [1 2], instead of [2 258218] - corrected
/2_5367get_next_directory_item: The entry ".." of the directory [2 5367] pointes 
to [1 2], instead of [2 258218] - corrected
/2_5369get_next_directory_item: The entry ".." of the directory [2 5369] pointes 
to [1 2], instead of [2 258218] - corrected
/2_5369/log/wtmpvpf-10680: The file [7261 7264] has the wrong block count in the 
StatData (1152) - corrected to (1128)
/2_7587get_next_directory_item: The entry ".." of the directory [2 7587] pointes 
to [1 2], instead of [2 258218] - corrected
/2_26686get_next_directory_item: The entry ".." of the directory [2 26686] 
pointes to [1 2], instead of [2 258218] - corrected
/2_26689get_next_directory_item: The entry ".." of the directory [2 26689] 
pointes to [1 2], instead of [2 258218] - corrected
/2_26784get_next_directory_item: The entry ".." of the directory [2 26784] 
pointes to [1 2], instead of [2 258218] - corrected
Looking for lost files:
The object [141767 141772] has wrong mode (b--xr--r-x) - corrected to -rw-------
vpf-10670: The file [141767 141772] has the wrong size in the StatData (0) - 
corrected to (1912)
vpf-10680: The file [141767 141772] has the wrong block count in the StatData 
(0) - corrected to (8)
The object [141778 141818] has wrong mode (?---------) - corrected to -rw-------
vpf-10670: The file [141778 141818] has the wrong size in the StatData (0) - 
corrected to (1640)
vpf-10680: The file [141778 141818] has the wrong block count in the StatData 
(0) - corrected to (8)
The object [141836 141840] has wrong mode (?---------) - corrected to -rw-------
Flushing..finished
         Objects without names 19557
         Empty lost dirs removed 166439
         Dirs linked to /lost+found: 12
                 Dirs without stat data found 1
         Files linked to /lost+found 1975
         Objects having used objectids: 4887
                 dirs fixed 2
Pass 4 - finished       done 0, 0 /sec
         Deleted unreachable items 6
Flushing..finished
Syncing..finished
###########
reiserfsck finished at Tue Jan 20 12:46:00 2004
###########
cdimage root # mount -r -t reiserfs /dev/md0 /mnt/gentoo/raid/
cdimage root # ls /mnt/gentoo/raid/
lost+found

-- 
Jean Jordaan
http://www.upfrontsystems.co.za

