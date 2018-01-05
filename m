From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: SMART detects pending sectors; take offline?
Date: Fri, 5 Jan 2018 13:20:31 +0800
Message-ID: <bc2e597b-1585-f9b6-ef1a-f1aa3e1f39a0@fnarfbargle.com>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org>
 <fcb32200-19f7-5513-24a0-70ca15ca6297@shenkin.org>
 <7bf0a71e-6cb7-59bc-695b-54ed6b08112b@turmel.org>
 <d86c80ba-7703-1591-7816-00d0d9408386@shenkin.org>
 <a5487193-24e6-879b-bd09-caf5f75c8fcc@turmel.org>
 <05e4489d-98ea-4d12-02d6-f13a98e3d5d4@shenkin.org>
 <201ea04e-1a03-fc83-c31c-146b50bb8624@thelounge.net>
 <47ec07c3-25ae-9595-78a2-8420c106f2a0@fnarfbargle.com>
 <20497c70-140d-c4dd-0201-816477bd467f@shenkin.org>
 <14f1fce1-2959-e051-f7c8-1d98951d744a@fnarfbargle.com>
 <07170cf8-d951-013b-7e67-eee54aa60c65@shenkin.org>
 <61e91b55-5b96-143e-15c8-4a320f89eeb2@turmel.org>
 <ae183814-248b-2d45-8074-85787fcd0d61@shenkin.org>
 <6572ed42-8559-84eb-0468-7823786c3001@turmel.org>
 <7bce6228-0695-ff30-7cc0-60486be128ff@shenkin.org>
 <c24ffbc6-6ba6-ef04-76f3-2217fe5f4926@shenkin.org>
 <97c75be5-1988-0e66-0d50-f06188418b3b@fnarfbargle.com>
 <cd34964a-e269-6dd7-3c36-73a9c8dbb61d@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cd34964a-e269-6dd7-3c36-73a9c8dbb61d@shenkin.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>, Phil Turmel <philip@turmel.org>, Reindl Harald <h.reindl@thelounge.net>, Edward Kuns <eddie.kuns@gmail.com>, Mark Knecht <markknecht@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/01/18 21:39, Alexander Shenkin wrote:
> Thanks Brad, no worries, really appreciate your attention.  I stopped 
> checkarray.  It had one rebuild event (Rebuild99) in /dev/md0 (small 
> RAID1, where /boot is mounted) before I stopped it.  Here's the 
> examine output (not really sure what to do with it, will wait for 
> advice):

Ok, so you have 4 disks with 2 partitions on each.
You re-wrote Sectors 5857843312+7 on the disk.

Without knowing the layout of your partitions it's a bit difficult, but 
lets make an assumption and see where it gets us.
You have a partition table. Lets assume 1st partition starts at sector 
2048 as fdisk will often leave that for alignment.
1st partition data offset is 2048 sectors (1M for superblock) and is 
3901312 sectors long, so it ends at 3905408 (3901312+2048+2048)
2nd partition data offset is 262144 sectors and is 5840377856 sectors 
long, totaling 5840640000 sectors.
Add those two and we get 5844545408 sectors. So if my maths is any good 
you wrote a block 13297904 sectors from the end of the data area.

Now the whole point of that was to say if the block you wrote happens to 
fall in a parity area, then you are fine. Checkarray will just 
re-calculate the parity from the data blocks and re-write it. Your 
mismatch count will be 1 at the end of the operation.
If however the block falls in a data area, running checkarray is going 
to use that re-written block to re-calculate the parity and it's corrupt 
for good.

Now I need someone to re-check my maths, and an fdisk -l /dev/sda from 
you to see if I've made any glaring error. My assessment is that block 
*did* lay in the data area of the disk.

If I'm right, then the only way I can see to rectify it is to pop sda 
out, zero the superblock and re-add it which will rebuild the disk 
entirely but that leaves you extremely vulnerable for the entire 
process. Of course if there is nothing on the filesystem at that 
location, or you are ok with losing a 4k chunk of a file then this is 
all moot.

At this point I'd be most glad to be proven incorrect.

Regards,
Brad

-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.

