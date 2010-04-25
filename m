From: "Janos Haar" <janos.haar@netcenter.hu>
Subject: Re: Suggestion needed for fixing RAID6
Date: Sun, 25 Apr 2010 12:00:21 +0200
Message-ID: <756601cae45e$213d6190$0400a8c0@dcccs>
References: <626601cae203$dae35030$0400a8c0@dcccs> <20100423065143.GA17743@maude.comedia.it> <695a01cae2c1$a72907d0$0400a8c0@dcccs> <4BD193D0.5080003@shiftmail.org> <717901cae3e5$6a5fa730$0400a8c0@dcccs> <4BD3751A.5000403@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: MRK <mrk@shiftmail.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message ----- 
From: "MRK" <mrk@shiftmail.org>
To: "Janos Haar" <janos.haar@netcenter.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Sunday, April 25, 2010 12:47 AM
Subject: Re: Suggestion needed for fixing RAID6

Just a little note:

The repair-sync action failed similar way too. :-(


> On 04/24/2010 09:36 PM, Janos Haar wrote:
>>
>> Ok, i am doing it.
>>
>> I think i have found some interesting, what is unexpected:
>> After 99.9% (and another 1800minute) the array is dropped the dm-snapshot 
>> structure!
>>
>> ...[CUT]...
>>
>> raid5:md3: read error not correctable (sector 2923767944 on dm-0).
>> raid5:md3: read error not correctable (sector 2923767952 on dm-0).
>> raid5:md3: read error not correctable (sector 2923767960 on dm-0).
>> raid5:md3: read error not correctable (sector 2923767968 on dm-0).
>> raid5:md3: read error not correctable (sector 2923767976 on dm-0).
>> raid5:md3: read error not correctable (sector 2923767984 on dm-0).
>> raid5:md3: read error not correctable (sector 2923767992 on dm-0).
>> raid5:md3: read error not correctable (sector 2923768000 on dm-0).
>>
>> ...[CUT]...
>>
>> So, the dm-0 is dropped only for _READ_ error!
>
> Actually no, it is being dropped for "uncorrectable read error" which 
> means, AFAIK, that the read error was received, then the block was 
> recomputed from the other disks, then a rewrite of the damaged block was 
> attempted, and such *write* failed. So it is being dropped for a *write* 
> error. People correct me if I'm wrong.

I think i can try:

# dd_rescue -v /dev/zero -S $((2923767944 / 2))k /dev/mapper/cow  -m 4k
dd_rescue: (info): about to transfer 4.0 kBytes from /dev/zero to 
/dev/mapper/cow
dd_rescue: (info): blocksizes: soft 65536, hard 512
dd_rescue: (info): starting positions: in 0.0k, out 1461883972.0k
dd_rescue: (info): Logfile: (none), Maxerr: 0
dd_rescue: (info): Reverse: no , Trunc: no , interactive: no
dd_rescue: (info): abort on Write errs: no , spArse write: if err
dd_rescue: (info): ipos:         0.0k, opos:1461883972.0k, xferd: 
0.0k
                   errs:      0, errxfer:         0.0k, succxfer: 
0.0k
             +curr.rate:        0kB/s, avg.rate:        0kB/s, avg.load: 
0.0%
Summary for /dev/zero -> /dev/mapper/cow:
dd_rescue: (info): ipos:         4.0k, opos:1461883976.0k, xferd: 
4.0k
                   errs:      0, errxfer:         0.0k, succxfer: 
4.0k
             +curr.rate:      203kB/s, avg.rate:      203kB/s, avg.load: 
0.0%


>
> This is strange because the write should have gone to the cow device. Are 
> you sure you did everything correctly with DM? Could you post here how you 
> created the dm-0 device?

echo 0 $(blockdev --getsize /dev/sde4) \
        snapshot /dev/sde4 /dev/loop3 p 8 | \
        dmsetup create cow

]# losetup /dev/loop3
/dev/loop3: [0901]:55091517 (/snapshot.bin)

/snapshot.bin is a sparse file with 2000G seeked size.
I have 3.6GB free space in / so the out of space is not an option. :-)

I think this is correct. :-)
But anyway, i have pre-tested it with fdisk and works.

>
> We might ask to the DM people why it's not working maybe. Anyway there is 
> one good news, and it's that the read error apparently does travel through 
> the DM stack.

For me, this looks like md's bug not dm's problem.
The "uncorrectable read error" means exactly the drive can't correct the 
damaged sector with ECC, and this is an unreadable sector. (pending in smart 
table)
The auto read reallocation failed not meas the sector is not re-allocatable 
by rewriting it!
The most of the drives doesn't do read-reallocation only write-reallocation.

These drives wich does read reallocation, does it because the sector was 
hard to re-calculate (maybe needed more rotation, more repositioning, too 
much time) and moved automatically, BUT those sectors ARE NOT reported to 
the pc as read-error (UNC), so must NOT appear in the log...

I am glad if i can help to fix this but, but please keep this in mind, this 
raid array is a productive system, and my customer gets more and more 
nervous day by day...
I need a good solution for fixing this array to safely replace the bad 
drives without any data lost!

Somebody have any good idea wich is not copy the entire (15TB) array?

Thanks a lot,
Janos Haat

>
> Thanks for your work
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 

