From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH] md - 0 of 2 - Introduction
Date: Fri, 05 Mar 2004 13:01:20 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40484FF0.6010109@tls.msk.ru>
References: <20040305164342.7205.patches@notabene> <40483D68.9030906@tequila.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40483D68.9030906@tequila.co.jp>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Clemens Schwaighofer wrote:
> 
> NeilBrown wrote:
> | Here are two patches for md that I believe are suitable
> | for 2.6.4.
> |
> | 2/ Support assembling partitionable raid at boot-time so that it is
> |    possible to boot from a partition of a raid array without needing
> |    an initramfs.
> 
> I have a RAID 1 here and I boot with grub and I don't need ana initramfs
> (initrd) ...

The keyword here is "partitionable".

/mjt
