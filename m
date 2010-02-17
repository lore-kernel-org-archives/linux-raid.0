From: Michael <michael@rw23.de>
Subject: Re: Map Block number from hdd to md
Date: Wed, 17 Feb 2010 09:43:02 +0100
Message-ID: <2d64e86876640084dedbcf93a7b9cc9a@rw23.de>
References: <7362c3826262551b46e9b0bb1a777633@rw23.de> <20100216122014.18696241@notabene.brown> <20100216040252.GA28729@rap.rap.dk> <20100216043841.GA28967@rap.rap.dk> <6a4b5c4af12e9b35347e7d325e4eee13@rw23.de> <20100217033438.GA8228@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100217033438.GA8228@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld Simonsen <keld@keldix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 17 Feb 2010 05:34:38 +0200, Keld Simonsen <keld@keldix.com> wrote:
> On Tue, Feb 16, 2010 at 11:57:00AM +0100, Michael wrote:
>> Hi Keld,
>> 
>> if you do a smartctl -A on /dev/sdX you sould see something under
>> Current_Pending_Sector and Offline_Uncorrectable.
>> Your hard drive replaces the bad blocks with spare blocks as far as you
>> are write something to them.
>> 
>> i have solved the resync issue by using
>> dd if=/dev/zero of=/dev/sdX bs=512 seek=<bad-block-number> count=1
>> 
>> you can test the block number to be really bad by
>> dd if=/dev/sdX of=/dev/null bs=512 skip=<bad-block-number> count=1
>> if that command causes a input/output error, the block is bad.
> 
> Yes, that cleared some errors, but unfortunately not all.
> That is one divice had 72bad blocks beforehand, and 44 afterwaeds, and
> the other had 9 beforehand, and 5 after.
> 
> The second dd command actuallly did not report any bad blocks, but a
> selective badblocks command did.
strange. if the 2nd command is working, you can recover the data and write
it back. i have heard about bad blocks that are "sometimes" bad, and other
times not. iam not sure.

> 
> Anyway, is there something about Samsung disks not having spare blocks 
> for this?

Model Family:     SAMSUNG SpinPoint F1 DT series
Device Model:     SAMSUNG HD103UJ               
that's my disk, and it has spare blocks.
check smartctl -A /dev/sdX for Current_Pending_Sector and
Offline_Uncorrectable


> yes, I still would like to find the inode in the raid file system from 
> the bad block on a physical disk.

yeah, me to.
