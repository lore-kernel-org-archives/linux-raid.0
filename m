From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Requesting replace mode for changing a disk
Date: Wed, 13 May 2009 09:28:24 +0200
Message-ID: <87d4adihrb.fsf@frosties.localdomain>
References: <4A060CBE.9090308@tmr.com>
	<20090513012112681.IEFQ19662@cdptpa-omta02.mail.rr.com>
	<18954.19719.172893.761454@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18954.19719.172893.761454@notabene.brown> (Neil Brown's message
	of "Wed, 13 May 2009 14:31:03 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: lrhorer@satx.rr.com, 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:

> On Tuesday May 12, lrhorer@satx.rr.com wrote:
>> 
>> But doesn't creating the array with the drive wipe the contents?  If so, it
>> doesn't seem to me this provides much redundancy.
>
> No.  Creating an array does not wipe the contents.
> It might cause a resync which will copy contents from one drive to the
> other and I don't promise which one.
> However if you:
>
>    mdadm -C /dev/md0 --level 1 -n 2 /dev/foo missing
>    mdadm /dev/md0 --add /dev/bar
>
> then the contents on /dev/foo will not be changed (except for a few K
> at the end for the metadata) and then all of foo will be copied to
> bar.
>
> NeilBrown

But as the disk is already part of a raid those few K at the end would
be the critical meta data of the original raid.

This only works with a raid without metatada.

MfG
        Goswin
