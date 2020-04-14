From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Tue, 14 Apr 2020 20:36:14 +0100
Message-ID: <5E9610AE.3000507@youngman.org.uk>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
 <5E95C698.1030307@youngman.org.uk>
 <13a3bc12-67f7-46d5-7e6a-c6880ace4b1c@peter-speer.de>
 <5E95F461.50209@youngman.org.uk>
 <fe996f6f-3b0a-4638-d74d-ae6dc99599df@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fe996f6f-3b0a-4638-d74d-ae6dc99599df@peter-speer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/04/20 20:13, Stefanie Leisestreichler wrote:
>> I'd just use type linux ...

> Could you please be a little more concrete on this one?

The old scheme linux disks were 83. That makes it 8300 on gpt. Like 82
is swap.

At the end of the day, linux doesn't care much. So why should you? In
the old days you needed disk-type raid to tell the kernel to
auto-assemble it, but you shouldn't be using that nowadays.

Cheers,
Wol
