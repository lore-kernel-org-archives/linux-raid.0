From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 00/17] mdadm: SCSI enclosure based array
Date: Wed, 16 Dec 2015 10:54:19 -0800
Message-ID: <CAPcyv4g47ZUZfCEeLRtwZkXudArRVRyFLar4RrDg1iM=kjK6iQ@mail.gmail.com>
References: <1449015933-255689-1-git-send-email-songliubraving@fb.com>
	<87d1u7b188.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d1u7b188.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Song Liu <songliubraving@fb.com>, linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>
List-Id: linux-raid.ids

On Tue, Dec 15, 2015 at 6:01 PM, NeilBrown <neilb@suse.com> wrote:
> On Wed, Dec 02 2015, Song Liu wrote:
>
>> These patches by Dan Williams enable creating RAID array based on
>> SCSI enclosures.
>
> Is there any background reading available so I can have some idea what
> these patches are supposed to do.

"Blink the light when the disk dies", is the terse summary.

> I have a vague idea what an "enclosure" is but I didn't know that Linux
> knew about them.  Is there a link to the LWN article about them or some
> other useful documentation?  "git grep -i enclosur Documentation/"
> didn't show anything likely to be useful.

The interface these patches use is presented by the "ses" driver
(drivers/scsi/ses.c) which leverages the sysfs interface presented by
the "enclosure" driver (drivers/misc/enclosure.c).  I don't recall
their being much in the way of documentation.

For each disk in an enclosure the driver exposes an enclosure object
with the following attributes:
fault
status
active
locate
power_status
type
slot

Where 'fault', 'active', and 'locate' select different led signal
patterns.  The 'power_status' attribute allows power to be turned off
to the slot.  The 'slot' attribute is meant to match the slot
identifier that is on the board's silk screen or some physical label a
technician can observe.

> And what is "/dev/disk/by-slot"?? I've never come across it before
> and google doesn't help much.  Just these patches and
>   http://comments.gmane.org/gmane.linux.scsi/93809

/dev/disk/by-slot are new proposed symlinks for udev.  The new udev
rules for this are in patch1.

When the scsi core is probing devices and finds an enclosure target
device it associates enclosure slot objects with the scsi_target.
With that association we can create a symlink for the resulting disk
based on its physical slot identifier.

At the time mdadm was chosen to house these rules for convenience, but
I think they should be submitted to upstream udev.
