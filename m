From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: very degraded RAID5, or increasing capacity by adding discs
Date: Tue, 23 Oct 2007 18:41:15 -0400
Message-ID: <471E788B.7000001@tmr.com>
References: <20071008211313.6cd8bbb5@absurd> <470AB496.5010406@msgid.tls.msk.ru> <18186.62585.7261.178442@notabene.brown> <470B4E82.6010102@msgid.tls.msk.ru> <20071022090300.GA22588@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071022090300.GA22588@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Louis-David Mitterrand wrote:
> On Tue, Oct 09, 2007 at 01:48:50PM +0400, Michael Tokarev wrote:
>   
>> There still is - at least for ext[23].  Even offline resizers
>> can't do resizes from any to any size, extfs developers recommend
>> to recreate filesystem anyway if size changes significantly.
>> I'm too lazy to find a reference now, it has been mentioned here
>> on linux-raid at least this year.  It's sorta like fat (yea, that
>> ms-dog filesystem) - when you resize it from, say, 501Mb to 999Mb,
>> everything is ok, but if you want to go from 501Mb to 1Gb+1, you
>> have to recreate almost all data structures because sizes of
>> all internal fields changes - and here it's much safer to just
>> re-create it from scratch than trying to modify it in place.
>> Sure it's much better for extfs, but the point is still the same.
>>     
>
> I'll just mention that I once resized a multi-Tera ext3 filesystem and 
> it took 8hours +, a comparable XFS online resize lasted all of 10 
> seconds! 

Because of the different way these file systems do things, there is no 
comparable resize, at least in terms of work to be done. For many 
systems R/W operations are more common than resize, so the F/S type is 
selected to optimize that. ;-)

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

