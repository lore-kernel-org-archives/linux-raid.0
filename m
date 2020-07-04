From: antlists <antlists@youngman.org.uk>
Subject: Re: [PATCH 09/16] initrd: remove the BLKFLSBUF call in handle_initrd
Date: Sat, 4 Jul 2020 01:18:48 +0100
Message-ID: <e60b1977-2e1d-75ee-e934-207658145098@youngman.org.uk>
References: <20200615125323.930983-1-hch@lst.de>
 <20200615125323.930983-10-hch@lst.de>
 <514b0176-d235-f640-b278-9a7d49af356f@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <514b0176-d235-f640-b278-9a7d49af356f@zytor.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Cc: Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On 03/07/2020 04:40, H. Peter Anvin wrote:
> On 2020-06-15 05:53, Christoph Hellwig wrote:
>> BLKFLSBUF used to be overloaded for the ramdisk driver to free the whole
>> ramdisk, which was completely different behavior compared to all other
>> drivers.  But this magic overload got removed in commit ff26956875c2
>> ("brd: remove support for BLKFLSBUF"), so this call is entirely
>> pointless now.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Does *anyone* use initrd as opposed to initramfs anymore? It would seem
> like a good candidate for deprecation/removal.
> 
Reading the gentoo mailing list, it seems there's a fair few people who 
don't use initramfs. I get the impression they don't use initrd either, 
though.

I don't know too much about booting without an initramfs - I switched 
ages ago - so what is possible and what they're actually doing, I don't 
know.

Cheers,
Wol
