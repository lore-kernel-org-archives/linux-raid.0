From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: [sucess?] upgrading LSI SAS9211-8i fw IR->IT
Date: Sun, 29 Oct 2017 23:02:56 +0800
Message-ID: <a1ff5d9b-89be-37b6-69d4-3a786241d614@fnarfbargle.com>
References: <08feefcc-14d0-e7ec-aa23-927ecbb63ac3@eyal.emu.id.au>
 <f268a7a1-6a73-8c9f-b4c8-1e8190f54850@eyal.emu.id.au>
 <19b2182e-dca2-512a-6d20-c2664857f0b9@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19b2182e-dca2-512a-6d20-c2664857f0b9@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>, list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 28/10/17 07:09, Eyal Lebedinsky wrote:

> I am ready to commission this controller after next week's backup, but
> would still like answers to
> some questions.
>
> Q1) I did not flash a rom file, do I need to do so (with the IT fw)?

Not unless you plan on trying to boot from one. I have the BIOS zeroed 
on all my cards as it speeds up POST.

> Q2) The upgrade changed the SAS Address, should I reprogram the original
> address?

I always reset the address, but mainly because I don't want 2 cards in 
the machine with the same address.

> Q3) Below are the relevant messages from the test, do they look good?
>     Is the "overriding NVDATA EEDPTagMode setting" OK?

Can't answer that one. A quick squiz at the source doesn't seem like 
it's particularly evil though.

Brad
-- 
Dolphins are so intelligent that within a few weeks they can
train Americans to stand at the edge of the pool and throw them
fish.
