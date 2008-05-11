From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: Multiple siI SATA cards and data corruption
Date: Sun, 11 May 2008 09:19:04 +0100
Message-ID: <18470.44024.458244.536905@tree.ty.sabi.co.uk>
References: <1f0f1a960805061741t16bb165fp342ceb8f97f4347d@mail.gmail.com>
	<e9c3a7c20805062212x73a837d7l37905042d835e0a7@mail.gmail.com>
	<1f0f1a960805070234o2f9dfe07j42a1bd005b607791@mail.gmail.com>
	<1af518580805070648r6060ca9ase0d03e9a17ffe0c7@mail.gmail.com>
	<1f0f1a960805070720y4908b17dqe098d969f03ec37d@mail.gmail.com>
	<4821C052.6090105@harddata.com>
	<1f0f1a960805070752k6ed9c4dfj8ff2382d4557b013@mail.gmail.com>
	<29a863790805080823m296004e7p4f047b608c4d3eb6@mail.gmail.com>
	<1f0f1a960805080836o655bc46i484c416bf3bb503@mail.gmail.com>
	<4823826A.90303@panix.com>
	<1f0f1a960805101811i77905c79wb66c0281e4f5fbb2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1f0f1a960805101811i77905c79wb66c0281e4f5fbb2@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... flakey hard drive subsystem ... ]

> [ ... ] I'm not too sure if the supposed bug I found with
> multiple Silicon Image controller cards actually exists or not

Well, a significant number of host adapters that I have used had
significant bugs or misdesigns. Not just low end ones.

For example a chip similar to SiI, the IT8212 would have big
problems with a Trust (a brand name that in my experience is an
antonym) card based on it, but a different card with the same
chipset seems fine; but transfers are rather slower, which may
means that the IT8212 has some problems at high frequencies and
Trust did not throttle the chip. As to high end ones, bugs and
problems are rather common, because they are sold on features,
not reliability (a common story).

Anyhow, given the state of Chinese manufacturing, even different
batches of exactly the same product even if well designed can
have very different quality, depending on which poor quality
component has been substituted.

  Explanation: even if company buys good quality components, the
  factory or stock room manager may pilfer them and replace them
  with poor quality ones and sell the good quality ones at a
  huge profit. Never mind this being done intentionally to cut
  costs.

[ ... ]

> The moral of the story here is: If you're going to be buying
> lots of disks, do *not* skimp on cabling and controllers.

Only in part; the moral of the story is that system integration
is a very difficult and risky business and most people do not
have the experience and resources to do it.

Even people with a lot of experience and resources get surprises:

https://indico.desy.de/contributionDisplay.py?contribId=65&sessionId=42&confId=257
http://indico.fnal.gov/contributionDisplay.py?contribId=44&amp;sessionId=15&amp;confId=805
[pages 11 and following]

> Thanks all for the helpful suggestions and "me too!" entries -
> my 6 disk raid5 is about a half hour away from completing
> resync and I've had no nasties in dmesg. Win! :)

Ah, one of those RAID5s. Consider reading http://WWW.BAARF.com/
as to corruption. "if you are going to buy lots of disks, do
*not* skimp on" the RAID level.
