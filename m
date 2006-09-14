From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID5 producing fake partition table on single drive
Date: Thu, 14 Sep 2006 18:42:04 -0400
Message-ID: <4509DABC.7040205@tmr.com>
References: <1155987607.7207.23.camel@localhost.localdomain>	 <17641.25141.373827.77279@cse.unsw.edu.au>	 <1156200453.19051.13.camel@fc6.xsintricity.com>  <44FC68A8.4010002@tmr.com> <1157867968.3920.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1157867968.3920.4.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Lem <l3mming@iinet.net.au>
Cc: Doug Ledford <dledford@redhat.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lem wrote:

>On Mon, 2006-09-04 at 13:55 -0400, Bill Davidsen wrote:
>
>  
>
>>May I belatedly say that this is sort-of a kernel issue, since 
>>/proc/partitions reflects invalid data? Perhaps a boot option like 
>>nopart=sda,sdb or similar would be in order?
>>    
>>
>
>Is this an argument to be passed to the kernel at boot time? It didn't
>work for me.
>

My suggestion was to Neil or other kernel maintainers. If they agree 
that this is worth fixing, the option could be added in the kernel. It 
isn't there now, I was soliciting responses on whether this was desirable.

Unfortunately I see no way to avoid data in the partition table 
location, which looks like a partition table, from being used.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

