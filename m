From: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Subject: Re: Split RAID: Proposal for archival RAID using incremental batch checksum
Date: Tue, 16 Dec 2014 21:55:15 +0530
Message-ID: <CAK-d5db_ubRobL=uiia_9yOFA0PMovptAG8O+Y17ORT_--FsQg@mail.gmail.com>
References: <CAK-d5dbdF160hoa1==jWxEQZRpwQ7Sa76=9MREmp2V6Y24U8Kw@mail.gmail.com>
 <20141029200501.1f01269d@notabene.brown> <CAK-d5dah-NyQzVNBScYoVSo2cpGA8F3vuK_Zh1YzQn5Mr+_-oQ@mail.gmail.com>
 <CAK-d5dYm7tEY855w1CdkvPz22ukkg1DwGz_mQ_9-JRV0M=O6Rw@mail.gmail.com>
 <20141103165217.3bfd3d3e@notabene.brown> <CAK-d5daq+-PbX1s81h01x7GdVDCijyzzPaeRAOCctEXTNideCw@mail.gmail.com>
 <20141125095052.51f8eadc@notabene.brown> <CAK-d5dZnWpmyPfWTGB74wHojeywdiXDnT6Fs0yqYqn7bJpSL-Q@mail.gmail.com>
 <CAK-d5dY4QEDupxjkon_+6z0Z7ggPKv=PLF60zTkeSBsbd4+mPQ@mail.gmail.com>
 <CAK-d5dZMjbhAqgs9GOvswG6crZtrV2uSidRzt_hBJAH=m5rGKw@mail.gmail.com>
 <20141202084611.45f56d6a@notabene.brown> <CAK-d5dajGYxda_UFK_fBET14+KDr68km0uEKfrQVqs5oShWGfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK-d5dajGYxda_UFK_fBET14+KDr68km0uEKfrQVqs5oShWGfg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2 December 2014 at 17:26, Anshuman Aggarwal
<anshuman.aggarwal@gmail.com> wrote:
> It works! (Atleast on a sample 5 MB device with 5 x 1MB partitions :-)
> will find more space on my drives and do a larger test but don't see
> why it shouldn't work)
> Here are the following caveats (and questions):
> - Neil, like you pointed out, the power of 2 chunk size will probably
> need a code change (in the kernel or only in the userspace tool?)
>     - Any performance or other reasons why a terabyte size chunk may
> not be feasible?
> - Implications of safe_mode_delay
>     - Would the metadata be updated on the block device be written to
> and the parity device as well?
>     - If the drive  fails which is the same as the drive being written
> to, would that lack of metadata updates to the other devices affect
> reconstruction?
> - Adding new devices (is it possible to move the parity to the disk
> being added? How does device addition work for RAID4 ...is it added as
> a zero-ed out device with parity disk remaining the same)
>
>

Neil, sorry to try to bump this thread. Could you please look over the
questions and address the points on the remaining items that can make
it a working solution? Thanks
