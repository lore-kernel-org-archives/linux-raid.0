From: Farkas Levente <lfarkas@bppiac.hu>
Subject: Re: why the kernel and mdadm report differently
Date: Mon, 05 Sep 2005 13:49:55 +0200
Message-ID: <431C30E3.2040404@bppiac.hu>
References: <431C0968.10301@bppiac.hu> <17180.3031.193961.445535@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17180.3031.193961.445535@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Monday September 5, lfarkas@bppiac.hu wrote:
> 
>>hi,
>>one of our raid array is crash all the time (once a week), 
> 
> 
> Any kernel error messages?

i already send report about this a few times to this list without any 
response, but i send you a private message will all logs.

>>and one more 
>>stange thing that it's currently not working, kernel report inactive 
>>while mdadm said it's active, degraded. what's more we cant put this 
>>array into active state.
> 
> 
> Looks like you need to stop in (mdadm -S /dev/md2) and re-assemble it
> with --force:
>   mdadm -A /dev/md2 -f /dev/sd[abcefgh]1
> 
> It looks like the computer crashed and when it came back up it was
> missing a drive.  This situation can result in silent data corruption,
> which is why md won't automatically assemble it.  When you do assemble
> it, you should at least fsck the filesystem, and possibly check for
> data corruption if that is possible.  At least be aware that some data
> could be corrupt (there is a good chance that nothing is, but it is by
> no means certain).

it works. but shouldn't it have to be both inactive or active?


>>this is mdadm 1.12, just another site note there is no rpm for version 
>>2.0:-(
> 
> 
> No.  I seem to remember some odd compile issue with making the RPM
> and thinking "I don't care".   Maybe I should care a bit more....

would be useful.


-- 
   Levente                               "Si vis pacem para bellum!"

