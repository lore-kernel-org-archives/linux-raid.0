From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: RAID6 and crashes (reporting back re. --bitmap)
Date: Fri, 11 Jun 2010 16:26:01 -0400
Message-ID: <4C129BD9.1020304@meetinghouse.net>
References: <4C1128C2.4020105@meetinghouse.net> <20100611005743.43664e5b@natsu> <4C11578B.8010202@meetinghouse.net> <20100611034108.6a2cdbc4@natsu> <4C1169CB.1030903@meetinghouse.net> <20100611085112.5f33b06f@natsu> <4C11BFB7.7050907@meetinghouse.net> <20100611105521.67c9658c@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100611105521.67c9658c@natsu>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

FYI:  I just:
- removed the bitmap
- installed a new bitmap with larger chunk-size
on 4 arrays, on each of two machines (redundant high-availability 
cluster setup)

Took me all of about 5 minutes, of which most of the time was waiting 
for virtual machines to migrate from one machine to the other, and then 
back.

All seems to be working, performance seems just a little snappier - but 
who can really tell until the next time an array rebuilds.

Thanks all (and Roman in particular) for your guidance.

Miles

Roman Mamedov wrote:
> On Fri, 11 Jun 2010 00:46:47 -0400
> Miles Fidelman<mfidelman@meetinghouse.net>  wrote:
>
>    
>> Looks like my original --bitmap internal creation set a very large chunk
>> size initially
>>
>> md3 : active raid6 sda4[0] sdd4[3] sdc4[2] sdb4[1]
>>         947417088 blocks level 6, 64k chunk, algorithm 2 [4/4] [UUUU]
>>         bitmap: 6/226 pages [24KB], 1024KB chunk
>>
>> unless that --bitmap-chunk=131072 recommendation is translates to
>> 131072KB (if so, are you really running 131MB chunks?)
>>      
> Yes, this is correct.
> This will only mean that after an unclean shutdown, at least 128MB-sized
> areas of the array will be invalidated for a resync, and not smaller areas
> with 1MB-granularity like on yours currently. 128 megabytes is just about 1
> second of read throughput on modern drives, so I am okay with that. Several
> 128MB-windows here and there are still faster to resync than the whole array.
> And this had an extemely good effect on write performance for me (increased it
> by more than 1.5x) compared to a small chunk. Test for yourself, first without
> the bitmap, then with various chunk sizes of it (ensure there's no other load
> on the array, and note the speeds):
>
> dd if=/dev/zero of=/your-raid/zerofile bs=1M count=2048 conv=notrunc,fdatasync
>
>    


-- 
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


