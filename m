From: Phil Turmel <philip@turmel.org>
Subject: Re: future of raid 6
Date: Mon, 4 Sep 2017 23:44:18 -0400
Message-ID: <ee802a90-e92e-92b1-5543-7f8c0f2e3c68@turmel.org>
References: <2811558.CnJCJrJZ21@markus> <20170904095347.GA4187@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170904095347.GA4187@metamorpher.de>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Markus <M4rkusXXL@web.de>
Cc: Andreas Klauer <Andreas.Klauer@metamorpher.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Markus,

On 09/04/2017 05:53 AM, Andreas Klauer wrote:
> On Sun, Sep 03, 2017 at 08:28:15PM +0200, Markus wrote:
>> (Rebuilds are likely to hit an unrecoverable error, not to mention the 
>> long time it will take to rebuild raids with +10TB per drive.)
> 
> Rebuilds are not likely to hit an unrecoverable error at all.
> Rebuilds do not take a long time, and it tends to be irrelevant.
> 
> A lot of articles make rebuilds out to be some kind of mythological beast 
> that breathes fire, spits poison, and devours your drives. It's not true.

You should be aware that some helpful people nevertheless have a magical
view of technology and don't actually provide accurate information, like
the above (commonly repeated) screed.

The failure event possibilities of the various raid levels can be easily
analyzed if one is unafraid of math (statistics) and have a modest view
of the possible events involved.

The possible events are basically true, persistent hardware failure of
the drive, and potentially rewritable/fixable transient magnetic
failures in data retrieval.  The can combine in various ways, like so:

https://marc.info/?l=linux-raid&m=139050322510249&w=2

The odds of total hardware failure can be inferred from warranty
lengths, but are generally much lower than the odds of transient flaws,
based on manufacturer's specification claims for unrecoverable read
errors.  The math for the latter follows the Poisson distribution, like so:

https://marc.info/?l=linux-raid&m=135863964624202&w=2

>> What is the future for redundant mass storage?

Pretty bright, if you really take a look at the math.  And are willing
to purchase hardware that cooperates with automated maintenance instead
of blowing up (the dreaded and very real timeout mismatch problem that
Andreas dismisses as fantasy).  Simply put, if smartctl -l scterc yields
a message that Error Recovery Control is not supported, you *must*
adjust the kernel's driver timeouts to avoid catastrophic array failure.

Phil
