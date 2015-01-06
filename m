From: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Subject: Re: Split RAID: Proposal for archival RAID using incremental batch checksum
Date: Tue, 6 Jan 2015 17:10:16 +0530
Message-ID: <CAK-d5dbccv_iwep3u6uW-zyfqho3NrjPgJ+QVQs4EBorTjgWCw@mail.gmail.com>
References: <CAK-d5dbdF160hoa1==jWxEQZRpwQ7Sa76=9MREmp2V6Y24U8Kw@mail.gmail.com>
 <20141029200501.1f01269d@notabene.brown> <CAK-d5dah-NyQzVNBScYoVSo2cpGA8F3vuK_Zh1YzQn5Mr+_-oQ@mail.gmail.com>
 <CAK-d5dYm7tEY855w1CdkvPz22ukkg1DwGz_mQ_9-JRV0M=O6Rw@mail.gmail.com>
 <20141103165217.3bfd3d3e@notabene.brown> <CAK-d5daq+-PbX1s81h01x7GdVDCijyzzPaeRAOCctEXTNideCw@mail.gmail.com>
 <20141125095052.51f8eadc@notabene.brown> <CAK-d5dZnWpmyPfWTGB74wHojeywdiXDnT6Fs0yqYqn7bJpSL-Q@mail.gmail.com>
 <CAK-d5dY4QEDupxjkon_+6z0Z7ggPKv=PLF60zTkeSBsbd4+mPQ@mail.gmail.com>
 <CAK-d5dZMjbhAqgs9GOvswG6crZtrV2uSidRzt_hBJAH=m5rGKw@mail.gmail.com>
 <20141202084611.45f56d6a@notabene.brown> <CAK-d5dajGYxda_UFK_fBET14+KDr68km0uEKfrQVqs5oShWGfg@mail.gmail.com>
 <CAK-d5db_ubRobL=uiia_9yOFA0PMovptAG8O+Y17ORT_--FsQg@mail.gmail.com>
 <20141217084921.360ca442@notabene.brown> <CAK-d5daVxQN3JifvcA9+PL04p1L3O0KXQkgBwyhs1O6tHnHeMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK-d5daVxQN3JifvcA9+PL04p1L3O0KXQkgBwyhs1O6tHnHeMg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17 December 2014 at 12:10, Anshuman Aggarwal
<anshuman.aggarwal@gmail.com> wrote:
> On 17 December 2014 at 03:19, NeilBrown <neilb@suse.de> wrote:
>> On Tue, 16 Dec 2014 21:55:15 +0530 Anshuman Aggarwal
>> <anshuman.aggarwal@gmail.com> wrote:
>>
>>> On 2 December 2014 at 17:26, Anshuman Aggarwal
>>> <anshuman.aggarwal@gmail.com> wrote:
>>> > It works! (Atleast on a sample 5 MB device with 5 x 1MB partitions :-)
>>> > will find more space on my drives and do a larger test but don't see
>>> > why it shouldn't work)
>>> > Here are the following caveats (and questions):
>>> > - Neil, like you pointed out, the power of 2 chunk size will probably
>>> > need a code change (in the kernel or only in the userspace tool?)
>>
>> In the kernel too.
>
> Is this something that you would consider implementing soon? Is there
> a performance/other impact to any other consideration to remove this
> limitation.. could you elaborate on the reason why it was there in the
> first place?
>
> If this is a case of patches are welcome, please guide on where to
> start looking/working even if its just
>
>>
>>> >     - Any performance or other reasons why a terabyte size chunk may
>>> > not be feasible?
>>
>> Not that I can think of.
>>
>>> > - Implications of safe_mode_delay
>>> >     - Would the metadata be updated on the block device be written to
>>> > and the parity device as well?
>>
>> Probably.  Hard to give a specific answer to vague question.
>
> I should clarify.
>
> For example in a 5 device RAID4, lets say block is being written to
> device 1 and parity is on device 5 and devices 2,3,4 are sleeping
> (spun down). If we set safe_mode_delay to 0 and md decides to update
> the parity without involving the blocks on the other 3 devices and
> just updates the parity by doing a read, compute, write to device 5
> will the metadata be updated on both device 1 and 5 even though
> safe_mode_delay is 0?
>
>>
>>> >     - If the drive  fails which is the same as the drive being written
>>> > to, would that lack of metadata updates to the other devices affect
>>> > reconstruction?
>>
>> Again, to give a precise answer, a detailed question is needed.  Obviously
>> any change would have to made in such a way to ensure that things which
>> needed to work, did work.
>
> Continuing from the previous example, lets say device 1 fails after a
> write which only updated metadata on 1 and 5 while 2,3,4 were
> sleeping. In that case to access the data from 1, md will use 2,3,4,5
> but will it then update the metadata from 5 onto 2,3,4? I hope I am
> making this clear.
>
>>
>>
>>> > - Adding new devices (is it possible to move the parity to the disk
>>> > being added? How does device addition work for RAID4 ...is it added as
>>> > a zero-ed out device with parity disk remaining the same)
>>
>> RAID5 or RAID6 with ALGORITHM_PARITY_0 puts the parity on the early devices.
>> Currently if you add a device to such an array ...... I'm not sure what it
>> will do.  It should be possible to make it just write zeros out.
>>
>
> Once again, is this something that can make its way to your roadmap?
> If so, great.. otherwise could you steer me towards where in the md
> kernel and mdadm source I should be looking to make these changes.
> Thanks again.
>
>>
>> NeilBrown
>>
>>
>>> >
>>> >
>>>
>>> Neil, sorry to try to bump this thread. Could you please look over the
>>> questions and address the points on the remaining items that can make
>>> it a working solution? Thanks
>>

Hi Neil,
 Could you please find a minute to give your input to the above? Your
guidance will go a long way towards making this a reality and it may
be useful to the community at large with the new Seagate 8TB archival
drives which seem to be more geared towards occasional use but would
still benefit from a RAID like redundancy.

Many thanks,
Anshuman
