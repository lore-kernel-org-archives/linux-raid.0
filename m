From: David Greaves <david@dgreaves.com>
Subject: Re: Looking for the cause of poor I/O performance
Date: Mon, 06 Dec 2004 21:10:11 +0000
Message-ID: <41B4CAB3.9060302@dgreaves.com>
References: <200412061929.iB6JTj904159@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200412061929.iB6JTj904159@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: 'Steven Ihde' <x-linux-raid@hamachi.dyndns.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

but aren't the next 'n' blocks of data on (about) n drives that can be 
read concurrently (if the read is big enough)

Guy wrote:

>RAID5 can't do read balancing.  Any 1 piece of data is only on 1 drive.
>However, RAID5 does do read ahead, my speed is about 3.5 times as fast as a
>single disk.  A single disk: 18 M/sec, my RAID5 array, 65 M/sec.
>
>Guy
>
>-----Original Message-----
>From: linux-raid-owner@vger.kernel.org
>[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Steven Ihde
>Sent: Monday, December 06, 2004 12:49 PM
>To: linux-raid@vger.kernel.org
>Subject: Re: Looking for the cause of poor I/O performance
>
>On Sat, 04 Dec 2004 17:00:08 -0800, Steven Ihde wrote:
>[snip]
>  
>
>>A possible clue is that when tested individually but in parallel, hda
>>and hdc both halve their bandwidth:
>>
>>/dev/hda:
>> Timing cached reads:   1552 MB in  2.00 seconds = 774.57 MB/sec
>> Timing buffered disk reads:   68 MB in  3.07 seconds =  22.15 MB/sec
>>/dev/hdc:
>> Timing cached reads:   784 MB in  2.00 seconds = 391.86 MB/sec
>> Timing buffered disk reads:   68 MB in  3.02 seconds =  22.54 MB/sec
>>/dev/sda:
>> Timing cached reads:   836 MB in  2.00 seconds = 417.65 MB/sec
>> Timing buffered disk reads:  120 MB in  3.00 seconds =  39.94 MB/sec
>>
>>Could there be contention for some shared resource in the on-board
>>PATA chipset between hda and hdc?  Would moving one of them to a
>>separate IDE controller on a PCI card help?
>>
>>Am I unreasonable to think that I should be getting better than 37
>>MB/sec on raid5 read performance, given that each disk alone seems
>>capable of 40 MB/sec?
>>    
>>
>
>To answer my own question... I moved one of the PATA drives to a PCI
>PATA controller.  This did enable me to move 40MB/sec simultaneously
>from all three drives.  Guess there's some issue with the built-in
>PATA on the ICH5R southbridge.
>
>However, this didn't help raid5 performance -- it was still about
>35-39MB/sec.  I also have a raid1 array on the same physical disks,
>and observed the same thing there (same read performance as a single
>disk with hdparm -tT, about 40 MB/sec).  So:
>
>2.6.8 includes the raid1 read balancing fix which was mentioned
>previously on this list -- should this show up as substantially better
>hdparm -tT numbers for raid1 or is it more complicated than that?
>
>Does raid5 do read-balancing at all or am I just fantasizing?
>
>Thanks,
>
>Steve
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

