From: peter@steinhoff.se
Subject: Re: Problem diagnosing rebuilding raid5 array
Date: Tue, 15 Oct 2013 08:40:37 -0400
Message-ID: <20131015084037.10297bo5940ryklk@phobos.elinuxservers.com>
References: <20131014123104.77620e8uy2pe0214@phobos.elinuxservers.com>
 <525C29CD.4080604@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <525C29CD.4080604@pobox.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Brian Candler <b.candler@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks Brian, that's a good point.

In this case the case fans are running constant speed and only the cpu  
fan is PWM controlled. So the temperature over the drives should have  
been more or less OK.

Unfortunately the BIOS on this Intel motherboard didn't show fan speed  
or temperatures as it probably should so there was no alarms going off.

On another note, I took the failed drive I replaced in my array  
(/dev/sdh) and put it in another machine (win7) and run Western  
Digital's diagnosis software and it says the drive is OK.

I'm wondering if perhaps it's possible the CPU has been running too  
hot and the raid array failed because of that.

Anyway, I'm still at loss what to do and what my next step should be...

Thanks,
Peter



Quoting Brian Candler <b.candler@pobox.com>:

> On 14/10/2013 17:31, peter@steinhoff.se wrote:
>>
>> I found that the CPU fan had stopped working and replaced it. The  
>> case have several fans and the heatsink seemed cool even without  
>> the fan (it's an i3-530 that does nothing more than samba so it's  
>> mostly idle). Possibly the hardrives has been running hotter than  
>> normal for a while though.
>>
> Aside: in some cases it might be a good idea to disable the case  
> control - in the BIOS if your system supports it, or by removing the  
> fan control header completely.
>
> This was a system with 24 drives and 3 LSI HBAs. The case fan  
> control was based on the CPU temperature alone. Therefore if the CPU  
> was idle, the fan speed went very low, which meant that the drives  
> and the HBAs got very hot.
>
> This led to the perverse situation that when I was testing the  
> system heavily with lots of reads and writes it went for weeks  
> without problems, but if I left it idle for a day or two the HBAs  
> crashed!
>
> Regards,
>
> Brian.
>
>



