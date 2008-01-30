From: David Greaves <david@dgreaves.com>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Wed, 30 Jan 2008 11:03:13 +0000
Message-ID: <47A05971.1020507@dgreaves.com>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F4CFC.5060305@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479F4CFC.5060305@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>, Neil Brown <neilb@suse.de>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid@vger.kernel.org, Michael Tokarev <mjt@tls.msk.ru>
List-Id: linux-raid.ids

On 26 Oct 2007, Neil Brown wrote:
>On Thursday October 25, david@dgreaves.com wrote:
>> I also suspect that a *lot* of people will assume that the highest superblock
>> version is the best and should be used for new installs etc.
>
> Grumble... why can't people expect what I want them to expect?


Moshe Yudkowsky wrote:
> I expect it's because I used 1.2 superblocks (why
> not use the latest, I said, foolishly...) and therefore the RAID10 --

Aha - an 'in the wild' example of why we should deprecate '0.9 1.0 1.1, 1.2' and
rename the superblocks to data-version + on-disk-location :)


David





