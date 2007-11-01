From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Implementing low level timeouts within MD
Date: Thu, 01 Nov 2007 10:19:41 -0400
Message-ID: <4729E07D.3080000@tmr.com>
References: <1193418753.4771.17.camel@w100>	 <1193425254.10336.290.camel@firewall.xsintricity.com>	 <1193521561.7690.14.camel@w100>	 <1193529329.10336.366.camel@firewall.xsintricity.com>	 <1193552822.6541.8.camel@w100>	 <1193678521.10336.486.camel@firewall.xsintricity.com> <1193720887.3876.8.camel@w100>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193720887.3876.8.camel@w100>
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Alonso <alberto@ggsys.net>
Cc: Doug Ledford <dledford@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alberto Alonso wrote:
> On Mon, 2007-10-29 at 13:22 -0400, Doug Ledford wrote:
>
>   
>> What kernels were these under?
>>     
>
>
> Yes, these 3 were all SATA. The kernels (in the same order as above) 
> are:
>
> * 2.4.21-4.ELsmp #1 (Basically RHEL v3)
> * 2.6.18-4-686 #1 SMP on a Fedora Core release 2
> * 2.6.17.13 (compiled from vanilla sources)
>   

*Old* kernels. If you are going to build your own kernel, get a new one!
> The RocketRAID was configured for all drives as legacy/normal and
> software RAID5 across all drives. I wasn't using hardware raid on
> the last described system when it crashed.
>   
-- 

bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

