From: Rob Becker <Rob.Becker@riverbed.com>
Subject: Re: Disappointing RAID10 Performance
Date: Fri, 16 Oct 2009 11:10:54 -0700
Message-ID: <B87EBE62-DE20-4BFC-9FBB-FFC8AD471331@riverbed.com>
References: <364346.70897.qm@web38808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <364346.70897.qm@web38808.mail.mud.yahoo.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

    Hi,

   What command did you use to create your raid-10?  You might try  
running iostat in parallel to see if the read_balancer is properly  
balancing the reads between the two disks.

   I've seen situations where raid-10 on sequential reads will pretty  
much always prefer the same disk and barely use the mirror.

   One thing we looked at was changing to the far layout, which helped  
a bit.

--Rob
On Oct 16, 2009, at 10:32 AM, adfas asd wrote:

> I was hoping to get better performance with RAID10 than from the raw  
> disks, but that's turned out to not be the case.  Experimenting with  
> the readahead buffer I get these bandwidths with the following  
> command:
> # time dd if={somelarge}.iso of=/dev/null bs={readahead size}
>
> /dev/sd?
> 1024 71.3 MB/s
> 2048 71.2 MB/s
> 4096 77.7 MB/s
> 8192 69.4 MB/s
> 16384 76.6 MB/s
>
> /dev/md2
> 1024  67.1
> 2048  69.1
> 4096  75.7
> 8192  64.9
> 16384 69.0
>
> Using RAID10offset2 on 2 WD 2TB drives, and always the same input  
> file.
>
> Why would RAID10 performance be -poorer-?
> If it weren't for mirroring, this wouldn't be worth it.
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

