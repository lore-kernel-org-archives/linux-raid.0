From: George Rapp <george.rapp@gmail.com>
Subject: Re: Fedora 20 RAID 6 errors on rebuild / check / repair
Date: Thu, 24 Jul 2014 15:22:06 -0400
Message-ID: <CAF-KpgZSfQmSML0em6RuAfXOT0f==cNqFbtsTc05Axxjfw4Pmg@mail.gmail.com>
References: <CAF-KpgZ+8pPp62CN5p4rkwSk0nSv_JdkXGLnUWMaDEj2MmVcGg@mail.gmail.com>
 <53D0B6C1.7030908@uni-konstanz.de> <BLU436-SMTP705A7998D9280DFFC19D5698FF0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU436-SMTP705A7998D9280DFFC19D5698FF0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: "Wilson, Jonathan" <piercing_male@hotmail.com>
Cc: Kay Diederichs <kay.diederichs@uni-konstanz.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jul 24, 2014 at 5:45 AM, Wilson, Jonathan
<piercing_male@hotmail.com> wrote:
> On Thu, 2014-07-24 at 09:33 +0200, Kay Diederichs wrote:
>> On 07/24/2014 04:29 AM, George Rapp wrote:
>> > [snip]
>> >
>> >> Jul 22 21:23:37 backend3 kernel: [95876.375990] ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
>> >> Jul 22 21:23:37 backend3 kernel: [95876.376153] ata5.00: failed command: READ DMA
>> >> Jul 22 21:23:37 backend3 kernel: [95876.376284] ata5.00: cmd c8/00:08:40:11:81/00:00:00:00:00/e3 tag 11 dma 4096 in
>> >> Jul 22 21:23:37 backend3 kernel: [95876.376284]          res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask 0x4 (timeout)
>> >> Jul 22 21:23:37 backend3 kernel: [95876.376750] ata5.00: status: { DRDY }
>> >> Jul 22 21:23:37 backend3 kernel: [95876.376874] ata5: hard resetting link
>> >> Jul 22 21:23:37 backend3 kernel: ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
>> >> Jul 22 21:23:37 backend3 kernel: ata5.00: failed command: READ DMA
>> >> Jul 22 21:23:37 backend3 kernel: ata5.00: cmd c8/00:08:40:11:81/00:00:00:00:00/e3 tag 11 dma 4096 in
>> >>          res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask 0x4 (timeout)
>> >> Jul 22 21:23:37 backend3 kernel: ata5.00: status: { DRDY }
>> >> Jul 22 21:23:37 backend3 kernel: ata5: hard resetting link
>> >> Jul 22 21:23:40 backend3 kernel: [95878.742281] ata5.00: configured for UDMA/133
>> >> Jul 22 21:23:40 backend3 kernel: [95878.742413] ata5.00: device reported invalid CHS sector 0
>> >> Jul 22 21:23:40 backend3 kernel: [95878.742542] ata5: EH complete
>> >> Jul 22 21:23:40 backend3 kernel: ata5.00: configured for UDMA/133
>> >> Jul 22 21:23:40 backend3 kernel: ata5.00: device reported invalid CHS sector 0
>> >> Jul 22 21:23:40 backend3 kernel: ata5: EH complete
>> >
>
> The above tends to point to a hardware problem with any of the
> following.. disk, cable, controller.
>
> My own experience of such messages, they where always caused by
> connection problems in the cables with one being "broken" in a similar
> way to how a pair of head phones cut out until the cable is "wobbled"
> near the jack plug.
>
> Basically a broken wire in the sata cable that works "most of the time"
> but under load fails. It was very badly "kinked" near the plug due to
> bad case design not allowing much room between the side panel and the
> back of the drive and over time and multiple side panel removals moving
> the cable to different drives had degraded the integrity.

Jonathan -

Thanks for your reply. I am planning on moving this system to another
case that (1) is larger and (2) has some better ability to attenuate
vibrations. I might also replace my cables.

> The second time I had the above was caused by a loose socket on an add
> in card (really cheap one), the vibrations from the washing machine spin
> dry sequence would cause it to error if under high load (working out
> that two unrelated events had to occur at the same time took a while,
> especially as the drive in the second sata socket never had any issues);
> it was eventually resolved by using a small piece of selotape which
> lifted one side of the cable connector causing a tighter fit on the
> contact side... a true "bodge-it and scarper" fix that would make an
> engineer proud ;-)

The last three tools used on this server have been epoxy, a pop rivet
gun, and a sheet metal bending bar. I understand your solution (what
we in the US would call "redneck engineering") perfectly... 8^)

Thanks again.
-- 
George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
Work: george.rapp -- at -- hp.com (or) george.rapp.ctr -- at -- dfas.mil

A wise and frugal government, which shall restrain men from injuring
one another, which shall leave them otherwise free to regulate their
own pursuits of industry and improvement, and shall not take from the
mouth of labor the bread it has earned. This is the sum of
good government... - Thomas Jefferson, First Inaugural Address
