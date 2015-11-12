From: matt@digitallyhosted.com
Subject: badblocks seem to be causing problems with raid6 - badblocks list
 replicating all all drives
Date: Thu, 12 Nov 2015 11:34:09 +0000
Message-ID: <3fafa3e9267b4ba0b5f9d61d3a416cf5@digitallyhosted.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I posted a while back about getting buffer i/o errors in my dmesg logs 
to my raid array, something along the lines of this:

[158219.456484] EXT4-fs warning (device md4): ext4_end_bio:329: I/O 
error -5 writing to inode 125274714 (offset 176160768 size 8388608 
starting block 4955235712)
[158219.456487] Buffer I/O error on device md4, logical block 4955235584
[158219.456490] Buffer I/O error on device md4, logical block 4955235585
[158219.456491] Buffer I/O error on device md4, logical block 4955235586
[158219.456491] Buffer I/O error on device md4, logical block 4955235587
[158219.456492] Buffer I/O error on device md4, logical block 4955235588
[158219.456493] Buffer I/O error on device md4, logical block 4955235589
[158219.456494] Buffer I/O error on device md4, logical block 4955235590
[158219.456495] Buffer I/O error on device md4, logical block 4955235591
[158219.456496] Buffer I/O error on device md4, logical block 4955235592
[158219.456497] Buffer I/O error on device md4, logical block 4955235593
[158219.456580] EXT4-fs warning (device md4): ext4_end_bio:329: I/O 
error -5 writing to inode 125274714 (offset 176160768 size 8388608 
starting block 4955235456)
[158219.456663] EXT4-fs warning (device md4): ext4_end_bio:329: I/O 
error -5 writing to inode 125274714 (offset 176160768 size 8388608 
starting block 4955235200)
[158219.456747] EXT4-fs warning (device md4): ext4_end_bio:329: I/O 
error -5 writing to inode 125274714 (offset 176160768 size 8388608 
starting block 4955234944)
[158219.456829] EXT4-fs warning (device md4): ext4_end_bio:329: I/O 
error -5 writing to inode 125274714 (offset 176160768 size 8388608 
starting block 4955234688)
[158219.456912] EXT4-fs warning (device md4): ext4_end_bio:329: I/O 
error -5 writing to inode 125274714 (offset 176160768 size 8388608 
starting block 4955234432)
[158469.158278] EXT4-fs warning (device md4): ext4_end_bio:329: I/O 
error -5 writing to inode 123995503 (offset 0 size 8388608 starting 
block 4970080384)
[158469.158281] buffer_io_error: 1526 callbacks suppressed

I am now using the latest mainline kernel, 4.3.0 and I believe something 
is going wrong with the badblocks implementation.

I originally had 3 drives, all with the same badblocks list.  This array 
has been running a while so I have no idea how these 3 discs all ended 
up with the same list of badblocks.

Now, if I remove any drive, which has no badblock entries, and re-add 
it.  Once the sync is complete I end up with another drive with the same 
badblocks list.

At the moment 5 of the drives in the array all have the following 
entries (exactly the same):

Bad-blocks on /dev/sdi1:
           1938038928 for 512 sectors
           1938039440 for 512 sectors
           1938977144 for 512 sectors
           1938977656 for 512 sectors
           3303750816 for 512 sectors
           3303751328 for 512 sectors
           3313648904 for 512 sectors
           3313649416 for 512 sectors
           3313651976 for 512 sectors
           3313652488 for 512 sectors
           3418023432 for 512 sectors
           3418023944 for 512 sectors
           3418024456 for 512 sectors
           3418024968 for 512 sectors
           3418037768 for 512 sectors
           3418038280 for 512 sectors
           3418038792 for 512 sectors
           3418039304 for 512 sectors
           3418112520 for 512 sectors
           3418113032 for 512 sectors
           3418113544 for 512 sectors
           3418114056 for 512 sectors
           3418114568 for 512 sectors
           3418115080 for 512 sectors
           3418124808 for 512 sectors
           3418125320 for 512 sectors
           3418165768 for 512 sectors
           3418166280 for 512 sectors
           3418187272 for 512 sectors
           3418187784 for 512 sectors
           3418213224 for 512 sectors
           3418213736 for 512 sectors
           3418214248 for 512 sectors
           3418214760 for 512 sectors
           3418215272 for 512 sectors
           3418215784 for 512 sectors
           3420607528 for 512 sectors
           3420608040 for 512 sectors
           3420626984 for 512 sectors
           3420627496 for 512 sectors
           3448897824 for 512 sectors
           3448898336 for 512 sectors
           3458897888 for 512 sectors
           3458898400 for 512 sectors
           3519403992 for 512 sectors
           3519404504 for 512 sectors
           3617207456 for 512 sectors
           3617207968 for 512 sectors


How can I clear the badblocks list on all the drives? Something seems 
very wrong and I believe I only actually have 1 faulty disc (I have run 
smartctl long tests on all drives, only 1 failed).

If I can't clear them, how can I get ext4 to recognise the badblocks 
within the array so that it no longer attempts to write to those blocks?

Do the blocks in the list above map to blocks on a the physical 
harddrive, or to blocks on the md device - IE: If that block list was 
passed to ext4 filesystem as bad sectors, would that be the correct 
location on the array or are those the badblocks on one of the 
harddrives in the array.

Thanks
