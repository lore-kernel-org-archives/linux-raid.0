From: Michael <michael@rw23.de>
Subject: Re: Map Block number from hdd to md
Date: Tue, 16 Feb 2010 11:57:00 +0100
Message-ID: <6a4b5c4af12e9b35347e7d325e4eee13@rw23.de>
References: <7362c3826262551b46e9b0bb1a777633@rw23.de> <20100216122014.18696241@notabene.brown> <20100216040252.GA28729@rap.rap.dk> <20100216043841.GA28967@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100216043841.GA28967@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld Simonsen <keld@keldix.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Keld,

if you do a smartctl -A on /dev/sdX you sould see something under
Current_Pending_Sector and Offline_Uncorrectable.
Your hard drive replaces the bad blocks with spare blocks as far as you
are write something to them.

i have solved the resync issue by using
dd if=/dev/zero of=/dev/sdX bs=512 seek=<bad-block-number> count=1

you can test the block number to be really bad by
dd if=/dev/sdX of=/dev/null bs=512 skip=<bad-block-number> count=1
if that command causes a input/output error, the block is bad.

in fact, with each block, you have "lost" 512 bytes of data. your problem
is very simular to mine.
after overwriting the bad blocks, all should be fine again.

you sould be able to "repair" all that bad blocks by a little xor'ing
script/program mentioned by neil brown.
if would be nice to have such a script where you can tell which
block/chunk is wrong and to which device to write to (and to read from).
with that program, the bad block will be overwritten with the (hopefully)
valid data and become functional again.

i also think this is a very common issue, that after a 1disk failue a 2nd
disk fails at resync because of bad blocks.
this could be prevented by doing a long smart check once a week or
something, but i did not had the idea to do that till today :)

On Tue, 16 Feb 2010 06:38:41 +0200, Keld Simonsen <keld@keldix.com> wrote:
> Further to my problems described below I dreamt up something that could
> solve my problem, till I got new disks installed.
> 
> I am actually alive with a raid5 with 2 malfunctioning devices -
> something that is impossible...  And I think I could be revived.
> And I think it is not an uncommon situation.
> 
> I have badblocks. But only about 60 blocks on one drive and 10 on the
> other, out of 4 drives. It is an error rate of about 1 out of 20,000
> or 99,995 % good data rate. If I could resync both the erroneous drives,
> and
> avoid the badblocks in the process, I would be safe (for some time). 
> 
> So if resync could be told to avoid the badblocks, and the file system
> in question also could be told to avoid the blocks then I could be in
> the air. I was then thinking of a userland resync process - no need to
> change the kernel, just install new mdadm and friends. Is that doable
> and useful?
> 
> best regards
> keld
