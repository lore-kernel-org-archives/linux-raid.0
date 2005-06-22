From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: from raidtools2 to mdadm
Date: Wed, 22 Jun 2005 14:48:20 -0400
Message-ID: <42B9B274.7050109@tmr.com>
References: <42B7A866.1080802@tequila.co.jp>	<17079.43900.652982.735401@cse.unsw.edu.au>	<42B7ACDA.1000605@tequila.co.jp> <17079.45804.485652.77989@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17079.45804.485652.77989@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Clemens Schwaighofer <cs@tequila.co.jp>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

>On Tuesday June 21, cs@tequila.co.jp wrote:
>  
>
>>On 06/21/2005 02:54 PM, Neil Brown wrote:
>>
>>    
>>
>>>>#> mdadm --detail --scan>> mdadm.conf
>>>>
>>>>is enought to get the raid started the next time I have to reboot
>>>>the box.
>>>>        
>>>>
>>>1/ remove the 'devices=' parts.  Then it should be ok, providing there
>>>   is a suitable DEVICES line at the top.
>>>      
>>>
>>yeah I have a devices line on the top. If I don't have, I will need the
>>devices lines I guess.
>>    
>>
>
>No..
>The 'devices=' bits by themselves aren't enough, and are rarely
>wanted.
>If a device isn't listed in the DEVICES lines, then it won't be
>considered for use in an array.
>
>The 'devices=' words are quite different.  They say "this is how you
>recognise a device that is in this array.  All the devices in it are
>on this list".
>This is reported by "mdadm --detail --scan" largely for interest.  It
>should rarely be included in mdadm.conf.  The very latest version ofn
>mdadm does not report them unless --verbose is given.
>

So is there no way to ask mdadm to take what's running and create a 
config to make it happen again? Telling people to cread the man pages 
for a utility they did not use by choice and create a config file which 
could result in losing their data if it's wrong is a deterent to an 
upgrade, I suspect.

It would be desirable to follow the example of iptables, to allow rules 
to be configured by hand (more or less) and then have a tool to create a 
config file from what's there. A human readable editable file at that.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

