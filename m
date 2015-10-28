From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] raid5-cache: use crc32c checksum
Date: Wed, 28 Oct 2015 15:46:10 -0700
Message-ID: <56315032.7070904@sandisk.com>
References: <05c660271fe0d5f42bc053ef89c5e20ff57cf955.1445989535.git.shli@fb.com>
 <5630E942.90501@sandisk.com>
 <20151028154124.GA439358@devbig084.prn1.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151028154124.GA439358@devbig084.prn1.facebook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, neilb@suse.de
List-Id: linux-raid.ids

On 10/28/2015 08:41 AM, Shaohua Li wrote:
> crc32c has lower overhead with cpu acceleration. It's a shame I didn't
> use it in first post, sorry. This changes disk format, but we are still
> ok in current stage.
>
> V2: delete unnecessary type conversion as pointed out by Bart

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
