From: Peter Rajnoha <prajnoha@redhat.com>
Subject: Re: udev rule and systemd unit files and  mdadm - cross distro.
Date: Mon, 16 Dec 2013 12:29:55 +0100
Message-ID: <52AEE433.3040008@redhat.com>
References: <20131211131223.5acbbca8@notabene.brown> <wrfjmwk7cowt.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjmwk7cowt.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>, NeilBrown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, linux RAID <linux-raid@vger.kernel.org>, Michael Tokarev <mjt@tls.msk.ru>
List-Id: linux-raid.ids

On 12/11/2013 05:50 PM, Jes Sorensen wrote:
> NeilBrown <neilb@suse.de> writes:
>> Hi,
>>  I would really like all distros that use systemd and mdadm to use a common
>>  set of unit files to run mdadm.  Similarly I would like us all to use
>>  exactly the same udev rules files.
>>  This is, after all, one of the benefits of open source - sharing fixes so we
>>  all get a better result.  It should also make it easier to respond to
>>  community issues because there are fewer differences between distros.
> 
> Neil,
> 
> Nice updates!
> 
>>  To this end:
>>
>>   - I've recently added some systemd unit files to mdadm and they are or will
>>     be in openSUSE.  I'm hoping they will eventually make their way into
>>     Fedora and any other distro that uses systemd.  I am of course happy to
>>     make changes to meet needs in other distros that I'm not aware of.
>>
>>     The particular unit files are:
>>      mdadm-last-resort@.timer  mdadm-last-resort@.service
>>
>>       When udev runs "mdadm -I" and finds that the array could have been
>>       started degraded, but wasn't because there is good reason to believe
>>       that more devices will appear, it adds to SYSTEMD_WANTS
>>            mdadm-last-resort@mdXXX.timer
>>       This waits 30 seconds and then runs mdadm-last-resort@mdxxx.service
>>       which starts the array if possible.
>>       If another device has appeared and the array has already been started,
>>       this will simply do nothing.
>>       This means that if you shut down, remove a device, then reboot you get
>>       a 30 second pause and the array starts.  That is better than the
>>       current situation where the array doesn't start.
>>
>> http://git.neil.brown.name/?p=mdadm.git;a=commitdiff;h=169ffac7ad7748c8586fd1d68b7a417d71133140
> 
> I am always wary of setting timeouts like this, but I am not sure there
> is a better solution. In particular what happens on a system which has a
> *lot* of arrays, in this case 30 seconds simply may not be enough. A
> crazy config with raid run on top of a LUKS device requiring password
> would be even worse, but ok, anyone doing that kinda deserve what they
> get :)
> 
>>
>>     mdmonitor.service
>>
>>       This is similar in purpose to the mdmonitor.service from Fedora, but
>>       different in detail.  In particular whenever a RAID[1-9]* array starts,
>>       udev adds this service to SYSTEMD_WANTS so that "mdadm --monitor" will
>>       automatically be started when needed, but never before.  So there is no
>>       need to explicitly "enable" this service.
>>
>>       Doug/Jes: do you see a problem with switching to this in due course?
>>
>> http://git.neil.brown.name/?p=mdadm.git;a=commitdiff;h=61c094715836e76b66d7a69adcb6769127b5b77d
> 
> I don't see any issues with this off hand. I will need to run some
> testing with it, but I like the idea of getting the files cleaned up and
> shared across distros. There were some issues related to SYSTEMD_WANTS
> in Fedora the other day, so Peter may have some input (added to CC).

Yes, the recent issue I hit was exactly with the SYSTEMD_WANTS and SYSTEMD_READY
udev variables that need to be set very carefully. Lennart even updated a man
page to include this important piece of information without which there could be
some confusion:
  http://cgit.freedesktop.org/systemd/systemd/commit/?id=419173e60a05424008fcd312f6df4b59b2ce8e62

(Also some discussion here: https://bugzilla.redhat.com/show_bug.cgi?id=1026860
and comment #76 for summary of the problem)

Briefly, we need to be sure that whenever SYSTEMD_WANTS is assigned, the
SYSTEMD_READY can't be 0 at the same time, otherwise, we will lose the action
for SYSTEMD_WANTS (systemd will ignore it and the service won't be started if
SYSTEMD_READY=0 at the same time).

It would be great if we could have some general rule to switch from
SYSTEMD_READY=0 to SYSTEMD_READY=1 at proper time for devices that have a more
complex initialization scheme like MD, DM/LVM, loop devs or any other devices
that are not fully set up on usual ADD event, but requires some more action
(and so they're ready after a CHANGE event later on).

As for creating or activating DM/LVM devs, we create the device (ADD event),
load the DM table for it (no event yet), and resume it (CHANGE event). And the
device is usable only after that CHANGE event. We're using a set of "flags" to
direct udev rules to not touch devices that are not ready yet, one of them is
the DM_UDEV_DISABLE_OTHER_RULES flag that direct all the "other" (non-dm/lvm
rule) to skip the device scanning or any actions that the other subsystem may
want to do perform on the device. This check is also used in MD rules for DM/LVM
devs...

I think a very similar activation scheme applies for MD devices when assembling
arrays as devices come, right? However, I noticed that MD rules check directly
the ATTR{md/array_state} no matter what the event type is (either ADD or CHANGE).
So what I would probably suggest for consistency here is to consider the MD dev
unusable on ADD event and only usable on/after CHANGE event. Otherwise, if we're
processing ADD event and we're relying on state of the ATTR{md/array_state}
only, we're getting into a race where the device could be usable or not, based
on timing - it all depends on whether during the processing of the ADD event,
the CHANGE event has already been triggered from kernel in background.

So that would be my first suggestion - to define when the device is ready and
whether the event type should be considered too when checking the
ATTR{md/array_state}. I think this would make it much cleaner as one can always
expect the device to be ready on CHANGE event, but never on ADD event, making
the processing easier in any other rules.

Of course, we need to make sure that the udev coldplug still works - which simply
means that if we have an ADD event generated (artificially by udevadm trigger --action=add
or echo add > /sys/block/.../uevent), we shouldn't skip it. This is easily done
by just detecting whether the device has already been set up properly before
(and therefore we'd detect that this is an artificially generated ADD event, not
the one coming from kernel that is part of the device set up). We already have
this logic in DM/LVM so I can help with this if needed.

Another thing I'd like to suggest would be to agree on some common way of
marking devices as not ready. What I mean is that for example DM/LVM has that
DM_UDEV_DISABLE_OTHER_RULES_FLAG, MD could have something else to check in other
rules and similarly for other block devices - each subsystem has its own way of
marking devices as "not yet ready" and this makes it harder for other rules to
check and to not forget something. So to make this a little bit cleaner, we
could agree that any block device subsystem would have exactly one flag to mark
a device as not yet ready (or "private"), let's say "BLOCK_DEVICE_READY=0" or
whatever.

With such a variable, we could also cleanup the SYSTEMD_READY assignment (at
least for block devices) and make it solely a part of systemd rules,
for example, systemd would have:

   ENV{BLOCK_DEVICE_READY}="0", ENV{SYSTEMD_READY}="0"

So the assignment of the SYSTEMD_READY variable would be a part of systemd rules
where it belongs I think, so we don't need to bother about it (in a year or two,
we can have another init system besides systemd and then we'd need to change/add
the logic in our rules which makes it harder to maintain). Also, systemd is not
the only init system that users may use and there are other situations in which
any rule, not just systemd, would like to check quickly whether the dev can be
accessed.

Currently, this encompasses DM/LVM, MD, loop devs and nbd - these are all the
ones that have two-step activation scheme - at least these are the ones I know
of.

Anyway, these are just some ideas that would be fine to integrate when changing
the rules...

-- 
Peter
