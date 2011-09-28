From: David Brown <david@westcontrol.com>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Wed, 28 Sep 2011 09:51:25 +0200
Message-ID: <j5ujma$k50$1@dough.gmane.org>
References: <4E7EDE58.3000804@yazzy.org> <20110926074002.6399de56@notabene.brown> <4E7FA3E8.5010603@yazzy.org> <20110926081853.2819622b@notabene.brown> <4E804062.3020700@yazzy.org> <20110926193130.6377f5b9@notabene.brown> <4E82203A.60507@yazzy.org> <20110928091335.1df35f8e@notabene.brown> <4E828B92.40502@hardwarefreak.com> <4E82C862.8000705@yazzy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E82C862.8000705@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28/09/2011 09:10, Marcin M. Jessa wrote:
> On 9/28/11 4:50 AM, Stan Hoeppner wrote:
>
>> Reading the thread, and the many like it over the past months/years, may
>> yield a clue as to why you wish to move on to something other than Linux
>> RAID...
>
> :) I will give it another chance.
> In case of failure FreeBSD and ZFS would be another option.
>
>

Don't forget that in the face of 3 disk drives that suddenly decide to 
play silly buggers, /no/ raid system will cope well.  You are not having 
a problem because of Linux software raid problems - your problem is due 
to bad hardware.  If you had a similar situation with a hardware raid 
system, it is quite unlikely that you would have had any chance of 
recovering your raid.  What spoiled your chances of recovery here is the 
unfortunate bad advice you found on a website - but that won't happen 
again, since you now know to post here before trying anything!

The key lesson to take away from this experience is to set up a backup 
solution /before/ disaster strikes :-)


