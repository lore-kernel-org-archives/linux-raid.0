From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 09/18] md/raid6: remove expectation that Q device is
	immediately after P device.
Date: Fri, 13 Feb 2009 15:19:43 -0700
Message-ID: <e9c3a7c20902131419u38e75b2eqbaf442a2b090755e@mail.gmail.com>
References: <20090212031009.23983.14496.stgit@notabene.brown>
	 <20090212031010.23983.26264.stgit@notabene.brown>
	 <20090212165625.GH32416@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090212165625.GH32416@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 12, 2009 at 9:56 AM, Andre Noll <maan@systemlinux.org> wrote:
> On 14:10, NeilBrown wrote:
>
>> -static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int previous);
>> +static int stripe_to_pdidx(sector_t stripe, raid5_conf_t *conf, int previous,
>> +                        int *qd_idx);
>
> That's a bit ugly, isn't it? The function computes both the p index
> and the q index which is not obvious from its name. Also, the p index
> is the return value and the q index is returned via a pointer which
> is a bit unsymmetric.
>
> static void get_parity_indices(sector_t stripe, raid5_conf_t *conf, int previous,
>                                 int *pd_idx, int *qd_idx);
>
> perhaps?
>
>> +     /* Note that unlike RAID-5, the ordering of the disks matters greatly.*/
>> +     /* FIX: Is this ordering of drives even remotely optimal? */
>> +     count = 0;
>> +     i = d0_idx;
>> +     do {
>> +             if (i == sh->pd_idx)
>> +                     ptrs[disks-2] = page_address(sh->dev[i].page);
>> +             else if (i == sh->qd_idx)
>> +                     ptrs[disks-1] = page_address(sh->dev[i].page);
>> +             else {
>>                       ptrs[count++] = page_address(sh->dev[i].page);
>> -                     if (count <= disks-2 && !test_bit(R5_UPTODATE, &sh->dev[i].flags))
>> +                     if (!test_bit(R5_UPTODATE, &sh->dev[i].flags))
>>                               printk("block %d/%d not uptodate on parity calc\n", i,count);
>> -                     i = raid6_next_disk(i, disks);
>> -             } while ( i != d0_idx );
>> -//           break;
>> -//   }
>> +             }
>> +             i = raid6_next_disk(i, disks);
>> +     } while (i != d0_idx);
>> +     BUG_ON(count+2 != disks);
>
> Isn't it really dangerous to ignore a dirty stripe head during parity
> calculation? I understand that compute_parity6() does not have a
> return value and that dirty stripe heads have always been ignored by
> compute_parity6(). But it looks much saner to fail in this case.
>
> BTW, the printk lacks a KERN_ERR.
>
>> +     /**** FIX THIS: This could be very bad if disks is close to 256 ****/
>> +     void *ptrs[disks];
>
> How serious is this? It's probably not a problem for version 0.90
> superblocks as one can't have more than 26 disks. OTOH, for version
> 1 superblocks we might end up using up to 2K of stack space on 64
> bit machines.

This is ok in recent kernels because we perform raid calculations in
raid5d or md_do_sync where we have our own stack.  However, with raid6
acceleration we also want to convert dma addresses on the stack which
means the calculation needs double the amount of space.

> Would it be a reasonable to always allocate 26 pointers, say, and
> fall back to malloc() if this turns out to be too small?

Even a GFP_ATOMIC allocation may fail and we would always be
allocating in the > 26 disks case.  The worst case scenario is
actually 4K stacks on a raid6 acceleration enabled 32-bit system with
64-bit dma addresses.  This configuration would require 3K of stack to
start a 256 disk parity calculation, but that should still be ok given
we have our own thread.

Regards,
Dan
