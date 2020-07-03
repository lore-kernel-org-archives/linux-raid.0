From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 09/16] initrd: remove the BLKFLSBUF call in handle_initrd
Date: Thu, 2 Jul 2020 20:40:31 -0700
Message-ID: <514b0176-d235-f640-b278-9a7d49af356f@zytor.com>
References: <20200615125323.930983-1-hch@lst.de>
 <20200615125323.930983-10-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200615125323.930983-10-hch@lst.de>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Cc: Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On 2020-06-15 05:53, Christoph Hellwig wrote:
> BLKFLSBUF used to be overloaded for the ramdisk driver to free the whole
> ramdisk, which was completely different behavior compared to all other
> drivers.  But this magic overload got removed in commit ff26956875c2
> ("brd: remove support for BLKFLSBUF"), so this call is entirely
> pointless now.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Does *anyone* use initrd as opposed to initramfs anymore? It would seem
like a good candidate for deprecation/removal.

	-hpa
