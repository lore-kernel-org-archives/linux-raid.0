From: Gustavo Franco <stratus@acm.org>
Subject: Re: Problems with RAID1 using SATA disks.
Date: Wed, 12 May 2004 20:51:23 -0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40A2B87B.7050306@acm.org>
References: <40A255D5.3090602@acm.org> <1084381339.26186.5.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1084381339.26186.5.camel@localhost>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Lange wrote:

>On Wed, 2004-05-12 at 11:50, Gustavo Franco wrote:
>  
>
>>linears, but i haven't assembled it yet, i'm having problems when i put
>>heavy i/o on the linear array cited before.
>>    
>>
>
>You don't say what the problems are. Can you provide more details?
>
>Is it ONLY on the linear array?
>  
>
Hi,

Sorry i've not clarified it on my post to linux-raid, only to 
lkml[0].I've seen two oops
and the kernel BUG (posted to lkml), and already comented here by 
Christoph, only
when i run the rsync clients against the rsync server running on this 
machine storing
files on a linear array. I can try to reproduce it again to post the 
oops (one using xfs
and the later with ext3) here, but i was hoping that someone have 
already hit that.

By the way...Christoph can you give more details about that patch? Was 
it merged
on some kernel already released, i haven't checked it. Isn't strange 
that a similar
problem can be seen using ext3? FYI, at the moment i'm running on a 
partition without
raid linear, only xfs and in two days i'll report if the heavy i/o load 
breaks it again or not.
It seems that i've reached more than one bug through this process.

 <http://marc.theaimsgroup.com/?l=linux-raid&m=108438093424360&w=2#-0>[0] = http://www.uwsg.iu.edu/hypermail/linux/kernel/0404.1/0706.html

Thanks again,
Gustavo Franco


