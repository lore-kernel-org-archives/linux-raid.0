From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] segfault in imsm create with wrong arguments
Date: Mon, 13 Dec 2010 13:51:50 +1100
Message-ID: <20101213135150.3238d1b4@notabene.brown>
References: <20101212113355.GA24577@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101212113355.GA24577@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 12 Dec 2010 12:33:55 +0100 Luca Berra <bluca@comedia.it> wrote:

> When calling mdadm -C --metadata=imsm -l 1 /dev/sd..
> mdadm segfaults in default_chunk_imsm()
> above syntax is incorrect, but mdadm should error instead of segfaulting
> 

Thanks.  Applied.

NeilBrown

