From: David Greaves <david@dgreaves.com>
Subject: Re: RAID5 question.
Date: Thu, 04 Aug 2005 15:56:15 +0100
Message-ID: <42F22C8F.4000407@dgreaves.com>
References: <17137.43778.476908.961140@cse.unsw.edu.au>	 <01f001c598fd$c59a51a0$0400a8c0@LocalHost> <1123164866.8854.0.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1123164866.8854.0.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Raz Ben Jehuda <razb@bitband.com>
Cc: djani22@dynamicweb.hu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

And notice you can apply different readahead to:
The raw devices (/dev/sda)
The md device (/dev/mdX)
Any lvm device (/dev/lvm_name/lvm_device)

David

Raz Ben Jehuda wrote:

>read the blockdev man page
>
>On Thu, 2005-08-04 at 16:06 +0200, djani22@dynamicweb.hu wrote:
>  
>
>>Hi list, Neil!
>>
>>I have a little question because I'v got some performance problem...
>>Is the RAID5 do any type of headahead with the default config?
>>It is possible to disable the readahead? (if it is.)
>>Or just the io_sched do that on the disks?
>>
>>How can I disable the whole headahead on top of the RAID5 array?
>>
>>The RAID5 can do multiple small (<4kb) reads of disks for the multithreaded
>>read requests?
>>(chunk size is 32k)
>>
>>Thanks for helping!
>>
>>Janos
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>    
>>


-- 

