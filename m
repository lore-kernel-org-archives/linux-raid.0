From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Sun, 27 Jan 2013 23:58:35 -0800
Message-ID: <CAA9_cmc-jMej-czNeDz7H5Vtve17dHAxtK3zoVWHHmPC8OFJ3Q@mail.gmail.com>
References: <20130127192656.634892005AD@gemini.denx.de>
	<5105DD72.6080909@fnarfbargle.com>
	<20130128063952.E3BD7258787@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130128063952.E3BD7258787@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jan 27, 2013 at 10:39 PM, Wolfgang Denk <wd@denx.de> wrote:
> Dear Brad Campbell,
>
> In message <5105DD72.6080909@fnarfbargle.com> you wrote:
>>
>> Massive mismatch counts are indicative of an insidious problem further
>> down the storage stack. Check your drivers, cards, cables and PSU.
>
> That's why I'm asking. The hardware has not been changed at all, and
> has been running reliably for many months even years. No such problem
> has been observed ever before, but now it happens at the first check
> operation after switching to Fedora 18, simultaneous on all systems.

Can you, without too much pain, downgrade the kernel to the one from
before the upgrade (which kernel was that?) and re-run the check?
That would be an interesting data point.  Although if this reverts the
behavior I expect it would be fairly straightforward to reproduce.

--
Dan
