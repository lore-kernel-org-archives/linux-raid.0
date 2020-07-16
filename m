From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: decruft the early init / initrd / initramfs code v2
Date: Thu, 16 Jul 2020 17:57:12 +0200
Message-ID: <4b38a63b-af09-608c-c4fa-b9e484ebe6bc@cloud.ionos.com>
References: <20200714190427.4332-1-hch@lst.de>
 <CAHk-=wgxV9We+nVcJtQu2DHco+HSeja-WqVdA-KUcB=nyUYuoQ@mail.gmail.com>
 <20200715065140.GA22060@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200715065140.GA22060@lst.de>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-raid@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On 7/15/20 8:51 AM, Christoph Hellwig wrote:
> On Tue, Jul 14, 2020 at 12:34:45PM -0700, Linus Torvalds wrote:
>> On Tue, Jul 14, 2020 at 12:06 PM Christoph Hellwig <hch@lst.de> wrote:
>>> this series starts to move the early init code away from requiring
>>> KERNEL_DS to be implicitly set during early startup.  It does so by
>>> first removing legacy unused cruft, and the switches away the code
>>> from struct file based APIs to our more usual in-kernel APIs.
>> Looks good to me, with the added note on the utimes cruft too as a
>> further cleanup (separate patch).
>>
>> So you can add my acked-by.
>>
>> I _would_ like the md parts to get a few more acks. I see the one from
>> Song Liu, anybody else in md land willing to go through those patches?
>> They were the bulk of it, and the least obvious to me because I don't
>> know that code at all?
> Song is the maintainer.   Neil is the only person I could think of
> that also knows the old md code pretty well.  Guoqing has contributed
> a lot lately, but the code touched here is rather historic (and not
> used very much at all these days as people use modular md and initramfѕ
> based detection).

Hi Christoph,

I just cloned the tree, seems there is compile issue that you need to 
resolve.

hch-misc$ make -j8
   DESCEND  objtool
   CALL    scripts/atomic/check-atomics.sh
   CALL    scripts/checksyscalls.sh
   CHK     include/generated/compile.h
   CC      drivers/md/md.o
   CC      drivers/md/md-bitmap.o
   CC      drivers/md/md-autodetect.o
   AR      drivers/perf/built-in.a
   CC      drivers/md/dm.o
   AR      drivers/hwtracing/intel_th/built-in.a
   CC      drivers/nvmem/core.o
drivers/md/md.c:7809:45: error: static declaration of ‘md_fops’ follows 
non-static declaration
  static const struct block_device_operations md_fops =
                                              ^~~~~~~
drivers/md/md.c:329:38: note: previous declaration of ‘md_fops’ was here
  const struct block_device_operations md_fops;
                                       ^~~~~~~
scripts/Makefile.build:280: recipe for target 'drivers/md/md.o' failed
make[2]: *** [drivers/md/md.o] Error 1
make[2]: *** Waiting for unfinished jobs....

And for the changes of md, feel free to add my Acked-by if it could help.

Thanks,
Guoqing
