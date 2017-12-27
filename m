From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: 3-way mirror to RAID-6
Date: Wed, 27 Dec 2017 11:13:55 +0100
Message-ID: <CAJH6TXh_u08K+w-na_YQDh0WZWOQ8o14=SEzQmwPVrGPbkWasA@mail.gmail.com>
References: <CAJH6TXg=uCQMmzSQPHC885naZj3cFOZx2oyx462mCBof9NeU+w@mail.gmail.com>
 <87incu79uw.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87incu79uw.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2017-12-25 22:53 GMT+01:00 NeilBrown <neilb@suse.com>:
> I suggest you add the new device with "mdadm --add", then try the
> reshape with "mdadm --grow /dev/mdXXX --level=6 --raid-devices-4".

Ok.

> It might not work quite that easily - I think you need to first convert
> the raid1 to a 2-way mirror, but that is easy enough
>
>  mdadm --grow /dev/mdxxx --raid-devices=2

Moving from a 3-way mirror to a 2-way mirror is not an issue.

What do you suggest ? Adding 3 more disks and creating a striped 3-way
mirror or reshaping to a 4-disks RAID-6?

Keep in mind that i'll never run anything with redundancy level < 2
and a simple mirror has only "1" as redundancy level (a striped mirror
is the same: only one disks could be lost in each mirror pair)
