From: NeilBrown <neilb@suse.com>
Subject: Re: MD Remnants After --stop
Date: Fri, 02 Dec 2016 09:35:44 +1100
Message-ID: <87k2bj6zwf.fsf@notabene.neil.brown.name>
References: <CAHkw+Lf1SErbGro4bq5MM5LyB-Zqyqi4E90R7c+uAZHv1WgSrA@mail.gmail.com> <87fun3ond9.fsf@notabene.neil.brown.name> <CAHkw+LcfszsWDGQJzDaQU0-PsL+8K7t5msW_bLbv+YyDEFmn8Q@mail.gmail.com> <87fumlebwo.fsf@notabene.neil.brown.name> <CAHkw+LfN9xaFmmvg653OKh1eH=_kLdhd3Y1QMg3955TePCCtkg@mail.gmail.com> <CAHkw+Ldbwkknz6ZqxVpFEE-3z1r7pz1AjamUbZaEPn_uyMn_-w@mail.gmail.com> <878tsbcbub.fsf@notabene.neil.brown.name> <CAHkw+Ldv+-uXGCQ+tKfkraZ3VF4V8sk203+Oopm7RvygGQQYGQ@mail.gmail.com> <87oa15938i.fsf@notabene.neil.brown.name> <CAHkw+LfJzZoWVnO8kDi+YVV09fas2DveQoChh10wEBZfYin6aQ@mail.gmail.com> <8760n8a7k5.fsf@notabene.neil.brown.name> <CAHkw+Lc9YEdbJcRu2bOLU-gex9UYSXB32iRKD8TPS7JpjSOdQA@mail.gmail.com> <87shq8743j.fsf@notabene.neil.brown.name> <CAHkw+LfmEyY8CSumeeftOrcYKzbkumHwtfeTuT0DhHZbaxdUSw@
 mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHkw+LfmEyY8CSumeeftOrcYKzbkumHwtfeTuT0DhHZbaxdUSw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marc Smith <marc.smith@mcc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Dec 02 2016, Marc Smith wrote:

> On Wed, Nov 30, 2016 at 9:52 PM, NeilBrown <neilb@suse.com> wrote:
>> On Mon, Nov 28 2016, Marc Smith wrote:
>>
>>>
>>> # find /sys/block/md127/md
>>> /sys/block/md127/md
>>> /sys/block/md127/md/reshape_position
>>> /sys/block/md127/md/layout
>>> /sys/block/md127/md/raid_disks
>>> /sys/block/md127/md/bitmap
>>> /sys/block/md127/md/bitmap/chunksize
>>
>> This tells me that:
>>         sysfs_remove_group(&mddev->kobj, &md_bitmap_group);
>> hasn't been run, so mddev_delayed_delete() hasn't run.
>> That suggests the final mddev_put() hsn't run. i.e. mddev->active is > 0
>>
>> Everything else suggests that array has been stopped and cleaned and
>> should be gone...
>>
>> This seems to suggest that there is an unbalanced mddev_get() without a
>> matching mddev_put().  I cannot find it though.
>>
>> If I could reproduce it, I would try to see what is happening by:
>>
>> - putting
>>    printk("mddev->active = %d\n", atomic_read(&mddev->active));
>>  in the top of mddev_put().  That shouldn't be *too* noisy.
>>
>> - putting
>>    printk("rd=%d empty=%d ctime=%d hold=%d\n", mddev->raid_disks,
>>         list_empty(&mddev->disks), mddev->ctime, mddev->hold_active);
>>
>>   in mddev_put() just before those values are tested.
>>
>>  - putting
>>      printk("queue_work\n");
>>    just before the 'queue_work()' call in mddev_put.
>>
>>  - putting
>>      printk("mddev_delayed_delete\n");
>>    in mddev_delayed_delete()
>>
>> Then see what gets printed when you stop the array.
>
> I made those modifications to md.c and here is the kernel log when stopping:
>
> --snip--
> [ 3937.233487] mddev->active = 2
> [ 3937.233503] mddev->active = 2
> [ 3937.233509] mddev->active = 2
> [ 3937.233516] mddev->active = 1
> [ 3937.233516] rd=2 empty=0 ctime=1480617270 hold=0

At this point, mdadm has opened the /dev/md127 device, accessed a few
attributes via sysfs just to check on the status, and then closed it
again.
The array is still active, but we know that no other process has it
open.


> [ 3937.233679] udevd[492]: inotify event: 8 for /dev/md127
> [ 3937.241489] md127: detected capacity change from 73340747776 to 0
> [ 3937.241493] md: md127 stopped.

Now mdadm has opened the array again and issued the STOP_ARRAY ioctl.
Still nothing else has the array open.

> [ 3937.241665] udevd[492]: device /dev/md127 closed, synthesising 'change'
> [ 3937.241726] udevd[492]: seq 3631 queued, 'change' 'block'
> [ 3937.241829] udevd[492]: seq 3631 forked new worker [4991]
> [ 3937.241989] udevd[4991]: seq 3631 running
> [ 3937.242002] dlm: dc18e34c-b136-1964-1c34-4509a7c60a19: leaving the
> lockspace group...
> [ 3937.242039] udevd[4991]: removing watch on '/dev/md127'
> [ 3937.242068] mddev->active = 3

But somehow the ->active count got up to 3.
mdadm probably still has it open, but two other things do too.
If you have "mdadm --monitor" running in the background (which is good)
it will temporarily increase, then decrease the count.
udevd opens the device temporarily too.
So this isn't necessarily a problem.

> [ 3937.242069] udevd[492]: seq 3632 queued, 'offline' 'dlm'
> [ 3937.242080] mddev->active = 3
> [ 3937.242104] udevd[4991]: IMPORT 'probe-bcache -o udev /dev/md127'
> /usr/lib/udev/rules.d/69-bcache.rules:16
> [ 3937.242161] udevd[492]: seq 3632 forked new worker [4992]
> [ 3937.242259] udevd[4993]: starting 'probe-bcache -o udev /dev/md127'
> [ 3937.242753] dlm: dc18e34c-b136-1964-1c34-4509a7c60a19: group event done 0 0
> [ 3937.242847] dlm: dc18e34c-b136-1964-1c34-4509a7c60a19:
> release_lockspace final free
> [ 3937.242861] md: unbind<dm-1>
> [ 3937.256606] md: export_rdev(dm-1)
> [ 3937.256612] md: unbind<dm-0>
> [ 3937.263601] md: export_rdev(dm-0)
> [ 3937.263688] mddev->active = 4
> [ 3937.263751] mddev->active = 3

But here, the active count only drops down to 2. (it is decremented
after it is printed).  Assuming there really were no more messages like
this, there are two active references to the md device, and we don't
know what they are.

>
> I didn't use my modified mdadm which stops the synthesized CHANGE from
> occurring, but if needed, I can re-run the test using that.

It would be good to use the modified mdadm, if only to reduce the
noise.  It won't change the end result, but might make it easier to see
what is happening.
Also please add
   WARN_ON(1);

in the start of mddev_get() and mddev_put().
That will provide a stack trace whenever either of these are called, so
we can see who takes a references, and who doesn't release it.

Thanks,
NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhApcEACgkQOeye3VZi
gblz6BAAj8id7Aiuce/JyV4bXHm5ridfL1M4/w/5EMxwhmh3Ekx0Q+xlV0btwWv9
zlW8iVTZ7PMjl9iW8HkGorTbC49gY+HQzyoUf1A88zSG3GlRKKIvI1emksQJyJZc
X8LIEjeRtlToQM10nROrbo1Z1LlKCLfA9q8f6Mf+A6T0Q1hVzIUvUTm9huYwwMhH
RBpC3QmjaVW3O57wITL/oWYrJ/fj3MiB1fUWPtq0qP9GaGFFjpje3cWCqxkjiW7T
OMoUpAUi3E6R0cRIdSJtVNxmGj3rhA1ss/x8v/QL5ZKDJZkT8vre1puFBI1xZAPw
BjPyAN5eTAFtyYiru+X4r/KiKNF/gfJM75LUA/GYDTKe5wDClgXg+OsWYzKaARp8
2bYIz5XBNh6qA1ucg2pP/Oxi003Ahh82GUisxB86xiUOGyuYO8ooiLZilLQ++zp4
3GPY/xrV6G290b6Br/DgPok6kuU/xLJ0jWWGHW+yUlN4gAX/gEVZdXW+zAnTZ+ud
DQlelLlzfXjEjHrv6GFTKsHftjJB2KH2Pjz//KIv6jSFO7of0ZcI4/kAcW0UiVjI
AtTC8BFlVHLk3elW0t++sjrd7gYT3O0IiHwvfrm7cxw4C+5vjoagHmlOIO/9XkAf
hfJms7c452+KsxyTAn2g8O966gX8VbV6+2MSjdlvFHApFa9BUTM=
=ACRD
-----END PGP SIGNATURE-----
--=-=-=--
