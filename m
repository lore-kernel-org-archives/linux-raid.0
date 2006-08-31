From: Lem <l3mming@iinet.net.au>
Subject: Re: SATA ontrollers and Linux MD
Date: Thu, 31 Aug 2006 18:30:46 +1000
Message-ID: <1157013046.6570.8.camel@localhost.localdomain>
References: <20060831033111.55493.qmail@web50209.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060831033111.55493.qmail@web50209.mail.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex Davis <alex14641@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2006-08-30 at 20:31 -0700, Alex Davis wrote:
> I'm currently using a Promise Technologies TX4300 SATA II 3.0GB/s controller, to which are
> connected 4 Seagate Barracuda 7200.10 ST3320620AS 320GB drives. I've only had this setup for 
> 2 weeks but so far I'm happy with it. The controller is PCI and costs about $66. the drives 
> are about $100/each.

I too have this controller card. I was looking for a cheap SATA card
which had Linux support that I could use with software RAID. It seems to
work fine.

> Note: the cables that come with the controller come loose too easy. If you go this route,
> get some additional cables.
> 
> I have a RAID5 setup. While sync'ing, the throughput was about 30MB/sec.

I have a RAID5 setup also. 5x256GB Seagate SATA drives (some are the
newer NCQ ones, some are older ones). Only two are on the Promise card,
the other three are on the motherboard nVidia (nForce3 CK8S) and Silicon
Image (SiI 3512) controllers. Sync speed is about the same for me
(regardless of trying to change the minimum via /proc).

I have an Audigy 2 ZS on the same PCI bus as the Promise card, and when
I write to the RAID array, I get a lot of pops, clicks, glitches,
squeaks etc through the sound (only when I'm outputting audio to the
soundcard simultaneously). Reads don't produce the same thing, in fact
reads don't interfere with audio at all. Do you have a soundcard on your
PCI bus, and if so, have you experienced this?

