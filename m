From: Phil Turmel <philip@turmel.org>
Subject: Re: When do you replace old hard drives in a raid6?
Date: Sun, 6 Mar 2016 19:29:09 -0500
Message-ID: <56DCCB55.1060906@turmel.org>
References: <56DB465E.9010703@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56DB465E.9010703@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 03/05/2016 03:49 PM, Ram Ramesh wrote:
> I am curious if people actually replace hard drives periodically because
> they are old or out of warranty. My 5 device raid6 has several older
> drives (3/5 are 3+ years old and out of warranty) They seem fine with
> SMART and raid scrubs. However, it makes me wonder when they will die.
> What is the best policy in such situations? More importantly, do people
> wait for disks to die and then replace or have some ad hoc schedule of
> replacing (like every 6mo replace oldest) to keep things safe?

I replace drives when their relocation count hits double digits.  In my
limited sample, that's typically after 40,000 hours.

Phil
