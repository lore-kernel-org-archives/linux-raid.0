From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: raid array with 3T disks and GPT partition
Date: Thu, 01 Sep 2011 17:56:04 +0100
Message-ID: <4E5FB924.7010203@anonymous.org.uk>
References: <20110901154759.GA32649@apartia.fr> <20110901155913.GA20825@cthulhu.home.robinhill.me.uk> <20110901163334.GA13347@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110901163334.GA13347@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
List-Id: linux-raid.ids

On 01/09/2011 17:33, Louis-David Mitterrand wrote:
[...]
> Auto-assembly and metadata are not related: I regularly use 1.2 metadata
> on non-boot partitions and they auto-assemble fine.

Not possible. The kernel will not auto-assemble anything other than 0.90 
metadata. You must have mdadm in your initrd.

> However lilo won't boot on anything other than 0.9, this I found the
> hard way :)

I have had lilo boot from 1.0 metadata just fine. It does need to be the 
metadata-at-the-end layout though, hence 1.0 but not 1.1 or 1.2.

> Kernel auto-assembly seems quite useful and desirable to me, especially
> when using, say, initrd to unlock dm-crypt partitions (no need to
> configure madadm.conf in the initrd).

Neil Brown took the decision ages ago not to add any more what ought to 
be userland use-once tools into the kernel, and this is the general 
direction across the whole kernel. If you have an initrd unlocking a 
dm-crypt partition you might as well have mdadm in there as well 
starting your arrays.

> BTW, what is that 0xDA type?

Non-FS data.

Cheers,

John.

