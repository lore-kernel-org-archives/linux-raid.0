From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Raid 1, can't get the second disk added back in.
Date: Tue, 08 Jan 2008 16:02:15 -0500
Message-ID: <4783E4D7.50602@tmr.com>
References: <477FAAAC.2090107@fayettedigital.com>	<18305.22361.482483.331552@notabene.brown>	<47823B46.6010105@fayettedigital.com> <18306.44011.512618.609434@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18306.44011.512618.609434@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: jim@fayettedigital.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Monday January 7, jim@fayettedigital.com wrote:
>   
>> Problem is not raid, or at least not obviously raid related.  The 
>> problem is that the whole disk, /dev/hdb is unavailable. 
>>     
>
> Maybe check /sys/block/hdb/holders ?  lsof /dev/hdb ?
>
> good luck :-)
>
>   
losetup -a may help, lsof doesn't seem to show files used in loop 
mounts. Yes, long shot...

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


