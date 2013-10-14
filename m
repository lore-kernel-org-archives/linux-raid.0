From: Brian Candler <b.candler@pobox.com>
Subject: Re: Problem diagnosing rebuilding raid5 array
Date: Mon, 14 Oct 2013 18:28:45 +0100
Message-ID: <525C29CD.4080604@pobox.com>
References: <20131014123104.77620e8uy2pe0214@phobos.elinuxservers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131014123104.77620e8uy2pe0214@phobos.elinuxservers.com>
Sender: linux-raid-owner@vger.kernel.org
To: peter@steinhoff.se, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/10/2013 17:31, peter@steinhoff.se wrote:
>
> I found that the CPU fan had stopped working and replaced it. The case 
> have several fans and the heatsink seemed cool even without the fan 
> (it's an i3-530 that does nothing more than samba so it's mostly 
> idle). Possibly the hardrives has been running hotter than normal for 
> a while though.
>
Aside: in some cases it might be a good idea to disable the case control 
- in the BIOS if your system supports it, or by removing the fan control 
header completely.

This was a system with 24 drives and 3 LSI HBAs. The case fan control 
was based on the CPU temperature alone. Therefore if the CPU was idle, 
the fan speed went very low, which meant that the drives and the HBAs 
got very hot.

This led to the perverse situation that when I was testing the system 
heavily with lots of reads and writes it went for weeks without 
problems, but if I left it idle for a day or two the HBAs crashed!

Regards,

Brian.

