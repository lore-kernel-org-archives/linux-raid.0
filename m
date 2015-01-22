From: Valentijn <v@lentijn.sess.ink>
Subject: Re: mdadm RAID6 "active" with spares and failed disks; need help
Date: Thu, 22 Jan 2015 10:47:38 +0100
Message-ID: <54C0C73A.4080409@lentijn.sess.ink>
References: <54ABEE54.6020707@sympatico.ca> <BLU436-SMTP156F9ECC68035EAC3DFB5F181460@phx.gbl> <BLU437-SMTP96782B2C74C634FDED13D681420@phx.gbl> <54B305B2.6000702@lentijn.sess.ink> <54B3F7ED.1000809@youngman.org.uk> <BLU436-SMTP1430CA88C11B0E46F15BB3F81480@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU436-SMTP1430CA88C11B0E46F15BB3F81480@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Callaghan <matt_callaghan@sympatico.ca>, Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Matt,

As long as your data is still somewhere on these disks, all is not - 
necessarily - lost. You could still try using dumpe2fs (and later 
e2fsck) and/or dumpe2fs with different superblocks. And even if you 
cannot find your file system by any means, you could try to use the 
"foremost" utility to scrape off images, documents and the like from 
these disks.

So I still don't think all is lost. However, I do think that will cost 
more time. You may want to dedicate a spare machine to this task, 
because of the resources.

I see that your mdadm says this, somewhere along your odyssee:
mdadm: /dev/sdk1 appears to contain an ext2fs file system
        size=1695282944K  mtime=Tue Apr 12 11:10:24 1977
... which could mean (I'm not sure, I'm just guessing) that due to the 
internal bitmap, your fs has been overwritten.

Your new array in fact said:
Internal Bitmap : 8 sectors from superblock
     Update Time : Wed Jan  7 09:46:44 2015
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : c7603819 - correct
          Events : 0
... as far as I understand, this means that 8 blocks from the 
superblock, some - whatever size - sectors were occupied by the Internal 
Bitmap, which, in turn, would mean your filesystem superblock has been 
overwritten.

The good news is: there is more than one superblock.

BTW, didn't you have the right raid drive ordering from the original 
disks? You did have output of "mdadm --examine" after the array broke 
down, didn't you? So your "create" statement is, by definition, correct 
if a new "--examine" output shows the same output - hence the filesystem 
is correct if the latter is the case?

So please try if "dumpe2fs -h -o superblock=32768" does anything. Or 
98304, 163840, 229376. Dumpe2fs just dumps the fs header, nothing more.

If dumpe2fs doesn't do anything (but complain that it "Couldn't find 
valid filesystem superblock"), then you could still try if "foremost" 
finds anything. It's not that hard to use, you simply dedicate some 
storage to it and tell it to scrape your array. It *will* find things 
and it's up to you to see if
1) documents, images and the like are all 64K or 128K or less - and/or 
contain large blocks of rubbish. This probably means you have the wrong 
array config, because foremost in this case only finds single "chunks" 
with correct data - if a file is longer, it doesn't find it and/or spews 
out random data from other images
2) documents, images etcetera are OK. This means your array is OK. You 
then can use foremost to scrape off everything (it may take weeks but it 
could work), or simply try to find where the filesystem superblock hangs 
out (if the array is in good order, the fs superblock must be somewhere, 
right?)

Please, please try to do as little as possible on the real disks. Use 
dmsetup to create snapshots. Copy the disks. Use hardware that is in 
good state - you don't want to loose your data that you just found back 
because the memory is flakey, do you? ;-)

I hope it's going to work.

Best regards,

Valentijn

On 01/21/15 01:34, Matt Callaghan wrote:
> I tried again with the --bitmap=none, clearly that was a miss on my part.
> However, still even with that correction, and attempting across varying
> combinations of "drive ordering", the filesystem appears corrupt.
