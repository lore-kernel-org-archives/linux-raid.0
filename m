From: "Ty! Boyack" <ty@nrel.colostate.edu>
Subject: Re: Is it possilble to be "delay tolerant" or have "slow dropout"
 of unavailable components?
Date: Tue, 08 Apr 2008 12:24:02 -0600
Message-ID: <47FBB842.2030902@nrel.colostate.edu>
References: <47FBA3BB.2030007@nrel.colostate.edu> <200804081948.41959.Markus@hochholdinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200804081948.41959.Markus@hochholdinger.net>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Hochholdinger <Markus@hochholdinger.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Markus Hochholdinger wrote:
> hi,
>
> Am Dienstag, 8. April 2008 18:56 schrieb Ty! Boyack:
>   
>> I'm curious if there is a way to have a raid set (raid5 in my case, but
>> this could apply to any raid level) that could tolerate a component
>> device being unavailable for a period of time.
>>     
>
> for RAID1 there is "--write-mostly" and "--write-behind=". Don't know if this 
> is already available for RAID5.
>
> There's also the option "--bitmap=" which can speedup a resync when 
> temporarily disconnecting one device.
>
>
>   

Thanks - I was looking at those options, but it seems that the 
'write-behind' option would need to be applied to ALL devices.  It seems 
to indicate a difference in the devices - one is fast, one is slow, and 
the slow one is indicated with write-behind.  In my case, I think all 
are fast except in the case of a failure, in which case I'd like to have 
some delay before it gets declared bad to see if it comes back.

As for the 'bitmap' option - I think this has a lot of potential, and 
might work IF there was an automatically re-add a failed device.  With 
the bitmap I see the following sequence taking place:

1) Device in a raid5 goes away for some reason (iscsi reboot, network 
glitch, etc.) but the component is really still good.
2) raid5 marks device as bad, starts tracking changes in bitmap
3) device comes back online
<right now this is as far as I can get it without manual intervention, 
but if there is some sort of auto re-add this sequence could continue 
unabated>
4) device is re-added to raid5
5) Resync occurs fast because of the bitmap.

So... Perhaps I'm asking for the wrong thing.  Is there a way to detect 
a recovery after a failure, and have it automatically repair the raid set?

Right now, without the automation, it is possible, and likely, that an 
operator cannot respond in time to avoid having the bitmap fill up, and 
then we are into a long resync.  More critically, we would be running 
with a degraded array from the point of failure until an operator can 
fix it and the resync finishes, which is frightening.

-Ty!


-- 
-===========================-
  Ty! Boyack
  NREL Unix Network Manager
  ty@nrel.colostate.edu
  (970) 491-1186
-===========================-

