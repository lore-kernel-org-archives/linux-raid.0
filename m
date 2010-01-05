From: Adam Megacz <adam@megacz.com>
Subject: Re: anybody using the gc-ramdisk?
Date: Tue, 05 Jan 2010 04:30:43 +0000
Message-ID: <xuu2vdfhmavg.fsf@nowhere.com>
References: <xuu2aawtfu4c.fsf@nowhere.com> <201001042124.56019.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Thomas Fjellstrom <tfjellstrom@shaw.ca> writes:
> If I had one I might use it as a fs-cache.

I'm not sure it offers any advantage over plain old system RAM in that
capacity; I'd be just as well off putting those DIMMs on the
motherboard.

I can't use plain old system RAM for a journal or a write-intent bitmap
because system RAM is wiped out in the event of a power failure.

  - a

