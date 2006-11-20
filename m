From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Raid 1 (non) performance
Date: Mon, 20 Nov 2006 14:29:04 -0500
Message-ID: <45620200.4010206@tmr.com>
References: <455B4609.6090905@kite.se> <Pine.LNX.4.64.0611191107590.15092@twinlark.arctic.org> <4561B7C3.7030000@kite.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4561B7C3.7030000@kite.se>
Sender: linux-raid-owner@vger.kernel.org
To: "Magnus Naeslund(k)" <mag@kite.se>
Cc: dean gaudet <dean@arctic.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Magnus Naeslund(k) wrote:
> dean gaudet wrote:
>   
>> i see you have split /var and / on the same spindle... if your /home is on 
>> / then you're causing extra seek action by having two active filesystems 
>> on the same spindles.  another option to consider is to make / small and 
>> mostly read-only and move /home to /var/home (and use a symlink or mount 
>> --bind to place it at /home).
>>
>>     
>
> Yes I have it like this now:
> 	/var/bind/home on /home type bind (rw,bind,noatime)
>
>   
>> hopefully your swap isn't being used much anyhow.
>>
>>     
>
> Zero used, infact.
>
>   
>> try "iostat -kx /dev/sd* 5" and see if the split is causing you troubles 
>> -- i/o activity on more than one partition at once.
>>
>>     
>
> It seems to be roughly the same numbers on the disks.
>
>   
>> turning off write caching is a recipe for disasterous performance on most 
>> ata disks... unfortunately.  better to buy a UPS and set up nut or apcupsd 
>> or something to handle shutdown.  or just take your chances.
>>
>>     
>
> This is a mail server, I would like it to not lose mail if there is an power outage.
> Is there anything one can do without buying more hardware?

Nothing you can do will prevent loss of mail locally if the power goes 
out when the mail has gotten to memory and not disk, or the metadata has 
not been updated on the disk. Unless you want to hack your SMTP 
interface to not return an "accepted" status until you have flushed 
everything, get a UPS.

Hint, I looked at this for an ISP internal mailer, and performance 
trying to flush is so bad it's only justified for a very low volume of 
mail. As in legal or financial stuff. If your mail is that critical you 
buy expensive hardware when justified. Otherwise spend a few hundred 
bucks on a good UPS and install the software.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

