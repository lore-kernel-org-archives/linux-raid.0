From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Software RAID when it works and when it doesn't
Date: Sat, 27 Oct 2007 11:26:01 -0400
Message-ID: <47235889.4030406@tmr.com>
References: <14526.1192571833@mdt.ecitele.com>	 <87bqaw5tqb.fsf@informatik.uni-tuebingen.de>	 <1192777672.16416.495.camel@w100> <471E79A5.5020607@tmr.com>	 <1193205003.23414.72.camel@w100> <471FA543.9090502@tmr.com>	 <87fxzxzwga.fsf@informatik.uni-tuebingen.de> <1193418553.4771.13.camel@w100>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193418553.4771.13.camel@w100>
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Alonso <alberto@ggsys.net>
Cc: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>, Mike Accetta <maccetta@laurelnetworks.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alberto Alonso wrote:
> On Fri, 2007-10-26 at 18:12 +0200, Goswin von Brederlow wrote:
>
>   
>> Depending on the hardware you can still access a different disk while
>> another one is reseting. But since there is no timeout in md it won't
>> try to use any other disk while one is stuck.
>>
>> That is exactly what I miss.
>>
>> MfG
>>         Goswin
>> -
>>     
>
> That is exactly what I've been talking about. Can md implement
> timeouts and not just leave it to the drivers?
>
> I can't believe it but last night another array hit the dust when
> 1 of the 12 drives went bad. This year is just a nightmare for
> me. It brought all the network down until I was able to mark it
> failed and reboot to remove it from the array.
>   

I'm not sure what kind of drives and drivers you use, but I certainly 
have drives go bad and they get marked as failed. Both on old PATA 
drives and newer SATA. All the SCSI I currently use is on IBM hardware 
RAID (ServeRAID), so I can only assume that failure would be noted.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

