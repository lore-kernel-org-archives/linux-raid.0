From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Mustn't be RAID 1 and 0 read-performance be similar?
Date: Mon, 13 Aug 2007 16:49:52 +0200
Message-ID: <f9pr2g$pgj$1@sea.gmane.org>
References: <735D322AED9CD711BE53000476917CD00281A96B@NT-SERVER-5>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rustedt, Florian <florian.rustedt@smartnet.de> wrote:
> If the speed on RAID 0 is based on reading out in parallel, then it must be
> the same on RAID 1, mustn't it?
> On RAID 1, it is possible, to read two blocks in parallel to speed up, too.

It's not that simple.
On RAID0 you can read one single stream of data from all of the disks in
parallel: you read one stream from each disk with each stream containing
completely different data and merge them together to get the original
stream. On RAID1 you can only read exactly the same stream from all of
the disks. Thus, RAID1 cannot provide RAID0's speed-up for a single
stream.
However, if you read multiple streams parallel, RAID1 can do better than
RAID0 because you can read stream1 from disk1, stream2 from disk2 etc.
Using RAID0, this speed-up can only be achieved for streams <= chunk
size.


regards
   Mario
-- 
Tower: "Say fuelstate." Pilot: "Fuelstate."
Tower: "Say again." Pilot: "Again."
Tower: "Arghl, give me your fuel!" Pilot: "Sorry, need it by myself..."

