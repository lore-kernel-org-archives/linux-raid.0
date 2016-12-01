From: Marc Smith <marc.smith@mcc.edu>
Subject: Re: MD Remnants After --stop
Date: Thu, 1 Dec 2016 14:40:55 -0500
Message-ID: <CAHkw+LfmEyY8CSumeeftOrcYKzbkumHwtfeTuT0DhHZbaxdUSw@mail.gmail.com>
References: <CAHkw+Lf1SErbGro4bq5MM5LyB-Zqyqi4E90R7c+uAZHv1WgSrA@mail.gmail.com>
 <87fun3ond9.fsf@notabene.neil.brown.name> <CAHkw+LcfszsWDGQJzDaQU0-PsL+8K7t5msW_bLbv+YyDEFmn8Q@mail.gmail.com>
 <87fumlebwo.fsf@notabene.neil.brown.name> <CAHkw+LfN9xaFmmvg653OKh1eH=_kLdhd3Y1QMg3955TePCCtkg@mail.gmail.com>
 <CAHkw+Ldbwkknz6ZqxVpFEE-3z1r7pz1AjamUbZaEPn_uyMn_-w@mail.gmail.com>
 <878tsbcbub.fsf@notabene.neil.brown.name> <CAHkw+Ldv+-uXGCQ+tKfkraZ3VF4V8sk203+Oopm7RvygGQQYGQ@mail.gmail.com>
 <87oa15938i.fsf@notabene.neil.brown.name> <CAHkw+LfJzZoWVnO8kDi+YVV09fas2DveQoChh10wEBZfYin6aQ@mail.gmail.com>
 <8760n8a7k5.fsf@notabene.neil.brown.name> <CAHkw+Lc9YEdbJcRu2bOLU-gex9UYSXB32iRKD8TPS7JpjSOdQA@mail.gmail.com>
 <87shq8743j.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87shq8743j.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 30, 2016 at 9:52 PM, NeilBrown <neilb@suse.com> wrote:
> On Mon, Nov 28 2016, Marc Smith wrote:
>
>>
>> # find /sys/block/md127/md
>> /sys/block/md127/md
>> /sys/block/md127/md/reshape_position
>> /sys/block/md127/md/layout
>> /sys/block/md127/md/raid_disks
>> /sys/block/md127/md/bitmap
>> /sys/block/md127/md/bitmap/chunksize
>
> This tells me that:
>         sysfs_remove_group(&mddev->kobj, &md_bitmap_group);
> hasn't been run, so mddev_delayed_delete() hasn't run.
> That suggests the final mddev_put() hsn't run. i.e. mddev->active is > 0
>
> Everything else suggests that array has been stopped and cleaned and
> should be gone...
>
> This seems to suggest that there is an unbalanced mddev_get() without a
> matching mddev_put().  I cannot find it though.
>
> If I could reproduce it, I would try to see what is happening by:
>
> - putting
>    printk("mddev->active = %d\n", atomic_read(&mddev->active));
>  in the top of mddev_put().  That shouldn't be *too* noisy.
>
> - putting
>    printk("rd=%d empty=%d ctime=%d hold=%d\n", mddev->raid_disks,
>         list_empty(&mddev->disks), mddev->ctime, mddev->hold_active);
>
>   in mddev_put() just before those values are tested.
>
>  - putting
>      printk("queue_work\n");
>    just before the 'queue_work()' call in mddev_put.
>
>  - putting
>      printk("mddev_delayed_delete\n");
>    in mddev_delayed_delete()
>
> Then see what gets printed when you stop the array.

I made those modifications to md.c and here is the kernel log when stopping:

--snip--
[ 3937.233487] mddev->active = 2
[ 3937.233503] mddev->active = 2
[ 3937.233509] mddev->active = 2
[ 3937.233516] mddev->active = 1
[ 3937.233516] rd=2 empty=0 ctime=1480617270 hold=0
[ 3937.233679] udevd[492]: inotify event: 8 for /dev/md127
[ 3937.241489] md127: detected capacity change from 73340747776 to 0
[ 3937.241493] md: md127 stopped.
[ 3937.241665] udevd[492]: device /dev/md127 closed, synthesising 'change'
[ 3937.241726] udevd[492]: seq 3631 queued, 'change' 'block'
[ 3937.241829] udevd[492]: seq 3631 forked new worker [4991]
[ 3937.241989] udevd[4991]: seq 3631 running
[ 3937.242002] dlm: dc18e34c-b136-1964-1c34-4509a7c60a19: leaving the
lockspace group...
[ 3937.242039] udevd[4991]: removing watch on '/dev/md127'
[ 3937.242068] mddev->active = 3
[ 3937.242069] udevd[492]: seq 3632 queued, 'offline' 'dlm'
[ 3937.242080] mddev->active = 3
[ 3937.242104] udevd[4991]: IMPORT 'probe-bcache -o udev /dev/md127'
/usr/lib/udev/rules.d/69-bcache.rules:16
[ 3937.242161] udevd[492]: seq 3632 forked new worker [4992]
[ 3937.242259] udevd[4993]: starting 'probe-bcache -o udev /dev/md127'
[ 3937.242753] dlm: dc18e34c-b136-1964-1c34-4509a7c60a19: group event done 0 0
[ 3937.242847] dlm: dc18e34c-b136-1964-1c34-4509a7c60a19:
release_lockspace final free
[ 3937.242861] md: unbind<dm-1>
[ 3937.256606] md: export_rdev(dm-1)
[ 3937.256612] md: unbind<dm-0>
[ 3937.263601] md: export_rdev(dm-0)
[ 3937.263688] mddev->active = 4
[ 3937.263751] mddev->active = 3
--snip--

I didn't use my modified mdadm which stops the synthesized CHANGE from
occurring, but if needed, I can re-run the test using that.

I don't see any of the "queue_work" or "mddev_delayed_delete" messages
anywhere in the kernel logs. Here is how those monitoring lines are
set in md.c:

--snip--
static void mddev_put(struct mddev *mddev)
{
        struct bio_set *bs = NULL;
        printk("mddev->active = %d\n", atomic_read(&mddev->active));
        if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
                return;
        printk("rd=%d empty=%d ctime=%d hold=%d\n", mddev->raid_disks,
                list_empty(&mddev->disks), mddev->ctime, mddev->hold_active);
        if (!mddev->raid_disks && list_empty(&mddev->disks) &&
            mddev->ctime == 0 && !mddev->hold_active) {
                /* Array is not configured at all, and not held active,
                 * so destroy it */
                list_del_init(&mddev->all_mddevs);
                bs = mddev->bio_set;
                mddev->bio_set = NULL;
                if (mddev->gendisk) {
                        /* We did a probe so need to clean up.  Call
                         * queue_work inside the spinlock so that
                         * flush_workqueue() after mddev_find will
                         * succeed in waiting for the work to be done.
                         */
                        INIT_WORK(&mddev->del_work, mddev_delayed_delete);
                        printk("queue_work\n");
                        queue_work(md_misc_wq, &mddev->del_work);
                } else
                        kfree(mddev);
        }
        spin_unlock(&all_mddevs_lock);
        if (bs)
                bioset_free(bs);
}
--snip--

--snip--
static void mddev_delayed_delete(struct work_struct *ws)
{
        struct mddev *mddev = container_of(ws, struct mddev, del_work);
        printk("mddev_delayed_delete\n");
        sysfs_remove_group(&mddev->kobj, &md_bitmap_group);
        kobject_del(&mddev->kobj);
        kobject_put(&mddev->kobj);
}
--snip--

Let me know if the printk() lines weren't placed in the proper spots
and I'll fix and re-run the test. Thanks for your time.


--Marc


>
> NeilBrown
