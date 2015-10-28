From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] raid5-cache: use crc32c checksum
Date: Wed, 28 Oct 2015 08:26:58 -0700
Message-ID: <5630E942.90501@sandisk.com>
References: <05c660271fe0d5f42bc053ef89c5e20ff57cf955.1445989535.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <05c660271fe0d5f42bc053ef89c5e20ff57cf955.1445989535.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, neilb@suse.de
List-Id: linux-raid.ids

On 10/27/2015 04:48 PM, Shaohua Li wrote:
> crc32c has lower overhead with cpu acceleration. It's a shame I didn't
> use it in first post, sorry. This changes disk format, but we are still
> ok in current stage.

Hello Shaohua,

Although this patch looks fine to me I think the (void *) casts in the 
crc32c_le() calls can be left out. Had you considered to include that 
change in this patch ?

Thanks,

Bart.
