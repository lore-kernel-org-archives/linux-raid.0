From: Farkas Levente <lfarkas@bnap.hu>
Subject: Re: 3ware 7500-8 controller, hardware or software raid, kernel crash
Date: Mon, 05 May 2003 13:22:48 +0200
Sender: ataraid-list-admin@redhat.com
Message-ID: <3EB64988.8000809@bnap.hu>
References: <Pine.LNX.4.44.0305042218040.19228-100000@aka.coware.de>
Reply-To: ataraid-list@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <ataraid-list-admin@redhat.com>
In-Reply-To: <Pine.LNX.4.44.0305042218040.19228-100000@aka.coware.de>
Errors-To: ataraid-list-admin@redhat.com
List-Help: <mailto:ataraid-list-request@redhat.com?subject=help>
List-Post: <mailto:ataraid-list@redhat.com>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=subscribe>
List-Unsubscribe: <https://listman.redhat.com/mailman/listinfo/ataraid-list>,
	<mailto:ataraid-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/pipermail/ataraid-list/>
To: Andreas Kahnt <aka@aka.coware.de>
Cc: linux-raid@vger.kernel.org, ataraid-list@redhat.com, Adam Radford <aradford@3WARE.com>
List-Id: linux-raid.ids

Andreas Kahnt wrote:
> Hi,
> 
> 
>>after we format it, start to copy back the data (about 250GB) from nfs.
>>after about 2 minutes the kernel crash with some kind of io error on the
>>3ware controller. unfortunately we don't have time to write down the
>>kernel's error message since this is one of our production enviroment
>>server. what's more I wouldn't like to buy more such card to play with if
>>it's not  well functional. you can read the kernel log after that crash at
>>the end of this mail.
> 
> 
> We had the same problem using SuSE-8.0/2.4.18. We 'solved' the problem using
> 6+1 - Raid-5 and removed the 8. disk. Now the last disk is a cold spare ;-).
> This work well for a couple of months uptime.

are you kidding? hmm:-((
this is the truth??? I'm getting said:-(
do the 3ware are aware of this?
we'd like to buy more such cards, but we've a few server in which 7+1 is 
required....
or it's better if I use software raid and in that case the above problem 
doesn't occure what's more I've got better performance?

-- 
   Levente                               "Si vis pacem para bellum!"
