From: Phil Turmel <philip@turmel.org>
Subject: Re: Reconstruct a RAID 6 that has failed in a non typical manner
Date: Mon, 21 Dec 2015 07:20:43 -0500
Message-ID: <5677EE9B.7000607@turmel.org>
References: <1874721715.14008052.1446134381481.JavaMail.zimbra@inria.fr>
 <5633B79D.4000009@turmel.org>
 <1861199271.16131793.1446719750662.JavaMail.zimbra@inria.fr>
 <563B5AEB.5020006@turmel.org> <87vb7s4gfv.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87vb7s4gfv.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <nfbrown@novell.com>, Clement Parisot <clement.parisot@inria.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Neil,

On 12/20/2015 10:40 PM, NeilBrown wrote:
> On Fri, Nov 06 2015, Phil Turmel wrote:
>>
>> for x in /sys/block/*/device/timeout ; do echo 180 > $x ; done
>>
> 
> Would it make sense for mdadm to automagically do something like this?
> i.e. whenever it adds a device to an array (with redundancy) it write
> 180 (or something configurable) to the 'timeout' file if there is one?

Yes, I've been thinking this should be automagic, but I'm not sure if it
really belongs at the MD layer.

> Why do we pick 180?

I empirically determined that 120 was sufficient on the Seagate drives
that kicked my tail when I first figured this out.  Someone else (I'm
afraid I don't remember) found that to be not quite enough and suggested
180.

> Can this cause problems on some drives?

Not that I'm aware of, but it does make for rather troublesome
*application* stalls.

Considering that this aggressively long error recovery behavior is
*intended* for desktop drives or any non-redundant usage, I believe
linux shouldn't time out at 30 seconds by default.  It cuts off any
opportunity for these drives to report a good sector that is
reconstructed in more than 30 seconds.

Meanwhile, any device that *does* support scterc and/or has scterc
enabled out of the gate arguably should have a timeout just a few
seconds longer than the larger of the two error recovery settings.

I propose:

1) The kernel default timeout be set to 180 (or some number
cooperatively established with the drive manufacturers.)

2) the initial probe sequence that retrieves the drive's parameter pages
also pick up the SCT page and if ERC is enabled, adjust the timeout
downward.  I believe these capabilities should be reflected in sysfs for
use by udev.

3) mdadm should inspect member device ERC capabilities during creation
and assembly and enable it for drives that have it available but disabled.

In light of your maintainership notice, I will pursue this directly.

Phil
