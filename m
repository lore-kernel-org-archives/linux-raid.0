From: Marc Smith <marc.smith@mcc.edu>
Subject: Re: MD Remnants After --stop
Date: Wed, 23 Nov 2016 10:21:47 -0500
Message-ID: <CAHkw+Ldv+-uXGCQ+tKfkraZ3VF4V8sk203+Oopm7RvygGQQYGQ@mail.gmail.com>
References: <CAHkw+Lf1SErbGro4bq5MM5LyB-Zqyqi4E90R7c+uAZHv1WgSrA@mail.gmail.com>
 <87fun3ond9.fsf@notabene.neil.brown.name> <CAHkw+LcfszsWDGQJzDaQU0-PsL+8K7t5msW_bLbv+YyDEFmn8Q@mail.gmail.com>
 <87fumlebwo.fsf@notabene.neil.brown.name> <CAHkw+LfN9xaFmmvg653OKh1eH=_kLdhd3Y1QMg3955TePCCtkg@mail.gmail.com>
 <CAHkw+Ldbwkknz6ZqxVpFEE-3z1r7pz1AjamUbZaEPn_uyMn_-w@mail.gmail.com> <878tsbcbub.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <878tsbcbub.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 22, 2016 at 6:51 PM, NeilBrown <neilb@suse.com> wrote:
> On Wed, Nov 23 2016, Marc Smith wrote:
>
>> Hi,
>>
>> Sorry, I'm not trying to beat a dead horse here, but I do feel
>> something has changed... I just tested with Linux 4.5.2 and when
>> stopping an md array (with mdadm --stop) the entry in /sys/block/ is
>> removed, and even the /dev/mdXXX and /dev/md/name link are removed
>> properly.
>>
>> When testing with Linux 4.9-rc3, the entries in /sys/block/ still
>> remain (array_state attribute value is "clear") after using mdadm
>> --stop and the /dev/mdXXX device exists (the /dev/md/name link is
>> removed, by udev I assume).
>
> With the latest (git) mdadm, when events are reported by "udevadm monitor"??
>
> I only see remove events, and the entries from /dev and /sys are
> removed.
>
> If I could reproduce your problem, I would fix it...

On one set of hosts I can reliably reproduce this issue, and on
another system I could previously reproduce this, but now seems to be
working fine... I haven't found the connection (same distro / kernel
versions on all hosts).

# mdadm --version
mdadm - v3.4-100-g52a9408 - 26th October 2016


From 'mdadm --stop /dev/md/blah1' (non-clustered RAID0 array):

--snip--
# udevadm monitor -pku
calling: monitor
monitor will print the received events for:
UDEV - the event which udev sends out after rule processing
KERNEL - the kernel uevent

KERNEL[32930.834312] change   /devices/virtual/block/md126 (block)
ACTION=change
DEVNAME=/dev/md126
DEVPATH=/devices/virtual/block/md126
DEVTYPE=disk
MAJOR=9
MINOR=126
SEQNUM=3678
SUBSYSTEM=block

UDEV  [32930.836032] change   /devices/virtual/block/md126 (block)
ACTION=change
DEVNAME=/dev/md126
DEVPATH=/devices/virtual/block/md126
DEVTYPE=disk
MAJOR=9
MINOR=126
SEQNUM=3678
SUBSYSTEM=block
SYSTEMD_READY=0
USEC_INITIALIZED=843336612
--snip--

Kernel logs from that:
--snip--
[32928.465695] md126: detected capacity change from 146681102336 to 0
[32928.465699] md: md126 stopped.
[32928.465702] md: unbind<dm-3>
[32928.465798] udevd[499]: inotify event: 8 for /dev/md126
[32928.465964] udevd[499]: device /dev/md126 closed, synthesising 'change'
[32928.466029] udevd[499]: seq 3678 queued, 'change' 'block'
[32928.466129] udevd[499]: seq 3678 forked new worker [27035]
[32928.466357] udevd[27035]: seq 3678 running
[32928.466423] udevd[27035]: removing watch on '/dev/md126'
[32928.466492] udevd[27035]: IMPORT 'probe-bcache -o udev /dev/md126'
/usr/lib/udev/rules.d/69-bcache.rules:16
[32928.466712] udevd[27036]: starting 'probe-bcache -o udev /dev/md126'
[32928.467540] udevd[27035]: 'probe-bcache -o udev /dev/md126' [27036]
exit with return code 0
[32928.467564] udevd[27035]: update old name,
'/dev/disk/by-id/md-name-tgtnode1.parodyne.com:blah1' no longer
belonging to '/devices/virtual/block/md126'
[32928.470851] md: export_rdev(dm-3)
[32928.470920] md: unbind<dm-2>
[32928.478843] md: export_rdev(dm-2)
--snip--


From 'mdadm --stop /dev/md/asdf1' (clustered RAID1 array):

--snip--
# udevadm monitor -pku
calling: monitor
monitor will print the received events for:
UDEV - the event which udev sends out after rule processing
KERNEL - the kernel uevent

KERNEL[34402.247229] change   /devices/virtual/block/md127 (block)
ACTION=change
DEVNAME=/dev/md127
DEVPATH=/devices/virtual/block/md127
DEVTYPE=disk
MAJOR=9
MINOR=127
SEQNUM=3679
SUBSYSTEM=block

KERNEL[34402.247885] offline
/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e (dlm)
ACTION=offline
DEVPATH=/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e
LOCKSPACE=62fccfd6-605f-19e6-be6d-99a1e3cb987e
SEQNUM=3680
SUBSYSTEM=dlm

UDEV  [34402.248269] offline
/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e (dlm)
ACTION=offline
DEVPATH=/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e
LOCKSPACE=62fccfd6-605f-19e6-be6d-99a1e3cb987e
SEQNUM=3680
SUBSYSTEM=dlm
USEC_INITIALIZED=402248230

KERNEL[34402.248841] remove
/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e (dlm)
ACTION=remove
DEVPATH=/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e
LOCKSPACE=62fccfd6-605f-19e6-be6d-99a1e3cb987e
SEQNUM=3681
SUBSYSTEM=dlm

UDEV  [34402.248899] change   /devices/virtual/block/md127 (block)
ACTION=change
DEVNAME=/dev/md127
DEVPATH=/devices/virtual/block/md127
DEVTYPE=disk
MAJOR=9
MINOR=127
SEQNUM=3679
SUBSYSTEM=block
SYSTEMD_READY=0
USEC_INITIALIZED=1273670

UDEV  [34402.248990] remove
/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e (dlm)
ACTION=remove
DEVPATH=/kernel/dlm/62fccfd6-605f-19e6-be6d-99a1e3cb987e
LOCKSPACE=62fccfd6-605f-19e6-be6d-99a1e3cb987e
SEQNUM=3681
SUBSYSTEM=dlm
USEC_INITIALIZED=2248905
--snip--


Kernel logs from that:
--snip--
[34399.753876] udevd[499]: inotify event: 8 for /dev/md127
[34399.765389] md127: detected capacity change from 73340747776 to 0
[34399.765393] md: md127 stopped.
[34399.765579] udevd[499]: device /dev/md127 closed, synthesising 'change'
[34399.765656] udevd[499]: seq 3679 queued, 'change' 'block'
[34399.765751] udevd[499]: seq 3679 forked new worker [6317]
[34399.765878] udevd[6317]: seq 3679 running
[34399.765943] udevd[6317]: removing watch on '/dev/md127'
[34399.766012] udevd[6317]: IMPORT 'probe-bcache -o udev /dev/md127'
/usr/lib/udev/rules.d/69-bcache.rules:16
[34399.766259] udevd[6318]: starting 'probe-bcache -o udev /dev/md127'
[34399.766295] dlm: 62fccfd6-605f-19e6-be6d-99a1e3cb987e: leaving the
lockspace group...
[34399.766421] udevd[499]: seq 3680 queued, 'offline' 'dlm'
[34399.766549] udevd[499]: seq 3680 forked new worker [6319]
[34399.767080] dlm: 62fccfd6-605f-19e6-be6d-99a1e3cb987e: group event done 0 0
[34399.767297] dlm: 62fccfd6-605f-19e6-be6d-99a1e3cb987e:
release_lockspace final free
[34399.767320] md: unbind<dm-1>
[34399.795574] md: export_rdev(dm-1)
[34399.795640] md: unbind<dm-0>
[34399.803565] md: export_rdev(dm-0)
--snip--


On the other machines where the md array stopped correctly (removing
the entries from /dev and /sys) I do see the 'remove' events with
"udevadm monitor". What produces those remove events? Is that
something directly from the mdadm tool, or indirectly as part of the
stop/tear-down that mdadm initiates?


--Marc

>
> NeilBrown
>
>>
>> Looks like Linux 4.9 is at rc6 now -- have there been any changes that
>> would correct this behavior? Or is this expected behavior with the
>> latest version? Not sure when this changed, but I did go back to 4.5.2
>> and confirmed everything is removed correctly in that version, not
>> sure if this is different starting in 4.9, or something between 4.5
>> and 4.9.
>>
>> Can anyone else confirm with Linux 4.9 that the /sys/block/mdXXX entry
>> lingers after using mdadm --stop? I suppose it could be some other
>> system that is causing this on my machines. I tested using the latest
>> from the master branch of mdadm and get the same result.
>>
>>
>> Thanks for your time and help.
>>
>> --Marc
>>
>>
>> On Mon, Nov 21, 2016 at 9:08 AM, Marc Smith <marc.smith@mcc.edu> wrote:
>>> On Sun, Nov 20, 2016 at 10:42 PM, NeilBrown <neilb@suse.com> wrote:
>>>> On Sat, Nov 19 2016, Marc Smith wrote:
>>>>
>>>>> On Mon, Nov 7, 2016 at 12:44 AM, NeilBrown <neilb@suse.com> wrote:
>>>>>> On Sat, Nov 05 2016, Marc Smith wrote:
>>>>>>
>>>>>>> Hi,
>>>>>>>
>>>>>>> It may be that I've never noticed this before, so maybe its not a
>>>>>>> problem... after using '--stop' to deactivate/stop an MD array, there
>>>>>>> are remnants of it lingering, namely an entry in /sys/block (eg,
>>>>>>> /sys/block/md127) and the device node in /dev remains (eg,
>>>>>>> /dev/md127).
>>>>>>>
>>>>>>> Is this normal? Like I said, it probably is, and I've just never
>>>>>>> noticed it before. I assume its not going to hurt anything, but is
>>>>>>> there a way to clean it up, without rebooting? Obviously I could
>>>>>>> remove the /dev entry, but what about /sys/block?
>>>>>>>
>>>>>>
>>>>>> You can remove them both by running
>>>>>>   mdadm -S /dev/md127
>>>>>>
>>>>>> but they'll probably just reappear again.
>>>>>>
>>>>>> This seems to be an on-going battle between md and udev.  I've "fixed"
>>>>>> it at least once, but it keeps coming back.
>>>>>>
>>>>>> When md removes the md127 device, a message is sent to udev.
>>>>>> As part of its response to this message, udev tries to open /dev/md127.
>>>>>> Because of the rather unusual way that md devices are created (it made
>>>>>> sense nearly 20 years ago when it was designed), opening /dev/md127
>>>>>> causes md to create device md127 again.
>>>>>>
>>>>>> You could
>>>>>>   mv /dev/md127 /dev/md127X
>>>>>>   mdadm -S /dev/md127X
>>>>>>   rm /dev/md127X
>>>>>> that stop udev from opening /dev/md127.  It seems to work reliably.
>>>>>>
>>>>>> md used to generate a CHANGE event before the REMOVE event, and only the
>>>>>> CHANGE event caused udev to open the device file.  I removed that and
>>>>>> the problem went away.  Apparently some change has happened to udev and
>>>>>> now it opens the file in response to REMOVE as well.
>>>>>
>>>>> I used "udevadm monitor -pku" to watch the events when running "mdadm
>>>>> --stop /dev/md127" and this is what I see:
>>>>>
>>>>> --snip--
>>>>> KERNEL[163074.119778] change   /devices/virtual/block/md127 (block)
>>>>> ACTION=change
>>>>> DEVNAME=/dev/md127
>>>>> DEVPATH=/devices/virtual/block/md127
>>>>> DEVTYPE=disk
>>>>> MAJOR=9
>>>>> MINOR=127
>>>>> SEQNUM=3701
>>>>> SUBSYSTEM=block
>>>>>
>>>>> UDEV  [163074.121569] change   /devices/virtual/block/md127 (block)
>>>>> ACTION=change
>>>>> DEVNAME=/dev/md127
>>>>> DEVPATH=/devices/virtual/block/md127
>>>>> DEVTYPE=disk
>>>>> MAJOR=9
>>>>> MINOR=127
>>>>> SEQNUM=3701
>>>>> SUBSYSTEM=block
>>>>> SYSTEMD_READY=0
>>>>> USEC_INITIALIZED=370470
>>>>> --snip--
>>>>>
>>>>> I don't see any 'remove' event generated. I should mention if I hadn't
>>>>> already that I'm testing md-cluster (--bitmap=clustered), and
>>>>> currently using Linux 4.9-rc3.
>>>>
>>>> What version of mdadm are you using?
>>>
>>> v3.4
>>>
>>>
>>>> You need one which contains
>>>> Commit: 229e66cb9689 ("Manage.c: Only issue change events for kernels older than 2.6.28")
>>>>
>>>> which hasn't made it into a release yet.  But if you are playing with
>>>> md-cluster, I would guess you are using the latest from git...
>>>
>>> Wasn't, but I will now. Thanks.
>>>
>>> --Marc
>>>
>>>
>>>>
>>>> NeilBrown
