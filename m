From: "Martin Bene" <martin.bene@icomedias.com>
Subject: AW: RAID1 VS RAID5
Date: Tue, 28 Oct 2003 11:51:21 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4D618F6493CE064A844A5D496733D667031D77@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
To: Mario Giammarco <mgiammarco@virgilio.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> OTOH, you have access to the source code if you really want 
>> to try it 
>> another way.
>
>So again my first question thats seems to go ignored: does someone have
>made a patch? Is there some line to put in raidtab to change raid1
>behavior?

There used to be a patch for that, from the readme:

> Operation:

> In normal raid1 code (raidtools 0.90), reads are distributed
> in a very fine grained fashion, new read will get new disk.
> Only exception are sequential reads, which are never distributed.

> This patch records a logical linear position of head in every
> disk in array. Then when read requests is made it tries to
> find a disk which head is closest to the requested block and
> uses that disk. Initial measurements show performance gain
> in reading and in seeking with many readers.

> Flames, comments, improvements, benchmarks greatly 
> appreciated. Send them to miku@iki.fi

No idea if this is still applicable to current raid code or still maintained;
the old stuff used to be at 

http://www.icon.fi/~mak8/raid1/

Yours, martin
