From: Marc Smith <marc.smith@mcc.edu>
Subject: Re: MD Remnants After --stop
Date: Sat, 26 Nov 2016 11:41:36 -0500
Message-ID: <CAHkw+LfJzZoWVnO8kDi+YVV09fas2DveQoChh10wEBZfYin6aQ@mail.gmail.com>
References: <CAHkw+Lf1SErbGro4bq5MM5LyB-Zqyqi4E90R7c+uAZHv1WgSrA@mail.gmail.com>
 <87fun3ond9.fsf@notabene.neil.brown.name> <CAHkw+LcfszsWDGQJzDaQU0-PsL+8K7t5msW_bLbv+YyDEFmn8Q@mail.gmail.com>
 <87fumlebwo.fsf@notabene.neil.brown.name> <CAHkw+LfN9xaFmmvg653OKh1eH=_kLdhd3Y1QMg3955TePCCtkg@mail.gmail.com>
 <CAHkw+Ldbwkknz6ZqxVpFEE-3z1r7pz1AjamUbZaEPn_uyMn_-w@mail.gmail.com>
 <878tsbcbub.fsf@notabene.neil.brown.name> <CAHkw+Ldv+-uXGCQ+tKfkraZ3VF4V8sk203+Oopm7RvygGQQYGQ@mail.gmail.com>
 <87oa15938i.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87oa15938i.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So, I modified mdopen.c to look like this:

--- a/mdopen.c    2016-11-25 17:04:25.782299330 -0500
+++ b/mdopen.c    2016-11-26 10:57:35.883621355 -0500
@@ -416,7 +416,7 @@
  */
 int open_mddev(char *dev, int report_errors)
 {
-    int mdfd = open(dev, O_RDWR);
+    int mdfd = open(dev, O_RDONLY);
     if (mdfd < 0 && errno == EACCES)
         mdfd = open(dev, O_RDONLY);
     if (mdfd < 0) {


And now, when running 'mdadm --stop' here is what I see...

From the output 'udevadm monitor -pku':

--snip--
KERNEL[297486.536908] offline
/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e (dlm)
ACTION=offline
DEVPATH=/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e
LOCKSPACE=62fccfd6-605f-19e6-be6d-99a1e3cb987e
SEQNUM=3651
SUBSYSTEM=dlm

UDEV  [297486.537541] offline
/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e (dlm)
ACTION=offline
DEVPATH=/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e
LOCKSPACE=62fccfd6-605f-19e6-be6d-99a1e3cb987e
SEQNUM=3651
SUBSYSTEM=dlm
USEC_INITIALIZED=7486537404

KERNEL[297486.538325] remove
/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e (dlm)
ACTION=remove
DEVPATH=/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e
LOCKSPACE=62fccfd6-605f-19e6-be6d-99a1e3cb987e
SEQNUM=3652
SUBSYSTEM=dlm

UDEV  [297486.538644] remove
/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e (dlm)
ACTION=remove
DEVPATH=/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e
LOCKSPACE=62fccfd6-605f-19e6-be6d-99a1e3cb987e
SEQNUM=3652
SUBSYSTEM=dlm
USEC_INITIALIZED=86538345
--snip--

And from the kernel log:

--snip--
[297504.958244] md127: detected capacity change from 73340747776 to 0
[297504.958249] md: md127 stopped.
[297504.958884] dlm: 62fccfd6-605f-19e6-be6d-99a1e3cb987e: leaving the
lockspace group...
[297504.959004] udevd[487]: seq 3651 queued, 'offline' 'dlm'
[297504.959161] udevd[487]: seq 3651 forked new worker [5392]
[297504.959417] udevd[5392]: seq 3651 running
[297504.959474] udevd[5392]: no db file to read
/run/udev/data/+dlm:62fccfd6-605f-19e6-be6d-99a1e3cb987e: No such file
or directory
[297504.959524] udevd[5392]: passed device to netlink monitor 0x2251c30
[297504.959527] udevd[5392]: seq 3651 processed
[297504.960101] dlm: 62fccfd6-605f-19e6-be6d-99a1e3cb987e: group event done 0 0
[297504.960299] dlm: 62fccfd6-605f-19e6-be6d-99a1e3cb987e:
release_lockspace final free
[297504.960329] md: unbind<dm-0>
[297504.960448] udevd[487]: seq 3652 queued, 'remove' 'dlm'
[297504.960500] udevd[487]: passed 214 byte device to netlink monitor 0x224b130
[297504.960584] udevd[5392]: seq 3652 running
[297504.960606] udevd[5392]: no db file to read
/run/udev/data/+dlm:62fccfd6-605f-19e6-be6d-99a1e3cb987e: No such file
or directory
[297504.967168] md: export_rdev(dm-0)
[297504.967231] md: unbind<dm-1>
[297504.975176] md: export_rdev(dm-1)
--snip--

So that did get rid of the synthesized CHANGE event, but still no
REMOVE event. =)

Still trying to rule-out there isn't anything strange with my Linux
distro / setup... but I assume even if udev was mishandling something,
we should still be seeing a REMOVE event on '--stop'.


--Marc


On Wed, Nov 23, 2016 at 6:38 PM, NeilBrown <neilb@suse.com> wrote:
> On Thu, Nov 24 2016, Marc Smith wrote:
>
>> On Tue, Nov 22, 2016 at 6:51 PM, NeilBrown <neilb@suse.com> wrote:
>>> On Wed, Nov 23 2016, Marc Smith wrote:
>>>
>>>> Hi,
>>>>
>>>> Sorry, I'm not trying to beat a dead horse here, but I do feel
>>>> something has changed... I just tested with Linux 4.5.2 and when
>>>> stopping an md array (with mdadm --stop) the entry in /sys/block/ is
>>>> removed, and even the /dev/mdXXX and /dev/md/name link are removed
>>>> properly.
>>>>
>>>> When testing with Linux 4.9-rc3, the entries in /sys/block/ still
>>>> remain (array_state attribute value is "clear") after using mdadm
>>>> --stop and the /dev/mdXXX device exists (the /dev/md/name link is
>>>> removed, by udev I assume).
>>>
>>> With the latest (git) mdadm, when events are reported by "udevadm monitor"??
>>>
>>> I only see remove events, and the entries from /dev and /sys are
>>> removed.
>>>
>>> If I could reproduce your problem, I would fix it...
>>
>> On one set of hosts I can reliably reproduce this issue, and on
>> another system I could previously reproduce this, but now seems to be
>> working fine... I haven't found the connection (same distro / kernel
>> versions on all hosts).
>>
>> # mdadm --version
>> mdadm - v3.4-100-g52a9408 - 26th October 2016
>>
>>
>> From 'mdadm --stop /dev/md/blah1' (non-clustered RAID0 array):
>>
>> --snip--
>> # udevadm monitor -pku
>> calling: monitor
>> monitor will print the received events for:
>> UDEV - the event which udev sends out after rule processing
>> KERNEL - the kernel uevent
>>
>> KERNEL[32930.834312] change   /devices/virtual/block/md126 (block)
>> ACTION=change
>> DEVNAME=/dev/md126
>> DEVPATH=/devices/virtual/block/md126
>> DEVTYPE=disk
>> MAJOR=9
>> MINOR=126
>> SEQNUM=3678
>> SUBSYSTEM=block
>>
>> UDEV  [32930.836032] change   /devices/virtual/block/md126 (block)
>> ACTION=change
>> DEVNAME=/dev/md126
>> DEVPATH=/devices/virtual/block/md126
>> DEVTYPE=disk
>> MAJOR=9
>> MINOR=126
>> SEQNUM=3678
>> SUBSYSTEM=block
>> SYSTEMD_READY=0
>> USEC_INITIALIZED=843336612
>
> Using the recent version of mdadm, and a kernel newer than 4.6 (commit
> 399146b8) a CHANGE event should only be generated when the array is
> started. To see a CHANGE of stop, you must have an older mdadm or and
> older kernel.... unless something else is synthesizing a CHANGE event.
>
> When using a clustered array, you can also see a CHANGE event when a new
> disk is being added to an array.
>
>> --snip--
>>
>> Kernel logs from that:
>> --snip--
>> [32928.465695] md126: detected capacity change from 146681102336 to 0
>> [32928.465699] md: md126 stopped.
>> [32928.465702] md: unbind<dm-3>
>> [32928.465798] udevd[499]: inotify event: 8 for /dev/md126
>> [32928.465964] udevd[499]: device /dev/md126 closed, synthesising 'change'
>> [32928.466029] udevd[499]: seq 3678 queued, 'change' 'block'
>> [32928.466129] udevd[499]: seq 3678 forked new worker [27035]
>> [32928.466357] udevd[27035]: seq 3678 running
>> [32928.466423] udevd[27035]: removing watch on '/dev/md126'
>> [32928.466492] udevd[27035]: IMPORT 'probe-bcache -o udev /dev/md126'
>> /usr/lib/udev/rules.d/69-bcache.rules:16
>> [32928.466712] udevd[27036]: starting 'probe-bcache -o udev /dev/md126'
>> [32928.467540] udevd[27035]: 'probe-bcache -o udev /dev/md126' [27036]
>> exit with return code 0
>> [32928.467564] udevd[27035]: update old name,
>> '/dev/disk/by-id/md-name-tgtnode1.parodyne.com:blah1' no longer
>> belonging to '/devices/virtual/block/md126'
>> [32928.470851] md: export_rdev(dm-3)
>> [32928.470920] md: unbind<dm-2>
>> [32928.478843] md: export_rdev(dm-2)
>> --snip--
>>
>>
>> From 'mdadm --stop /dev/md/asdf1' (clustered RAID1 array):
>>
>> --snip--
>> # udevadm monitor -pku
>> calling: monitor
>> monitor will print the received events for:
>> UDEV - the event which udev sends out after rule processing
>> KERNEL - the kernel uevent
>>
>> KERNEL[34402.247229] change   /devices/virtual/block/md127 (block)
>> ACTION=change
>> DEVNAME=/dev/md127
>> DEVPATH=/devices/virtual/block/md127
>> DEVTYPE=disk
>> MAJOR=9
>> MINOR=127
>> SEQNUM=3679
>> SUBSYSTEM=block
>>
>> KERNEL[34402.247885] offline
>> /kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e (dlm)
>> ACTION=offline
>> DEVPATH=/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e
>> LOCKSPACE=62fccfd6-605f-19e6-be6d-99a1e3cb987e
>> SEQNUM=3680
>> SUBSYSTEM=dlm
>>
>> UDEV  [34402.248269] offline
>> /kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e (dlm)
>> ACTION=offline
>> DEVPATH=/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e
>> LOCKSPACE=62fccfd6-605f-19e6-be6d-99a1e3cb987e
>> SEQNUM=3680
>> SUBSYSTEM=dlm
>> USEC_INITIALIZED=402248230
>>
>> KERNEL[34402.248841] remove
>> /kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e (dlm)
>> ACTION=remove
>> DEVPATH=/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e
>> LOCKSPACE=62fccfd6-605f-19e6-be6d-99a1e3cb987e
>> SEQNUM=3681
>> SUBSYSTEM=dlm
>>
>> UDEV  [34402.248899] change   /devices/virtual/block/md127 (block)
>> ACTION=change
>> DEVNAME=/dev/md127
>> DEVPATH=/devices/virtual/block/md127
>> DEVTYPE=disk
>> MAJOR=9
>> MINOR=127
>> SEQNUM=3679
>> SUBSYSTEM=block
>> SYSTEMD_READY=0
>> USEC_INITIALIZED=1273670
>>
>> UDEV  [34402.248990] remove
>> /kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e (dlm)
>> ACTION=remove
>> DEVPATH=/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e
>> LOCKSPACE=62fccfd6-605f-19e6-be6d-99a1e3cb987e
>> SEQNUM=3681
>> SUBSYSTEM=dlm
>> USEC_INITIALIZED=2248905
>> --snip--
>>
>>
>> Kernel logs from that:
>> --snip--
>> [34399.753876] udevd[499]: inotify event: 8 for /dev/md127
>> [34399.765389] md127: detected capacity change from 73340747776 to 0
>> [34399.765393] md: md127 stopped.
>> [34399.765579] udevd[499]: device /dev/md127 closed, synthesising 'change'
>
> That is weird.  udev is synthesizing a CHANGE event.  How nice of it
> (not!).
> It doesn't do this for dm, only other devices.
>
> This happens when an open-for-write is closed.
> If you edit mdopen.c and change the O_RDWR in open_mddev() to O_RDONLY,
> this change will go away.
>
>
>> [34399.765656] udevd[499]: seq 3679 queued, 'change' 'block'
>> [34399.765751] udevd[499]: seq 3679 forked new worker [6317]
>> [34399.765878] udevd[6317]: seq 3679 running
>> [34399.765943] udevd[6317]: removing watch on '/dev/md127'
>> [34399.766012] udevd[6317]: IMPORT 'probe-bcache -o udev /dev/md127'
>> /usr/lib/udev/rules.d/69-bcache.rules:16
>> [34399.766259] udevd[6318]: starting 'probe-bcache -o udev /dev/md127'
>> [34399.766295] dlm: 62fccfd6-605f-19e6-be6d-99a1e3cb987e: leaving the
>> lockspace group...
>> [34399.766421] udevd[499]: seq 3680 queued, 'offline' 'dlm'
>> [34399.766549] udevd[499]: seq 3680 forked new worker [6319]
>> [34399.767080] dlm: 62fccfd6-605f-19e6-be6d-99a1e3cb987e: group event done 0 0
>> [34399.767297] dlm: 62fccfd6-605f-19e6-be6d-99a1e3cb987e:
>> release_lockspace final free
>> [34399.767320] md: unbind<dm-1>
>> [34399.795574] md: export_rdev(dm-1)
>> [34399.795640] md: unbind<dm-0>
>> [34399.803565] md: export_rdev(dm-0)
>> --snip--
>>
>>
>> On the other machines where the md array stopped correctly (removing
>> the entries from /dev and /sys) I do see the 'remove' events with
>> "udevadm monitor". What produces those remove events? Is that
>> something directly from the mdadm tool, or indirectly as part of the
>> stop/tear-down that mdadm initiates?
>
> REMOVE events are generated by
>
> md_free() -> del_gendisk() ->  blk_unregister_queue()
>
> which should happen when the md object is finally released.
> If there is no CHANGE event, then nothing should stop this from
> happening.
>
> NeilBrown
