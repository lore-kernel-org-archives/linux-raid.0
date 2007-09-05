From: Anton Voloshin <ashutosh@harekrishna.ru>
Subject: Re: RAID 6 reshape failed (false message about critical section)
Date: Wed, 5 Sep 2007 22:13:37 +0400
Message-ID: <62E93D27-4D05-45F7-BB60-144BA46DC913@harekrishna.ru>
References: <515CA0AD-2BAF-437A-8A41-260F7A27BADB@harekrishna.ru> <18142.41665.719883.549678@notabene.brown>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18142.41665.719883.549678@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Dear Neil,

> I can see what the problem is.  It will take a little while to figure
> out what the "correct" fix it, but a quick fix to get you out of
> trouble would be to remove the lines:
>
> 		if (info->array.utime > __le64_to_cpu(bsb.mtime) + 3600 ||
> 		    info->array.utime < __le64_to_cpu(bsb.mtime))
> 			continue; /* time stamp is too bad */

I've applied the patch that you suggested but I'm getting exactly the  
same result:

> root@videoserver:~/mdadm-2.6.3# ./mdadm --assemble /dev/md1
> mdadm: Failed to restore critical section for reshape, sorry.

Please advise me on any more information that I should provide or  
make any other suggestions/advices.

Best regards,
Anton Voloshin
Saint Petersburg, Russia
