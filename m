From: Vladimir Milovanovic <vlad@webmail.co.za>
Subject: Re: Tiobench results LOWER with more threads
Date: Fri, 18 Oct 2002 09:48:31 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DAFBCCF.1020000@webmail.co.za>
References: <3DABCFE7.9070701@webmail.co.za> <20021017215014.GA7875@unthought.net> <20021018023137.GC18294@peeps.cable.rcn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Gregory Leblanc <gleblanc@linuxweasel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Gregory Leblanc wrote:

>
>
>Interesting.  How fast are you getting single-threaded reads from a
>single disk?  And what are the real specs on the drives (RPM, cache,
>SCSI version support (SCSI 3 is a family, not a version)).
>
I am getting about 12 MB/s for sequential reads single threaded per 
disk. The disks are 18GB, 7200 rpm, ultra fast/wide scsi disks. I am 
really not sure about the cache.

So what is the consensus now? Let's just stick to RAID 0 - should I see 
more when going multithreaded or should I not be worried that the 
transfer rates are dropping off? Note that the rates drop off even if I 
am only running a 2 disk RAID  0 i.e. my bus is not being maxed out then.

Cheers, Vlad.


