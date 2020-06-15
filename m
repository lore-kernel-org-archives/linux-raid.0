From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: decruft the early init / initrd / initramfs code
Date: Mon, 15 Jun 2020 09:03:49 -0700
Message-ID: <aa12bf27-9013-439e-f946-3d8ad654d4fd@infradead.org>
References: <20200615125323.930983-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200615125323.930983-1-hch@lst.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On 6/15/20 5:53 AM, Christoph Hellwig wrote:
> Hi all,
> 
> this series starts to move the early init code away from requiring
> KERNEL_DS to be implicitly set during early startup.  It does so by
> first removing legacy unused cruft, and the switches away the code
> from struct file based APIs to our more usual in-kernel APIs.

Hi,

Would it be possible to get a series diffstat in your patch
cover letters as a regular thing, please?

thanks.
-- 
~Randy
