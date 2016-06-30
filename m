From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: [PATCH v2 04/12] axonrom: Generate uevent after attribute available
Date: Thu, 30 Jun 2016 15:10:06 -0700
Message-ID: <CAA9_cmf0cKZXdQ2N3iSbwVqgLDGJ7TMvVYuZTqjVE-7EqHHcdg@mail.gmail.com>
References: <20160630015953.6888-1-famz@redhat.com> <20160630015953.6888-5-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160630015953.6888-5-famz@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Fam Zheng <famz@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Jens Axboe <axboe@kernel.dk>, "Ed L. Cashin" <ed.cashin@acm.org>, Jiri Kosina <jikos@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Shaohua Li <shli@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Keith Busch <keith.busch@intel.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-block@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-raid <linux-raid@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, linux-mtd@lists.infradead.org
List-Id: linux-raid.ids

On Wed, Jun 29, 2016 at 6:59 PM, Fam Zheng <famz@redhat.com> wrote:
> It is documented that KOBJ_ADD should be generated after the object's
> attributes and children are ready.  We can achieve this with the new
> disk_gen_uevents interface.
>
> Signed-off-by: Fam Zheng <famz@redhat.com>
> ---
>  arch/powerpc/sysdev/axonram.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
> index 4efd69b..27e7175 100644
> --- a/arch/powerpc/sysdev/axonram.c
> +++ b/arch/powerpc/sysdev/axonram.c
> @@ -238,7 +238,7 @@ static int axon_ram_probe(struct platform_device *device)
>         set_capacity(bank->disk, bank->size >> AXON_RAM_SECTOR_SHIFT);
>         blk_queue_make_request(bank->disk->queue, axon_ram_make_request);
>         blk_queue_logical_block_size(bank->disk->queue, AXON_RAM_SECTOR_SIZE);
> -       add_disk(bank->disk, true);
> +       add_disk(bank->disk, false);
>
>         bank->irq_id = irq_of_parse_and_map(device->dev.of_node, 0);
>         if (bank->irq_id == NO_IRQ) {
> @@ -262,6 +262,7 @@ static int axon_ram_probe(struct platform_device *device)
>                 rc = -EFAULT;
>                 goto failed;
>         }
> +       disk_gen_uevents(bank->disk);

I assume you are doing this after:

   rc = device_create_file(&device->dev, &dev_attr_ecc);

...so that userspace gets notified of the new attribute, but this
attribute is on the parent device, not the disk itself.  Instead I
think this attribute should simply be registered before the call to
add_disk().  Then the KOBJ_ADD event for the disk comes after the
attribute is available.  It's still not a clean fit, because userspace
should not be expecting a child device uevent to signal new attributes
available on the parent.
