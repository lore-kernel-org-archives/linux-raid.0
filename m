From: David Greaves <david@dgreaves.com>
Subject: Re: Looking for the cause of poor I/O performance
Date: Wed, 08 Dec 2004 09:24:22 +0000
Message-ID: <41B6C846.7000702@dgreaves.com>
References: <200412062302.iB6N2g905058@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200412062302.iB6N2g905058@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Steven Ihde' <x-linux-raid@hamachi.dyndns.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My understanding of 'readahead' is that when an application asks for 312 
bytes of data, the buffering code will anticipate more data is required 
and will fill a buffer (4096 bytes). If we know that apps are really 
greedy and read *loads* of data then we set a large readahead which will 
cause the buffer code (?) to fill a further n buffers/kb according to 
the readahead setting. This will all be read sequentially and the 
performance boost is because the read heads on the drive get all the 
data in one 'hit' - no unneeded seeks, no rotational latency.

That's not the same as raid5 where when asked for 312 bytes of data, the 
buffering code wil fill the 4k buffer and then will issue a readahead on 
the next n kb of data - which is spread over multiple disks, which read 
in parallel, not sequentially.

Yes, the readahead triggers this behaviour - but you say "RAID5 can't do 
read balancing." - which I thought it could through this mechanism.

It depends whether the original use of "read balancing" in this context 
means "selecting a drive to obtain the data from according to the 
drive's read queue" (no) or "distributing reads amongst the drives to 
obtain a throughput greater than that of one individual drive" (yes)
(OK, the terminology is not quite exact but...)

do we agree? Or have I misunderstood something?

David

Guy wrote:

>Yes.  I did say it reads ahead!
>
>Guy
>
>-----Original Message-----
>From: linux-raid-owner@vger.kernel.org
>[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of David Greaves
>Sent: Monday, December 06, 2004 4:10 PM
>To: Guy
>Cc: 'Steven Ihde'; linux-raid@vger.kernel.org
>Subject: Re: Looking for the cause of poor I/O performance
>
>but aren't the next 'n' blocks of data on (about) n drives that can be 
>read concurrently (if the read is big enough)
>
>Guy wrote:
>
>  
>
>>RAID5 can't do read balancing.  Any 1 piece of data is only on 1 drive.
>>However, RAID5 does do read ahead, my speed is about 3.5 times as fast as a
>>single disk.  A single disk: 18 M/sec, my RAID5 array, 65 M/sec.
>>
>>Guy
>>
>>-----Original Message-----
>>From: linux-raid-owner@vger.kernel.org
>>[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Steven Ihde
>>Sent: Monday, December 06, 2004 12:49 PM
>>To: linux-raid@vger.kernel.org
>>Subject: Re: Looking for the cause of poor I/O performance
>>
>>On Sat, 04 Dec 2004 17:00:08 -0800, Steven Ihde wrote:
>>[snip]
>> 
>>
>>    
>>
>>>A possible clue is that when tested individually but in parallel, hda
>>>and hdc both halve their bandwidth:
>>>
>>>/dev/hda:
>>>Timing cached reads:   1552 MB in  2.00 seconds = 774.57 MB/sec
>>>Timing buffered disk reads:   68 MB in  3.07 seconds =  22.15 MB/sec
>>>/dev/hdc:
>>>Timing cached reads:   784 MB in  2.00 seconds = 391.86 MB/sec
>>>Timing buffered disk reads:   68 MB in  3.02 seconds =  22.54 MB/sec
>>>/dev/sda:
>>>Timing cached reads:   836 MB in  2.00 seconds = 417.65 MB/sec
>>>Timing buffered disk reads:  120 MB in  3.00 seconds =  39.94 MB/sec
>>>
>>>Could there be contention for some shared resource in the on-board
>>>PATA chipset between hda and hdc?  Would moving one of them to a
>>>separate IDE controller on a PCI card help?
>>>
>>>Am I unreasonable to think that I should be getting better than 37
>>>MB/sec on raid5 read performance, given that each disk alone seems
>>>capable of 40 MB/sec?
>>>   
>>>
>>>      
>>>
>>To answer my own question... I moved one of the PATA drives to a PCI
>>PATA controller.  This did enable me to move 40MB/sec simultaneously
>>    
>>
>>from all three drives.  Guess there's some issue with the built-in
>  
>
>>PATA on the ICH5R southbridge.
>>
>>However, this didn't help raid5 performance -- it was still about
>>35-39MB/sec.  I also have a raid1 array on the same physical disks,
>>and observed the same thing there (same read performance as a single
>>disk with hdparm -tT, about 40 MB/sec).  So:
>>
>>2.6.8 includes the raid1 read balancing fix which was mentioned
>>previously on this list -- should this show up as substantially better
>>hdparm -tT numbers for raid1 or is it more complicated than that?
>>
>>Does raid5 do read-balancing at all or am I just fantasizing?
>>
>>Thanks,
>>
>>Steve
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> 
>>
>>    
>>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>

