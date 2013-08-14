From: Jack Wang <jinpu.wang@profitbricks.com>
Subject: Re: [BUG] md hang at schedule in  md_write_start
Date: Wed, 14 Aug 2013 10:09:29 +0200
Message-ID: <520B3B39.4060703@profitbricks.com>
References: <52090E6D.10104@profitbricks.com> <20130813143115.55dd27d1@notabene.brown> <5209E37D.6050107@profitbricks.com> <20130814104410.10bb2259@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130814104410.10bb2259@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Jack Wang <xjtuwjp@gmail.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>
List-Id: linux-raid.ids

On 08/14/2013 02:44 AM, NeilBrown wrote:
> On Tue, 13 Aug 2013 09:42:53 +0200 Jack Wang <jinpu.wang@profitbricks.com>
> wrote:
> 
>> On 08/13/2013 06:31 AM, NeilBrown wrote:
>>> On Mon, 12 Aug 2013 18:33:49 +0200 Jack Wang <jinpu.wang@profitbricks.com>
>>> wrote:
>>>
>>>> Hi Neil,
>>>>
>>>>
>>>> We've found md hang in our test, it's easy to reproduce with script
>>>> attached.
>>>>
>>>> We've tried 3.4 stable kernel and latest mainline, it still exists.
>>>>
>>>> Looks like flush bdi_writeback_workfn race with md_stop, no idea how to
>>>> fix it, could you kindly give us suggestions?
>>>>
>>>> Best regards,
>>>> Jack
>>>
>>> Thanks for the report.  I can see how that deadlock could happen.
>>>
>>> Can you please try this patch and confirm that it fixes it.
>>> I'm not really happy with this approach but nothing better occurs to me yet.
>>>
>>> NeilBrown
>>>
>>
>> Hi Neil,
>>
>> Thanks for quick fix, I tested on 3.4 stable and mainline, it works now.
>> Could you give more description about the bug and fix.
>>
> Thanks for testing.
> 
> The problem:
>  If you open a block device (e.g. /dev/md0) and write to it the writes will
>  be buffered in the page cache until an 'fsync' or similar.
>  When the last open file descriptor on the block device is closed, that
>  triggers a flush even if there was no fsync.
>  So if you
>     dd > /dev/md0
>     mdadm --stop /dev/md0
>  The 'close' that happens when dd exits will flush the cache.  So when mdadm
>  opens /dev/md0 the cache will be empty.  This is the normal situation.
> 
>  However if "mdadm --stop /dev/md0" open /dev/md0 before 'dd' exits, then
>  nothing will trigger the flush and that causes problems as I'll get to in a
>  minute.
>  Normally if this happened, mdadm would call the STOP_ARRAY ioctl which would
>  notice that there is an extra open (from dd) and would abort.
>  However "mdadm -S" retries a few times if it confirmed that the array wasn't
>  mounted.  Eventually it opens just before 'dd' closes.  The presence of the
>  "mdadm -D" might affect this - it might hold a lock that "mdadm -S" waits a
>  little while for.
> 
>  Anyway by the time that "mdadm --stop" has called STOP_ARRAY on the open
>  file descriptor and got to do_md_stop() it is holding ->reconfig_mutex
>  (because md_ioctl() calls mddev_lock()).
>  While holding this mutex it calls sync_blockdev() to ensure the page cache
>  is flushed.  This is where the problem occurs.
>  If the array is currently marked 'clean' and there a dirty pages in the page
>  cache, md_write_start() while request that the superblock be marked 'dirty'.
>  This is handled by md_check_recovery() which is called by the array
>  managment thread.  However it will only update the superblock if it can get
>  ->reconfig_mutex.
> 
>  So the "mdadm --stop" thread is holding ->reconfig_mutex and waiting for
>  dirty data to be flushed.  The flush thread is waiting for the superblock
>  the be updated by the array management thread.  The array management thread
>  won't update the superblock until it can get ->reconfig_mutex.
>  i.e. a deadlock.
> 
>  One way to "fix" it would be to call md_allow_write() in do_md_stop() before
>  calling sync_blockdev().  This would remove the deadlock, but would often
>  modify the superblock unnecessarily.
> 
>  I would be nice if I could check beforehand if sync_blockdev() will actually
>  write anything and then call md_allow_write() if it would.  But I don't
>  think that is possible.
> 
>  So the approach I took in the patch I gave you was to set a flag in
>  do_md_stop to tell md_check_recovery() that it was ok to update the
>  superblock without holding a lock, because the lock is already held.
>  I don't really like that though.  It feels like it should be racy.
> 
>  I could call sync_blockdev() *before* taking the ->reconfig_mutex but that
>  would be racy as another process could theoretically write after the
>  sync_blockdev, and close before do_md_stop() checks for other opens....
> 
>  However maybe I could make use for ->open_mutex.  This guards opening and
>  destroying of the array, which are the issue here.
> 
>  Before the mddev_lock() in md_ioctl() I could (in the STOP_ARRAY case)
>     lock ->open_mutex
>     check that mddev->openers is 1 - abort if not
>     set a flag
>     release ->open_mutex
>     call sync_blockdev.
> 
>  Then in md_open()
>     after getting ->open_mutex, clear the flag.
> 
>  Then in do_md_stop()
>     after getting ->open_mutex, if the flag is set, abort with EBUSY.
> 
>  This would ensure that the page cache is not dirty when do_md_stop decides
>  to stop the array by flushing it early and making sure no-one else can open
>  it.
> 
>  I think I like this approach better.
> 
>  Could you retry the following patch instead?
> 
> Thanks
> NeilBrown

Thanks Neil for informative description:), it is really helpful.
I tried you new patch, it also works as expected.

Best regards,
Jack


