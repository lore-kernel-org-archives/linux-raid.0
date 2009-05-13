From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Requesting replace mode for changing a disk
Date: Wed, 13 May 2009 09:37:16 +0200
Message-ID: <874ovpihcj.fsf@frosties.localdomain>
References: <20090513012112681.IEFQ19662@cdptpa-omta02.mail.rr.com>
	<87zldhvg0v.fsf@frosties.localdomain>
	<18954.20061.109627.591832@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18954.20061.109627.591832@notabene.brown> (Neil Brown's message
	of "Wed, 13 May 2009 14:36:45 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, lrhorer@satx.rr.com, 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:

> On Wednesday May 13, goswin-v-b@web.de wrote:
>> > OK, basically the same question.  How does one disassemble the RAID1 array
>> > without wiping the data on the new drive?
>> 
>> I think he ment this:
>> 
>> mdadm --stop /dev/md0
>> mdadm --build /dev/md9 --chunk=64k --level=1 --raid-devices=2 /dev/suspect /dev/new
>> mdadm --assemble /dev/md0 /dev/md9 /dev/other ...
>
> or better still:
>
>   mdadm --grow /dev/md0 --bitmap internal
>   mdadm /dev/md0 --fail /dev/suspect --remove /dev/suspect
>   mdadm --build /dev/md9 --level 1 --raid-devices 2 /dev/suspect missing
>   mdadm /dev/md0 --add /dev/md9
>   mdadm /dev/md9 --add /dev/new
>
> no down time at all.  The bitmap ensures that /dev/md9 will be
> recovered almost immediately once it is added back in to the array.

I keep forgetting bitmaps. :)

> The one problem with this approach is that if there is a read error on
> /dev/suspect while data is being copied to /dev/new, you lose.
>
> Hence the requested functionality which I do hope to implement for
> raid456 and raid10 (it adds no value to raid1).
> Maybe by the end of this year... it is on the roadmap.
>
> NeilBrown

What about raid0? You can't use your bitmap trick there.

MfG
        Goswin
