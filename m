From: David Brown <david.brown@hesbynett.no>
Subject: Re: Direct disk access on IBM Server
Date: Thu, 21 Apr 2011 13:00:39 +0200
Message-ID: <iop2oo$vs4$1@dough.gmane.org>
References: <iok28i$tp6$1@dough.gmane.org>	<4DADEBC3.9060404@hardwarefreak.com>	<iomfkq$qqr$1@dough.gmane.org> <BANLkTint14TBOaBqaaXrUggeJWMPShWA8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTint14TBOaBqaaXrUggeJWMPShWA8A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/04/11 05:50, Ryan Wagoner wrote:
> On Wed, Apr 20, 2011 at 7:24 AM, David Brown<david@westcontrol.com>  wrote:
>> Pros for hardware raid:
>>
>> + It can have battery backup (I don't have one at the moment - I have an
>> excellent UPS for the whole system).
>> + Rebuilds will be handled automatically by just adding new disks
>> + The card supports online resizing and reshaping
>> + It looks like the card supports caching with an SSD
>> + The card supports snapshots of the virtual drives
>
> Unless the card allows you to enable the write cache without the
> backup battery you will not see the real performance of the card. This
> option is normally locked out to prevent data loss in case the system
> crashes, power is pulled, etc. An external UPS will not protect in all
> cases if you enable the write back cache without battery.
>

The write cache is allowed without the battery, but disabled by default.

I agree that even with an UPS there is still a risk - I guess that's why 
it is disabled.  But the risk is pretty minimal for me - there is no 
realistic chance of the power plug being pulled, for example.  Other 
risks do exist - the power supply on the server may fail, the UPS may 
fail, etc.  In the end there are /always/ risks - even with a battery on 
the raid card, it won't protect against everything.  All I can do is 
reduce the risks to a realistic minimum while keeping good performance 
and features (and sensible cost!), and make sure I've got good backups 
of everything.

> I have systems with both software raid and hardware raid. If the
> budget allows I tend to go the hardware raid route. When buying a
> Dell, HP, etc server with hardware raid you end up with a complete
> package. The enclosure, card, and server monitoring software make it
> easy to manage and visually see which drive has failed.
>
> Ryan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


