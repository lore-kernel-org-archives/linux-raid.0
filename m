From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: Handling mismatch_cnt
Date: Sat, 25 Jul 2009 10:06:11 +1000
Message-ID: <4A6A4C73.2070000@eyal.emu.id.au>
References: <f1d2d9ca0907240901y60c8d8bdlfb9938de9b374561@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f1d2d9ca0907240901y60c8d8bdlfb9938de9b374561@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanassis Tsiodras wrote:
> Handling mismatch_cnt<>0
[trim]
> Am I missing something? Is MD RAID1 in fact better than what I
> have understood? Is there an answer that would allow me to use it
 > without the uncertainty of "russian-roulette" fixes when the
 > inevitable mismatch_cnt<>0 occurs?

RAID1 will ensure your data is not lost when one disk completely fails.
This is a rather common mode of failure. You are protected against this
catastrophic event but not against (minor? damage of a) sector failure.
I use RAID for just this benefit.

Unlike RAID5, RAID6 should be able to do better than a random correction
(does it?).

RAID1 with more than two disks should also do better with voting
(does it?).

> In other words, is there anything a Linux guy can do besides wait
> for btrfs or trust a FUSE version of ZFS?
> 
> Thanks for any feedback,
> Thanassis.

-- 
Eyal Lebedinsky	(eyal@eyal.emu.id.au)
