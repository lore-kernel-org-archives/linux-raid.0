From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: slow mdadm reshape, normal?
Date: Thu, 11 Jun 2009 21:50:35 +0100
Message-ID: <4A316E1B.9060607@anonymous.org.uk>
References: <4A303C06.9080409@anonymous.org.uk> <20090610233659.GD30825@rlogin.dk> <20090611081909.GA16250@cthulhu.home.robinhill.me.uk> <20090611160741.GG30825@rlogin.dk> <20090611194552.GQ30825@rlogin.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090611194552.GQ30825@rlogin.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/06/2009 20:45, Michael Ole Olsen wrote:
[...]
> it seems there is 21ms wait time for each request due to this pci slowness. (await is in miliseconds)
> 
> might be the controller that isnt so fast to do simultaneous read and writes, 
> perhaps because its NCQ support might be bad?
> 
> so I don't really have more ideas, except to buy a new controller card from a better brand (Adaptec) :(

I have no personal experience of SIL SATA cards, but they've been 
mentioned before as being behind slowness. It's also possible something 
else on your PCI bus is choking things, so before you go and blow lots 
of real money on a better brand, what else is on your PCI bus? Please 
tell me the output of `lspci -tv` and the contents of /proc/interrupts 
twice (before and after a short delay, e.g. `cat /proc/interrupts ; 
sleep 5 ; cat /proc/interrupts`).

Cheers,

John.

