From: Aaron Scheiner <blue@aquarat.za.net>
Subject: Re: Grub-install, superblock corrupted/erased and other animals
Date: Fri, 5 Aug 2011 12:04:49 +0200
Message-ID: <CADz4AWE20OdL4VecVOrOH5X-UqdB4BA00AW33YbYEtD1z30acA@mail.gmail.com>
References: <CADz4AWHJU5GGBji9uVbvGjPZCZ0CxseiPsQbssCULWxqyKvG8A@mail.gmail.com>
 <20110802163907.29fc40b4@notabene.brown> <CADz4AWEWm68H4ON=+StNE8epBfbnVHnSwJo+NjfTf8-w5Bd2Ug@mail.gmail.com>
 <20110803150108.58f5c70b@notabene.brown> <CADz4AWFekPKreuiwzYBvTnbXZnDGRH7nQ1WKEaeOdn7_6M5eQg@mail.gmail.com>
 <20110803192054.6097d2c0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110803192054.6097d2c0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I followed your advice and ran a scalpel instance for every drive in
the array. The scanning process finished this morning yay (and
obviously went a lot faster).

Firstly, here are some snippets from the dmesg log from the OS drive
that last successfully assembled the array (before the data cables and
power supply cables were scrambled due to a power supply being
upgraded) :

"
[    5.145251] md: bind<sde>
[    5.251753] md: bind<sdi>
[    5.345804] md: bind<sdh>
[    5.389398] md: bind<sdd>
[    5.549170] md: bind<sdf>
[    5.591170] md: bind<sdg1>
[    5.749707] md: bind<sdk>
[    5.952920] md: bind<sda>
[    6.153179] md: bind<sdj>
[    6.381157] md: bind<sdb>
[    6.388871] md/raid:md0: device sdb operational as raid disk 1
[    6.394742] md/raid:md0: device sdj operational as raid disk 6
[    6.400582] md/raid:md0: device sda operational as raid disk 8
[    6.406450] md/raid:md0: device sdk operational as raid disk 3
[    6.412290] md/raid:md0: device sdg1 operational as raid disk 7
[    6.418245] md/raid:md0: device sdf operational as raid disk 0
[    6.424097] md/raid:md0: device sdd operational as raid disk 2
[    6.429939] md/raid:md0: device sdh operational as raid disk 9
[    6.435807] md/raid:md0: device sdi operational as raid disk 4
[    6.441679] md/raid:md0: device sde operational as raid disk 5
[    6.448311] md/raid:md0: allocated 10594kB
[    6.452515] md/raid:md0: raid level 6 active with 10 out of 10
devices, algorithm 2
[    6.460218] RAID conf printout:
[    6.460219]  --- level:6 rd:10 wd:10
[    6.460221]  disk 0, o:1, dev:sdf
[    6.460223]  disk 1, o:1, dev:sdb
[    6.460224]  disk 2, o:1, dev:sdd
[    6.460226]  disk 3, o:1, dev:sdk
[    6.460227]  disk 4, o:1, dev:sdi
[    6.460229]  disk 5, o:1, dev:sde
[    6.460230]  disk 6, o:1, dev:sdj
[    6.460232]  disk 7, o:1, dev:sdg1
[    6.460234]  disk 8, o:1, dev:sda
[    6.460235]  disk 9, o:1, dev:sdh
[    6.460899] md0: bitmap initialized from disk: read 1/1 pages, set 3 bits
[    6.467707] created bitmap (15 pages) for device md0
[    6.520308] md0: detected capacity change from 0 to 16003181314048
[    6.527596]  md0: p1
"

I've taken the output from the files Scalpel generated and I've
assembled them on a spreadsheet. It's a Google Docs spreadsheet and it
can be viewed here :
https://spreadsheets.google.com/spreadsheet/ccc?key=0AtfzQK17PqSTdGRYbUw3eGtCM3pKVl82TzJWYWlpS3c&hl=en_GB

Samples from the the first 1.3MBs of the test file were found in the
following order :
sda
sdk
sdf
sdh
sdc
sdb
sdj
sdi
sdd

So now the next step would have been to re-create the array and check
if a file system check finds something... but because of the offsets
that probably won't work ?

Thanks again :)

On Wed, Aug 3, 2011 at 11:20 AM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 3 Aug 2011 10:59:22 +0200 Aaron Scheiner <blue@aquarat.za.net> wrote:
>
>> mmm, learning experience :P
>>
>> The Wikipedia page on grub says :
>> "
>> Stage 1 can load Stage 2 directly, but it's normally set up to load
>> Stage 1.5. GRUB Stage 1.5 is located in the first 30 kilobytes of hard
>> disk immediately following the MBR and before the first partition.
>> "
>> So if both stage 1 and stage 1.5 were written to the drives
>> approximately 30KBytes would have been overwritten, so 60 sectors?
>>
>> Why is the data offset by 256 bytes ? The array was created using a
>> standard create command (only specifying raid level, devices, chunk
>> size).
>
>
> The offset is 256 sectors (64K).
>
> The data obviously cannot go at the start of the drive as the metadata is
> there, so it is offset from the start.
> I leave 64K to allow for various different metadata (bitmap, bad-block log,
> other ideas I might have one day).
>
> NeilBrown
>
>
