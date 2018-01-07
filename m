From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Adding a USB device to a SATA-only array
Date: Sun, 7 Jan 2018 12:10:15 +0000
Message-ID: <5A520E27.90808@youngman.org.uk>
References: <CADJ56BScVkAwUVkenQL+e5AeXskjWjB35gdfzTqks5-anLpesg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADJ56BScVkAwUVkenQL+e5AeXskjWjB35gdfzTqks5-anLpesg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kevin Lyda <kevin@ie.suberic.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/01/18 10:58, Kevin Lyda wrote:
> This scenario sounds great, but last I knew mixing SATA and USB
> connected disks would lead to data corruption. But I last looked
> around 2010 or so. Is this still true? If not, what version of the
> kernel / mdadm tools did it get fixed in. I skimmed the changelogs and
> commits and didn't see any mentions that it had been.

Speaking off the top of my head, I got the impression that the problem
actually lies in the USB protocol. In other words it can't be fixed :-(

If you're going to have a hot spare plugged in anyway (do you have room
in the server for the spare disk?), I'd get some way of using (e)SATA.
If you don't have enough SATA on the motherboard, can you plug in an
expansion card? A one-or-two disk JBOD chassis isn't that expensive,
especially for the kit it sounds like you have.

Then you can configure one spare drive as a group spare (others will
need to tell you how). That way, EVERYTHING will fail-over
automatically, and then you just have to physically swap the drives and
reboot.

That's the route I'd choose.

Cheers,
Wol
