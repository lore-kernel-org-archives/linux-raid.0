From: Steven Dake <sdake@mvista.com>
Subject: Re: autodetect RAID
Date: Fri, 13 Dec 2002 08:56:18 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DFA0322.8060206@mvista.com>
References: <Pine.LNX.4.21.0212122229250.19885-100000@karl.cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Anuradha Vaidyanathan <vaidyana@cs.wisc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Anuradha,

Autodetect works in all kernel revs (atleast 2.4 and 2.5 kernel revs).

Just use fdisk to set the partition type to 0xfd (raid autostart) and 
the RAID partitions will be autostarted on boot.

Anuradha Vaidyanathan wrote:

>hello, where can one obtain the patch for autodetecting and which versions
>of the kernel does this work on??
>
>thanks
>-a
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>  
>

