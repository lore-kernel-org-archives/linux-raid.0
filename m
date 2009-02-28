From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: System hangs on raid md recovery/resync - revisit
Date: Sat, 28 Feb 2009 12:02:20 +0100
Message-ID: <1235818940.3991.121.camel@belgarion.romunt.nl>
References: <da290bd50902271732m54a32ad6r5797f618f5af7d7@mail.gmail.com>
	 <alpine.DEB.2.00.0902280407520.17966@p34.internal.lan>
	 <da290bd50902280241y4102d5c3p73ce506b4195e5e9@mail.gmail.com>
Reply-To: Rudy@grumpydevil.homelinux.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <da290bd50902280241y4102d5c3p73ce506b4195e5e9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad <brad46526@gmail.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2009-02-28 at 20:41 +1000, Brad wrote:
> On Sat, Feb 28, 2009 at 7:08 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> >
> > On Sat, 28 Feb 2009, Brad wrote:
> >
> 
> But it still hangs if there's any significant network traffic.  Maybe,
> even though I've gotten rid of anything using the same IRQ as the
> Realtek - IDE or pata_jmicron - the NIC driver is still flubbing interrupts
> and that's confusing the kernel?
> 
I would not call the traffic you mention significant network traffic,
not for a gigabit card... 

> Thanks for the advice Justin.  Maybe the solution is to abandon use
> of the Realtek NIC (a pity to 'waste' what's freely available on the
> motherboard, though, in a way).

I do agree with the suggestion to use a different NIC. I have been
avoiding realtek based NIC since i learned that the realtek do not
adhere to the electrical parts of the ethernet spec, resulting in
inability to use long cable runs (i have seen that myself).

This was on the 100mbit versions. 

The good point of the realtek: they are cheap
bad point: potential troubles. 

> 
> 
> Brad
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Cheers,


Rudy

