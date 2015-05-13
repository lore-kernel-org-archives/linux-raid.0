From: "David F." <df7729@gmail.com>
Subject: Re: Breaks LSI RAID on C600 chipset
Date: Wed, 13 May 2015 07:26:30 -0700
Message-ID: <CAGRSmLvS3kFFGwEWGE8H7smi+uN-EowPGYJxS-dM4+tezFUuVw@mail.gmail.com>
References: <CAGRSmLtoCz+wff+F=xnnusc5_bUYxWYT5V5iTncTnRfgRnTqtg@mail.gmail.com>
	<21791.17074.357416.218211@quad.stoffel.home>
	<CAGRSmLu5kEXA34mmHb5Q9+Fjmh5NFtRw2hrOrCDiOS4NR=5fvQ@mail.gmail.com>
	<21792.11560.92731.222551@quad.stoffel.home>
	<CAGRSmLt+1KJJHmMgoUHG0Dq0qg+38q5PRWnMNCRFg6qTa9s7gQ@mail.gmail.com>
	<21795.3296.846489.199118@quad.stoffel.home>
	<CAGRSmLtrp6Rh3pALL2Rr62jRRZQKFg-3SaV_AxubaHNhkeb0UA@mail.gmail.com>
	<20150410105001.171d6683@notabene.brown>
	<CAGRSmLvoj-UhV+8hSESQ+RRyzMHZ68QuBdRZzVU0PWEztZWeOw@mail.gmail.com>
	<CAGRSmLsxN_oGm9LQmDJSUVcTvVP7DzSAeWG+aaR+Td-OFc=c=A@mail.gmail.com>
	<CAGRSmLvdP8y1=KzG0j7Q9oc9HDGDgNGkSnhNLRUU1YXmLq3KDg@mail.gmail.com>
	<20150513103557.1df6036d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150513103557.1df6036d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: John Stoffel <john@stoffel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks.

1) The update did fix the broken RAID.  I can reboot and the RAID
mirror still exists after reboots.

2) I do want to report that on the first test, the reboot was clean.
On the second reboot there was a warning message about the BIOS
detecting "Inconsistent Timestamps" on one of the drives and something
about which CONFIG the BIOS would use.  I didn't have time to get it
all jotted down.  Whatever it used was still okay since the RAID
mirror was still there after that message.


On Tue, May 12, 2015 at 5:35 PM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 11 May 2015 09:31:26 -0700 "David F." <df7729@gmail.com> wrote:
>
>> any progress or more information needed on this?
>>
>> On Mon, Apr 20, 2015 at 10:39 PM, David F. <df7729@gmail.com> wrote:
>> > If you need access to the system, a network kvm is available - or if
>> > you have a C600 based system, you should see the same problem there.
>> >
>> > On Fri, Apr 10, 2015 at 1:07 PM, David F. <df7729@gmail.com> wrote:
>> >> Okay, and to confirm, this is happening on other C600 based systems.
>> >> Boot to Linux with MDADM raid support and the raid is gone after
>> >> reboot.
>> >>
>> >> On Thu, Apr 9, 2015 at 5:50 PM, NeilBrown <neilb@suse.de> wrote:
>> >>> On Thu, 9 Apr 2015 14:13:05 -0700 "David F." <df7729@gmail.com> wrote:
>> >>>
>> >>>> Hello,
>> >>>>
>> >>>> I built a new system, installed new drives (no partitioning, just raw
>> >>>> new drives), configured RAID 1, boot to linux, created reports
>> >>>> attached.  Rebooted and the system doesn't see any configured raid
>> >>>> drives (just the two raw drives).
>> >>>
>> >>> Thanks.  I might take a look, but I would greatly prefer it if you kept the
>> >>> linux-raid list on the Cc.....
>> >>>
>> >>> NeilBrown
>> >>>
>
> I must confess that I haven't even looked at it.
> But I just saw and email on linux-raid from Martin Wilck:
>
>  Subject: [PATCH] DDF: _write_super_to_disk: fix anchor header type
>
> which very likely fixes your problem.  I've applied it and pushed out to
>    git://neil.brown.name/mdadm/
>
> NeilBrown
