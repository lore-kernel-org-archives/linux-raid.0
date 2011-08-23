From: Piotr Legiecki <piotrlg@pum.edu.pl>
Subject: Re: RAID10 failed with two disks
Date: Tue, 23 Aug 2011 10:35:20 +0200
Message-ID: <4E536648.3060803@pum.edu.pl>
References: <4E5231EE.3010001@pum.edu.pl>	<20110822210903.2582bcfd@notabene.brown>	<4E5240BE.1050807@pum.edu.pl>	<20110822220129.5b2928ff@notabene.brown>	<4E525122.7090607@pum.edu.pl> <20110823095634.398f2118@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110823095634.398f2118@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>> Hura, hura, hura! ;-) Well, wonder why it didn't work for me ;-(
> 
> Looks good so far, but is you data safe?

I think so.
fsck has found some errors and corrected them.
resync done
cat /sys/block/md4/md/mismatch_cnt
0
Looks good.


> This is correct assuming the default layout.
> If you asked for "--layout=n3" you would get a 3-way mirror over a1,b1,c1 and
> d1,e1,f1 and those would be raid0-ed.

And the question which one is the most efficient  is beyond the scope of 
our subject I'm of course? Or maybe there is some general rule of thumb 
for this?

The more disks the faster array should be *but* the more data to mirror 
at once when writing...

Anyway my tests proved that RAID1 on two disks is *much* slower than 
RAID10 on 4 disks. RAID10 SATA can easily compete with HP SmartAray 
P410i/BBC SAS RAIDs (but in RAID1 only ;-)). Well, at least during 
iozone benchmarks.

> If you had 5 devices then you get data copied on
>   sda1+sdb1
>   sdc1+sdd1
>   sde1+sda1
>   sdb1+sdc1
>   sdde+sde1
> 
> so is *any* pair of adjacent devices fail, you lose data.

So from safety point of view there is need for more spare disks or go 
for RAID6.

> Hard to tell without seeing kernel logs.  Almost certainly a hardware issue
> of some sort.  Maybe a loose or bumped cable. Maybe a power supply spike.
> Maybe a stray cosmic ray....

http://pastebin.com/iapZWm0S

Those 'failed' disks are connected to motherboard SATA ports. I've got 
also Adaptec 1430 adapter with 2 free ports, maybe I should move those 
disks there.

Thank you for all the help and time put into answering my questions.

Piotr
