From: "Jeffrey V. Merkey" <jmerkey@wolfmountaingroup.com>
Subject: Re: [RFH] Partion table recovery
Date: Fri, 20 Jul 2007 00:47:32 -0600
Message-ID: <46A05A84.6050305@wolfmountaingroup.com>
References: <200707200813.03553.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200707200813.03553.a1426z@gawab.com>
Sender: linux-raid-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Al Boldi wrote:

>As always, a good friend of mine managed to scratch my partion table by 
>cat'ing /dev/full into /dev/sda.  I was able to push him out of the way, but 
>at least the first 100MB are gone.  I can probably live without the first 
>partion, but there are many partitions after that, which I hope should 
>easily be recoverable.
>
>I tried parted, but it's not working out for me.  Does anybody know of a 
>simple partition recovery tool, that would just scan the disk for lost 
>partions?
>
>
>Thanks!
>
>--
>Al
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
>
>  
>
One thing NetWare always did was to stamp a copy of the partition table 
at the time a partition was created as the second logical sector (offset 
1) from the start of a newly created partition. This allowed the disk to 
be scanned for the original (or last) partition table copy.

Jeff
