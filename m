From: Vladimir Milovanovic <vlad@webmail.co.za>
Subject: Re: adding raid 1 to rh 7.1
Date: Wed, 30 Oct 2002 19:08:35 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DC01213.6080104@webmail.co.za>
References: <2678.204.250.25.205.1035990931.squirrel@webmail.bwkip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: danfisher@bwkip.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

That kernel should include RAID support, you should not need to 
recompile. Just set up the /etc/raidtab, then do mkraid /dev/md0 and you 
should be up and running. Read the Software RAID FAQ (www.tldp.org) and 
it should make it very clear how to proceed.

Cheers,
Vlad


danfisher@bwkip.com wrote:

>I have a system up and running with RedHat 7.1 and need to raid it.  I
>don't know how to recompile the kernel to add raid support for raid 1.
>I am using the latest kernel 2.4.9-34.  Any help is appreciated.
>
>-Dan
>
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>  
>



