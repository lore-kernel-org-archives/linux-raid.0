From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: High mismatch count on root device - how to best handle?
Date: Sun, 01 May 2011 22:50:32 +0800
Message-ID: <4DBD7338.4060206@fnarfbargle.com>
References: <BANLkTikLN6P52tknwD0+D-+2iDUp3sF1fA@mail.gmail.com>	<BANLkTikwv-PRcwknZkMsPY6T+N0p=-uC4w@mail.gmail.com>	<BANLkTinS9=v+qHAyewRu19HgGr4iriwjkw@mail.gmail.com>	<4DB71F3E.3040003@turmel.org>	<BANLkTinpDOuTDu7fhbXNYwtvToUaCM=cmQ@mail.gmail.com>	<4DB8BEFE.3020009@turmel.org>	<20110428053123.B031BD52709@gemini.denx.de> <BANLkTikBkaWsDicptHsX3dz=RW5_bL2Z7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikBkaWsDicptHsX3dz=RW5_bL2Z7A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Wolfgang Denk <wd@denx.de>, Phil Turmel <philip@turmel.org>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/05/11 06:51, Mark Knecht wrote:
> On Wed, Apr 27, 2011 at 10:31 PM, Wolfgang Denk<wd@denx.de>  wrote:
>> Dear Phil Turmel,
>>
>> In message<4DB8BEFE.3020009@turmel.org>  you wrote:
>>>
>>> Hmmm.  Since its not swap, this would make me worry about the hardware.  Have you considered shuffling SATA port assignments to see if a pattern shows up?  Also consider moving some of the drive power load to another PS.
>>
>> I do not think this is hardware related.  I see this behaviour on at
>> least 5 different machines which show no other problems except for the
>> mismatch count in the RAID 1 partitins that hold the /boot partition.

root@srv:/server# grep . /sys/block/md?/md/mismatch_cnt
/sys/block/md0/md/mismatch_cnt:0
/sys/block/md1/md/mismatch_cnt:128
/sys/block/md2/md/mismatch_cnt:0
/sys/block/md3/md/mismatch_cnt:41728
/sys/block/md4/md/mismatch_cnt:896
/sys/block/md5/md/mismatch_cnt:0
/sys/block/md6/md/mismatch_cnt:4352

root@srv:/server# cat /proc/mdstat | grep md[1346]
md6 : active raid1 sdp6[0] sdo6[1]
md4 : active raid1 sdp3[0] sdo3[1]
md3 : active raid1 sdp2[0] sdo2[1]
md1 : active raid1 sdp1[0] sdo1[1]

root@srv:/server# cat /etc/fstab | grep md[1346]
/dev/md1        /               ext4 
errors=remount-ro,commit=30,noatime     0 1
/dev/md6        /raid0          ext4    defaults,commit=30,noatime      0 1
/dev/md4        /home           ext4    defaults,commit=30,noatime      0 1
/dev/md3        none            swap    sw

I see them _all_ the time on RAID1's..

When I configured this system _years_ ago, I did not know any better, so 
it's a bit of a mish-mash.

The machine also has a 10 drive RAID-6 and a 3 drive RAID-5. The only 
time I've seen mismatches on those is when I used a SIL 3132 controller 
and it trashed the RAID-6.

Brad
