From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Raid 1 install revealed poor HD performance (I think)
Date: Tue, 17 May 2005 16:50:47 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0505171649090.32621@lion.drogon.net>
References: <428A09A3.9000802@heyjay.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <428A09A3.9000802@heyjay.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jay Strauss <me@heyjay.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 17 May 2005, Jay Strauss wrote:

> I'm very unfamiliar with options for speeding up hard drive access.
> What might Knoppix be setting (and how would I look for it), that it's
> getting 100% better drive performance than a plain jane Sarge install?

The usual culprit is DMA. (Or lack of it in your case)

What does

  hdparm /dev/hda

give under each OS?

You can use hdparm to enable DMA, but this doesn't always work - the real
solution is to work out what type of IDE controller you have and make sure
it's compiled into your kernel.

Gordon
