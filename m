From: Asdo <asdo@shiftmail.org>
Subject: Re: MD write performance issue - found Catalyst patches
Date: Wed, 04 Nov 2009 18:25:56 +0100
Message-ID: <4AF1B924.1060605@shiftmail.org>
References: <66781b10910180300j2006a4b7q21444bb27dd9434e@mail.gmail.com>
 <19177.14609.138378.581065@notabene.brown> <4AE94D95.4060303@shiftmail.org>
 <66781b10910310351x7bb721c4mfba765fe9789cd7b@mail.gmail.com>
 <19183.47226.529417.743975@notabene.brown>
 <66781b10911030411y5bb32610lec72966f7cc09df@mail.gmail.com>
 <66781b10911040915t11a7f0c2td6a9ed5672935efb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <66781b10911040915t11a7f0c2td6a9ed5672935efb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hey great job Neil and Mark
Mark, your benchmarks seems to confirm Neil's analysis: ext2 and ext3 
are not slowed down from 2.6.28.5 and 2.6.28.6
Mark why don't you try to apply the patch below here by Eric Sandeen 
found by Neil to the 2.6.28.6 to see if the xfs write performance comes 
back?
Thank you for your efforts
Asdo

mark delfman wrote:
> Some FS comparisons attached in pdf
>
> not sure what to make of them as yet, but worth posting
>
>
> On Tue, Nov 3, 2009 at 12:11 PM, mark delfman
> <markdelfman@googlemail.com> wrote:
>   
>> Thanks Neil,
>>
>> I seem to recall that I tried this on EXT3 and saw the same results as
>> XFS, but with your code and suggestions I think it is well worth me
>> trying some more tests and reporting back....
>>
>>
>> Mark
>>
>> On Tue, Nov 3, 2009 at 4:58 AM, Neil Brown <neilb@suse.de> wrote:
>>     
>>> On Saturday October 31, markdelfman@googlemail.com wrote:
>>>       
>>>> I am hopeful that you or another member of this group could offer some
>>>> advice / patch to implement the print options you suggested... if so i
>>>> would happily allocated resource and time to do what i can to help
>>>> with this.
>>>>         
>>> I've spent a little while exploring this.
>>> It appears to very definitely be an XFS problem, interacting in
>>> interesting ways with the VM.
>>>
>>> I built a 4-drive raid6 and did some simple testing on 2.6.28.5 and
>>> 2.6.28.6 using each of xfs and ext2.
>>>
>>> ext2 gives write throughput of 65MB/sec on .5 and 66MB/sec on .6
>>> xfs gives 86MB/sec on .5 and only 51MB/sec on .6
>>>
>>>
>>> When write_cache_pages is called it calls 'writepage' some number of
>>> times.  On ext2, writepage will write at most one page.
>>> On xfs writepage will sometimes write multiple pages.
>>>
>>> I created a patch as below that prints (in a fairly cryptic way)
>>> the number of 'writepage' calls and the number of pages that XFS
>>> actually wrote.
>>>
>>> For ext2, the number of writepage calls is at most 1536 and averages
>>> around 140
>>>
>>> For xfs with .5, there is usually only one call to writepage and it
>>> writes around 800 pages.
>>> For .6 there are about 200 calls to writepages but the achieve
>>> an average of about 700 pages together.
>>>
>>> So as you can see, there is very different behaviour.
>>>
>>> I notice a more recent patch in XFS in mainline which looks like a
>>> dirty hack to try to address this problem.
>>>
>>> I suggest you try that patch and/or take this to the XFS developers.
>>>
>>> NeilBrown
>>>
>>>
>>>
>>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>>> index 08d2b96..aa4bccc 100644
>>> --- a/mm/page-writeback.c
>>> +++ b/mm/page-writeback.c
>>> @@ -875,6 +875,8 @@ int write_cache_pages(struct address_space *mapping,
>>>        int cycled;
>>>        int range_whole = 0;
>>>        long nr_to_write = wbc->nr_to_write;
>>> +       long hidden_writes = 0;
>>> +       long clear_writes = 0;
>>>
>>>        if (wbc->nonblocking && bdi_write_congested(bdi)) {
>>>                wbc->encountered_congestion = 1;
>>> @@ -961,7 +963,11 @@ continue_unlock:
>>>                        if (!clear_page_dirty_for_io(page))
>>>                                goto continue_unlock;
>>>
>>> +                       { int orig_nr_to_write = wbc->nr_to_write;
>>>                        ret = (*writepage)(page, wbc, data);
>>> +                       hidden_writes += orig_nr_to_write - wbc->nr_to_write;
>>> +                       clear_writes ++;
>>> +                       }
>>>                        if (unlikely(ret)) {
>>>                                if (ret == AOP_WRITEPAGE_ACTIVATE) {
>>>                                        unlock_page(page);
>>> @@ -1008,12 +1014,37 @@ continue_unlock:
>>>                end = writeback_index - 1;
>>>                goto retry;
>>>        }
>>> +
>>>        if (!wbc->no_nrwrite_index_update) {
>>>                if (wbc->range_cyclic || (range_whole && nr_to_write > 0))
>>>                        mapping->writeback_index = done_index;
>>>                wbc->nr_to_write = nr_to_write;
>>>        }
>>>
>>> +       { static int sum, cnt, max;
>>> +       static unsigned long previous;
>>> +       static int sum2, max2;
>>> +
>>> +       sum += clear_writes;
>>> +       cnt += 1;
>>> +
>>> +       if (max < clear_writes) max = clear_writes;
>>> +
>>> +       sum2 += hidden_writes;
>>> +       if (max2 < hidden_writes) max2 = hidden_writes;
>>> +
>>> +       if (cnt > 100 && time_after(jiffies, previous + 10*HZ)) {
>>> +               printk("write_page_cache: sum=%d cnt=%d max=%d mean=%d sum2=%d max2=%d mean2=%d\n",
>>> +                      sum, cnt, max, sum/cnt,
>>> +                      sum2, max2, sum2/cnt);
>>> +               sum = 0;
>>> +               cnt = 0;
>>> +               max = 0;
>>> +               max2 = 0;
>>> +               sum2 = 0;
>>> +               previous = jiffies;
>>> +       }
>>> +       }
>>>        return ret;
>>>  }
>>>  EXPORT_SYMBOL(write_cache_pages);
>>>
>>>
>>> ------------------------------------------------------
>>> From c8a4051c3731b6db224482218cfd535ab9393ff8 Mon Sep 17 00:00:00 2001
>>> From: Eric Sandeen <sandeen@sandeen.net>
>>> Date: Fri, 31 Jul 2009 00:02:17 -0500
>>> Subject: [PATCH] xfs: bump up nr_to_write in xfs_vm_writepage
>>>
>>> VM calculation for nr_to_write seems off.  Bump it way
>>> up, this gets simple streaming writes zippy again.
>>> To be reviewed again after Jens' writeback changes.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@infradead.org>
>>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>>> Cc: Chris Mason <chris.mason@oracle.com>
>>> Reviewed-by: Felix Blyakher <felixb@sgi.com>
>>> Signed-off-by: Felix Blyakher <felixb@sgi.com>
>>> ---
>>>  fs/xfs/linux-2.6/xfs_aops.c |    8 ++++++++
>>>  1 files changed, 8 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
>>> index 7ec89fc..aecf251 100644
>>> --- a/fs/xfs/linux-2.6/xfs_aops.c
>>> +++ b/fs/xfs/linux-2.6/xfs_aops.c
>>> @@ -1268,6 +1268,14 @@ xfs_vm_writepage(
>>>        if (!page_has_buffers(page))
>>>                create_empty_buffers(page, 1 << inode->i_blkbits, 0);
>>>
>>> +
>>> +       /*
>>> +        *  VM calculation for nr_to_write seems off.  Bump it way
>>> +        *  up, this gets simple streaming writes zippy again.
>>> +        *  To be reviewed again after Jens' writeback changes.
>>> +        */
>>> +       wbc->nr_to_write *= 4;
>>> +
>>>        /*
>>>         * Convert delayed allocate, unwritten or unmapped space
>>>         * to real space and flush out to disk.
>>> --
>>> 1.6.4.3
>>>
>>>
>>>       

