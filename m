From: "David F." <df7729@gmail.com>
Subject: Re: Breaks LSI RAID on C600 chipset
Date: Mon, 20 Apr 2015 22:39:12 -0700
Message-ID: <CAGRSmLsxN_oGm9LQmDJSUVcTvVP7DzSAeWG+aaR+Td-OFc=c=A@mail.gmail.com>
References: <CAGRSmLtoCz+wff+F=xnnusc5_bUYxWYT5V5iTncTnRfgRnTqtg@mail.gmail.com>
	<21791.17074.357416.218211@quad.stoffel.home>
	<CAGRSmLu5kEXA34mmHb5Q9+Fjmh5NFtRw2hrOrCDiOS4NR=5fvQ@mail.gmail.com>
	<21792.11560.92731.222551@quad.stoffel.home>
	<CAGRSmLt+1KJJHmMgoUHG0Dq0qg+38q5PRWnMNCRFg6qTa9s7gQ@mail.gmail.com>
	<21795.3296.846489.199118@quad.stoffel.home>
	<CAGRSmLtrp6Rh3pALL2Rr62jRRZQKFg-3SaV_AxubaHNhkeb0UA@mail.gmail.com>
	<20150410105001.171d6683@notabene.brown>
	<CAGRSmLvoj-UhV+8hSESQ+RRyzMHZ68QuBdRZzVU0PWEztZWeOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLvoj-UhV+8hSESQ+RRyzMHZ68QuBdRZzVU0PWEztZWeOw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: John Stoffel <john@stoffel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

If you need access to the system, a network kvm is available - or if
you have a C600 based system, you should see the same problem there.

On Fri, Apr 10, 2015 at 1:07 PM, David F. <df7729@gmail.com> wrote:
> Okay, and to confirm, this is happening on other C600 based systems.
> Boot to Linux with MDADM raid support and the raid is gone after
> reboot.
>
> On Thu, Apr 9, 2015 at 5:50 PM, NeilBrown <neilb@suse.de> wrote:
>> On Thu, 9 Apr 2015 14:13:05 -0700 "David F." <df7729@gmail.com> wrote:
>>
>>> Hello,
>>>
>>> I built a new system, installed new drives (no partitioning, just raw
>>> new drives), configured RAID 1, boot to linux, created reports
>>> attached.  Rebooted and the system doesn't see any configured raid
>>> drives (just the two raw drives).
>>
>> Thanks.  I might take a look, but I would greatly prefer it if you kept the
>> linux-raid list on the Cc.....
>>
>> NeilBrown
>>
