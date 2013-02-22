From: Phil Turmel <philip@turmel.org>
Subject: Re: Brocken Raid & LUKS
Date: Fri, 22 Feb 2013 13:23:41 -0500
Message-ID: <5127B7AD.20105@turmel.org>
References: <5123A1CC.2000003@heisl.org> <5125EBFD.3050802@heisl.org> <51262137.3040609@turmel.org> <51262CE0.3000809@heisl.org> <51263785.2010001@turmel.org> <51263D9D.1080002@heisl.org> <51263F7E.7040207@turmel.org> <5126421E.3040702@turmel.org> <51264C18.8000201@heisl.org> <51264E26.9050100@turmel.org> <51264EBF.9090000@heisl.org> <51264F7F.3020508@turmel.org> <512650A1.7070103@heisl.org> <51265132.7070706@turmel.org> <512656B5.4090505@heisl.org> <51265824.4030407@heisl.org> <51265B0B.9020108@turmel.org> <51265DA7.2030209@heisl.org> <512660B9.8090609@turmel.org> <5126629A.1090002@heisl.org> <51266360.9030402@turmel.org> <5126678D.9030101@heisl.org> <51266D73.5020700@turmel.org> <51267192.6090205@heisl.org> <51267467.9040603@turmel.org> <512675A6.1000801@heisl.org> <5126797C.8090105@heis
 l.org> <51269DE0.5070905@heisl.org> <512748FA.2000709@heisl.org> <51277876.30008@turmel.org> <51278793.80904@heisl.org> <512790AE.2080102@turmel.org> <5127B64A.3000808@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5127B64A.3000808@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Stone <stone@heisl.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/22/2013 01:17 PM, Stone wrote:
> Am 22.02.2013 16:37, schrieb Phil Turmel:

>> After the script is done, look at all the saved files to see if any look
>> like possible solutions.

> i write a script and send my results back but you really wont a fsck -n
> /dev/mapper/md2_nas?
> the output i veeeery long like this:
> Illegal block number passed to ext2fs_mark_block_bitmap #2667529020 for
> in-use block map
> Illegal block number passed to ext2fs_test_block_bitmap #2667529021 for
> in-use block map
> Illegal block number passed to ext2fs_mark_block_bitmap #2667529021 for
> in-use block map
> Illegal block number passed to ext2fs_test_block_bitmap #2667529022 for
> in-use block map
> Illegal block number passed to ext2fs_mark_block_bitmap #2667529022 for
> in-use block map
> Illegal block number passed to ext2fs_test_block_bitmap #2667529023 for
> in-use block map
> Illegal block number passed to ext2fs_mark_block_bitmap #2667529023 for
> in-use block map
> Illegal block number passed to ext2fs_test_block_bitmap #2667529024 for
> in-use block map
> Illegal block number passed to ext2fs_mark_block_bitmap #2667529024 for
> in-use block map
> Illegal block number passed to ext2fs_test_block_bitmap #2667529025 for
> in-use block map
> Illegal block number passed to ext2fs_mark_block_bitmap #2667529025 for
> in-use block map

No, I don't need to see such results.  I meant for you to look at them
yourself to see if one appears to have many fewer errors than the
others.  If you find one, you can share that one with us (report file
size < 100k or so).

Phil
