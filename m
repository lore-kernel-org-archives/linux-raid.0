From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Subject: [001/002 ] raid0 reshape
Date: Tue, 26 May 2009 13:17:46 +0200
Message-ID: <87skisnmed.fsf@frosties.localdomain>
References: <1241300764.5607.36.camel@raz>
	<e9c3a7c20905191109s92db696ue31a20b0816a4aed@mail.gmail.com>
	<18965.16276.485692.812516@notabene.brown>
	<87f94c370905211220n4e686a30ke452a56a2690d22b@mail.gmail.com>
	<87r5ydqsrd.fsf@frosties.localdomain>
	<18971.6239.413944.47540@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18971.6239.413944.47540@notabene.brown> (Neil Brown's message of
	"Tue, 26 May 2009 08:14:55 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Greg Freemyer <greg.freemyer@gmail.com>, Dan Williams <dan.j.williams@intel.com>, raz ben yehuda <raziebe@013.net>, linux-raid@vger.kernel.org, Jacek Danecki <jacek.danecki@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:

> On Monday May 25, goswin-v-b@web.de wrote:
>> That really seems to scream for LVM to support more raid levels. It
>> already has linear, raid0 and raid1 support (although I have no idea
>> how device mapper raid1 compares to md raid1).
>
> Note that LVM (a suite of user-space tools) could conceivably use
> md/raid1, md/raid5 etc. The functionality doesn't have to go in dm.
>
> Neil

How would you do this? Worst case you can have a LV made up of totaly
non linear PEs, meaning lots of 4MB (default PE size) big chunks in
random order on random disks.

Do you create a raid1/5 for each stripe? You surely run out of md
devices.

Create dm mappings for all stripe 0s, stripe 1s, stripe 2s, ... and
then a raid1/5 over those stripe devices?

What if the LV has segments with different raid configurations (number
of disks in a stripe or even different levels)? Create a raid for each
segment and then a dm mapping for a linear raid?


You can get a flood of intermediate devices there. A /proc/mdstat with
200 entries would be horrible. iostat output would be totaly
useless. ...

MfG
        Goswin
