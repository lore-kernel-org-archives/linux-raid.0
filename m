From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Implementing low level timeouts within MD
Date: Thu, 01 Nov 2007 10:14:04 -0400
Message-ID: <4729DF2C.4020309@tmr.com>
References: <1193418753.4771.17.camel@w100>	 <1193425254.10336.290.camel@firewall.xsintricity.com>	 <87tzoc7soa.fsf@willow.rfc1149.net>  <1193721577.3876.12.camel@w100>	 <1193765984.10336.519.camel@firewall.xsintricity.com> <1193893689.3649.19.camel@w100>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193893689.3649.19.camel@w100>
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Alonso <alberto@ggsys.net>
Cc: Doug Ledford <dledford@redhat.com>, Samuel Tardieu <sam@rfc1149.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Alberto Alonso wrote:
> On Tue, 2007-10-30 at 13:39 -0400, Doug Ledford wrote:
>   
>> Really, you've only been bitten by three so far.  Serverworks PATA
>> (which I tend to agree with the other person, I would probably chock
>>     
>
> 3 types of bugs is too many, it basically affected all my customers
> with  multi-terabyte arrays. Heck, we can also oversimplify things and 
> say that it is really just one type and define everything as kernel type
> problems (or as some other kernel used to say... general protection
> error).
>
> I am sorry for not having hundreds of RAID servers from which to draw
> statistical analysis. As I have clearly stated in the past I am trying
> to come up with a list of known combinations that work. I think my
> data points are worth something to some people, specially those 
> considering SATA drives and software RAID for their file servers. If
> you don't consider them important for you that's fine, but please don't
> belittle them just because they don't match your needs.
>
>   
>> this up to Serverworks, not PATA), USB storage, and SATA (the SATA stack
>> is arranged similar to the SCSI stack with a core library that all the
>> drivers use, and then hardware dependent driver modules...I suspect that
>> since you got bit on three different hardware versions that you were in
>> fact hitting a core library bug, but that's just a suspicion and I could
>> well be wrong).  What you haven't tried is any of the SCSI/SAS/FC stuff,
>> and generally that's what I've always used and had good things to say
>> about.  I've only used SATA for my home systems or workstations, not any
>> production servers.
>>     
>
> The USB array was never meant to be a full production system, just to 
> buy some time until the budget was allocated to buy a real array. Having
> said that, the raid code is written to withstand the USB disks getting
> disconnected as far as the driver reports it properly. Since it doesn't,
> I consider it another case that shows when not to use software RAID
> thinking that it will work.
>
> As for SCSI I think it is a greatly proved and reliable technology, I've
> dealt with it extensively and have always had great results. I know deal
> with it mostly on non Linux based systems. But I don't think it is
> affordable to most SMBs that need multi-terabyte arrays.
>   
Actually, SCSI can fail as well. Until recently I was running servers 
with multi-TB arrays, and regularly, several times a year, a drive would 
fail and glitch the SCSI bus such that the next i/o to another drive 
would fail. And I've had SATA drives fail cleanly on small machines, so 
neither is an "always" config.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

