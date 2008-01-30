From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: WRONG INFO (was Re: In this partition scheme, grub does not find
 md information?)
Date: Wed, 30 Jan 2008 13:00:00 +0100
Message-ID: <47A066C0.7040602@rabbit.us>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us> <479F4CFC.5060305@pobox.com> <47A05971.1020507@dgreaves.com> <47A06331.5050709@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A06331.5050709@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Moshe Yudkowsky <moshe@pobox.com>
Cc: David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Moshe Yudkowsky wrote:
> over the other. For example, I've now learned that if I want to set up a 
> RAID1 /boot, it must actually be 1.2 or grub won't be able to read it. 
> (I would therefore argue that if the new version ever becomes default, 
> then the default sub-version ought to be 1.2.)

In the discussion yesterday I myself made a serious typo, that should not 
spread. The only superblock version that will work with current GRUB is 1.0 
_not_ 1.2.
