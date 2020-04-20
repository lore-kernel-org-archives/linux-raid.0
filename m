From: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Mon, 20 Apr 2020 11:23:14 +0200
Message-ID: <6dd25ff4-7c99-4b6f-3a50-de4130013847@peter-speer.de>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
 <5E95C698.1030307@youngman.org.uk>
 <13a3bc12-67f7-46d5-7e6a-c6880ace4b1c@peter-speer.de>
 <5E95F461.50209@youngman.org.uk> <87lfmtemqf.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87lfmtemqf.fsf@esperi.org.uk>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 18.04.20 01:06, Nix wrote:
> Frankly... I would make this stuff a lot simpler and just not make a
> swap partition at all. Instead, make a swapfile: RAID will just happen
> for you automatically, you can expand the thing (or shrink it!) with
> ease while the system is up, and it's exactly as fast as swap
> partitions: swapfiles have been as fast as raw partitions since the
> Linux 2.0 days.

This convinced me, I'll take this approach.
Thanks.
