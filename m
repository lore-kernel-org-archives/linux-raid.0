From: Marc Smith <marc.smith@mcc.edu>
Subject: Re: MD Remnants After --stop
Date: Sun, 27 Nov 2016 21:25:57 -0500
Message-ID: <CAHkw+Lc9YEdbJcRu2bOLU-gex9UYSXB32iRKD8TPS7JpjSOdQA@mail.gmail.com>
References: <CAHkw+Lf1SErbGro4bq5MM5LyB-Zqyqi4E90R7c+uAZHv1WgSrA@mail.gmail.com>
 <87fun3ond9.fsf@notabene.neil.brown.name> <CAHkw+LcfszsWDGQJzDaQU0-PsL+8K7t5msW_bLbv+YyDEFmn8Q@mail.gmail.com>
 <87fumlebwo.fsf@notabene.neil.brown.name> <CAHkw+LfN9xaFmmvg653OKh1eH=_kLdhd3Y1QMg3955TePCCtkg@mail.gmail.com>
 <CAHkw+Ldbwkknz6ZqxVpFEE-3z1r7pz1AjamUbZaEPn_uyMn_-w@mail.gmail.com>
 <878tsbcbub.fsf@notabene.neil.brown.name> <CAHkw+Ldv+-uXGCQ+tKfkraZ3VF4V8sk203+Oopm7RvygGQQYGQ@mail.gmail.com>
 <87oa15938i.fsf@notabene.neil.brown.name> <CAHkw+LfJzZoWVnO8kDi+YVV09fas2DveQoChh10wEBZfYin6aQ@mail.gmail.com>
 <8760n8a7k5.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8760n8a7k5.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Nov 27, 2016 at 5:20 PM, NeilBrown <neilb@suse.com> wrote:
> On Sun, Nov 27 2016, Marc Smith wrote:
>
>> So, I modified mdopen.c to look like this:
>>
>> --- a/mdopen.c    2016-11-25 17:04:25.782299330 -0500
>> +++ b/mdopen.c    2016-11-26 10:57:35.883621355 -0500
>> @@ -416,7 +416,7 @@
>>   */
>>  int open_mddev(char *dev, int report_errors)
>>  {
>> -    int mdfd = open(dev, O_RDWR);
>> +    int mdfd = open(dev, O_RDONLY);
>>      if (mdfd < 0 && errno == EACCES)
>>          mdfd = open(dev, O_RDONLY);
>>      if (mdfd < 0) {
>>
>>
>> And now, when running 'mdadm --stop' here is what I see...
>>
>> From the output 'udevadm monitor -pku':
>>
>> --snip--
>> KERNEL[297486.536908] offline
>> /kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e (dlm)
>> ACTION=offline
>> DEVPATH=/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e
>> LOCKSPACE=62fccfd6-605f-19e6-be6d-99a1e3cb987e
>> SEQNUM=3651
>> SUBSYSTEM=dlm
>>
>> UDEV  [297486.537541] offline
>> /kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e (dlm)
>> ACTION=offline
>> DEVPATH=/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e
>> LOCKSPACE=62fccfd6-605f-19e6-be6d-99a1e3cb987e
>> SEQNUM=3651
>> SUBSYSTEM=dlm
>> USEC_INITIALIZED=7486537404
>>
>> KERNEL[297486.538325] remove
>> /kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e (dlm)
>> ACTION=remove
>> DEVPATH=/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e
>> LOCKSPACE=62fccfd6-605f-19e6-be6d-99a1e3cb987e
>> SEQNUM=3652
>> SUBSYSTEM=dlm
>>
>> UDEV  [297486.538644] remove
>> /kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e (dlm)
>> ACTION=remove
>> DEVPATH=/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e
>> LOCKSPACE=62fccfd6-605f-19e6-be6d-99a1e3cb987e
>> SEQNUM=3652
>> SUBSYSTEM=dlm
>> USEC_INITIALIZED=86538345
>> --snip--
>>
>> And from the kernel log:
>>
>> --snip--
>> [297504.958244] md127: detected capacity change from 73340747776 to 0
>> [297504.958249] md: md127 stopped.
>> [297504.958884] dlm: 62fccfd6-605f-19e6-be6d-99a1e3cb987e: leaving the
>> lockspace group...
>> [297504.959004] udevd[487]: seq 3651 queued, 'offline' 'dlm'
>> [297504.959161] udevd[487]: seq 3651 forked new worker [5392]
>> [297504.959417] udevd[5392]: seq 3651 running
>> [297504.959474] udevd[5392]: no db file to read
>> /run/udev/data/+dlm:62fccfd6-605f-19e6-be6d-99a1e3cb987e: No such file
>> or directory
>> [297504.959524] udevd[5392]: passed device to netlink monitor 0x2251c30
>> [297504.959527] udevd[5392]: seq 3651 processed
>> [297504.960101] dlm: 62fccfd6-605f-19e6-be6d-99a1e3cb987e: group event done 0 0
>> [297504.960299] dlm: 62fccfd6-605f-19e6-be6d-99a1e3cb987e:
>> release_lockspace final free
>> [297504.960329] md: unbind<dm-0>
>> [297504.960448] udevd[487]: seq 3652 queued, 'remove' 'dlm'
>> [297504.960500] udevd[487]: passed 214 byte device to netlink monitor 0x224b130
>> [297504.960584] udevd[5392]: seq 3652 running
>> [297504.960606] udevd[5392]: no db file to read
>> /run/udev/data/+dlm:62fccfd6-605f-19e6-be6d-99a1e3cb987e: No such file
>> or directory
>> [297504.967168] md: export_rdev(dm-0)
>> [297504.967231] md: unbind<dm-1>
>> [297504.975176] md: export_rdev(dm-1)
>> --snip--
>>
>> So that did get rid of the synthesized CHANGE event, but still no
>> REMOVE event. =)
>>
>> Still trying to rule-out there isn't anything strange with my Linux
>> distro / setup... but I assume even if udev was mishandling something,
>> we should still be seeing a REMOVE event on '--stop'.
>>
>
> Getting rid of the CHANGE events is good as they can muddy the waters a
> bit.
>
> The lack of a REMOVE event suggests that something it still holding a
> reference to the 'md' kobject.  There aren't many references though.
> One is held when the array is active.  That is dropped by
> mddev_delayed_delete() which is called from a work-queue.  So it can be
> delayed a little bit, but not much.
> The other references are held by member devices, and dropped when the
> devices are unbound from the array - and the kernel log shows the
> "unbind" messages.
>
> In either case, if there is a reference outstanding, there should be
> some evidence in the /sys/mdXX/md directory.  Either a 'dev-XX'
> directory or the various bitmap attributes..
>
> Can you report the result of
>
>   find /sys/block/md127/md
> and
>   find /sys/block/md127/md -type file | xargs grep .
>
> after stopping the array?

# find /sys/block/md127/md
/sys/block/md127/md
/sys/block/md127/md/reshape_position
/sys/block/md127/md/layout
/sys/block/md127/md/raid_disks
/sys/block/md127/md/bitmap
/sys/block/md127/md/bitmap/chunksize
/sys/block/md127/md/bitmap/space
/sys/block/md127/md/bitmap/can_clear
/sys/block/md127/md/bitmap/time_base
/sys/block/md127/md/bitmap/metadata
/sys/block/md127/md/bitmap/backlog
/sys/block/md127/md/bitmap/location
/sys/block/md127/md/bitmap/max_backlog_used
/sys/block/md127/md/array_size
/sys/block/md127/md/max_read_errors
/sys/block/md127/md/metadata_version
/sys/block/md127/md/component_size
/sys/block/md127/md/reshape_direction
/sys/block/md127/md/resync_start
/sys/block/md127/md/new_dev
/sys/block/md127/md/safe_mode_delay
/sys/block/md127/md/level
/sys/block/md127/md/chunk_size
/sys/block/md127/md/array_state


# find /sys/block/md127/md -type f | xargs grep .
/sys/block/md127/md/reshape_position:none
/sys/block/md127/md/layout:0
/sys/block/md127/md/bitmap/chunksize:0
/sys/block/md127/md/bitmap/space:0
/sys/block/md127/md/bitmap/time_base:0
/sys/block/md127/md/bitmap/metadata:internal
/sys/block/md127/md/bitmap/backlog:0
/sys/block/md127/md/bitmap/location:none
/sys/block/md127/md/bitmap/max_backlog_used:0
/sys/block/md127/md/array_size:default
/sys/block/md127/md/max_read_errors:20
/sys/block/md127/md/metadata_version:none
/sys/block/md127/md/component_size:0
/sys/block/md127/md/reshape_direction:forwards
/sys/block/md127/md/resync_start:0
grep: /sys/block/md127/md/new_dev: Permission denied
/sys/block/md127/md/safe_mode_delay:0.000
/sys/block/md127/md/chunk_size:0
/sys/block/md127/md/array_state:clear


--Marc

>
> Thanks,
> NeilBrown
