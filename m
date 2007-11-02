From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Superblocks
Date: Fri, 02 Nov 2007 08:33:11 -0400
Message-ID: <472B1907.9040702@tmr.com>
References: <29a863790710260943o7623212esce30325be4610dea@mail.gmail.com>	<18214.45758.794247.651163@notabene.brown>	<29a863790710300906w497c0f35yb90c36dadbd2c5e7@mail.gmail.com> <18218.24911.715891.758629@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18218.24911.715891.758629@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Greg Cormier <gcormier@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday October 30, gcormier@gmail.com wrote:
>   
>> Which is the default type of superblock? 0.90 or 1.0?
>>     
>
> The default default is 0.90.
> However a local device can be set in mdadm.conf with e.g.
>    CREATE metdata=1.0
>
>   

If you change to 1.start, 1.ed, 1.4k names for clarity, they need to be 
accepted here, as well.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

