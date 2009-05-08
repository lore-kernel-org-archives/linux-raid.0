From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: md extension to support booting from raid whole disks.
Date: Fri, 08 May 2009 23:18:50 +0200
Message-ID: <87skjf47k5.fsf@frosties.localdomain>
References: <49F68CE0.2010906@zytor.com>
	<e9c3a7c20904281124g4682d70cp22760176e7a8cfbc@mail.gmail.com>
	<1240957153.18303.689.camel@ezra>
	<18935.35747.471257.202356@notabene.brown>
	<49F78F26.2040909@zytor.com> <1240963225.18303.858.camel@ezra>
	<49F7997C.2070808@zytor.com> <1240964410.18303.895.camel@ezra>
	<49F79F26.9060309@zytor.com> <1240965831.18303.944.camel@ezra>
	<20090429064333.GB9372@boogie.lpds.sztaki.hu>
	<87hc04leau.fsf@frosties.localdomain>
	<1241217394.4418.4.camel@poledra.romunt.nl>
	<87presxwu4.fsf@frosties.localdomain>
	<1241219902.9516.6.camel@poledra.romunt.nl>
	<87bpq8n6ym.fsf@frosties.localdomain>
	<1241470631.25901.130.camel@poledra.romunt.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1241470631.25901.130.camel@poledra.romunt.nl> (Rudy Zijlstra's
	message of "Mon, 04 May 2009 22:57:11 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Rudy@grumpydevil.homelinux.org
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Rudy Zijlstra <rudy@grumpydevil.homelinux.org> writes:

> Op maandag 04-05-2009 om 18:55 uur [tijdzone +0200], schreef Goswin von
> Brederlow:
>> Rudy Zijlstra <rudy@grumpydevil.homelinux.org> writes:
>> 
>> > Op zaterdag 02-05-2009 om 00:49 uur [tijdzone +0200], schreef Goswin von
>> > Brederlow:
>> >> Rudy Zijlstra <rudy@grumpydevil.homelinux.org> writes:
>> >> 
>> >> > I really prefer the current situation, where you need to explicitly
>> >> > configure a RAID1. This makes clear what is happening, and reduces
>> >> > confusion. This propposal would make debug of a failed boot just so much
>> >> > more difficult. 
>> >> >
>> >> > Cheers,
>> >> >
>> >> > Rudy
>> >> 
>> >> As said in another mail the same problem is there with raid1. The
>> >> proposal should allow creating a raid1 over sda/b without partitioning
>> >> and any replacement drive automatically becoming bootable without you
>> >> having to manually reinstall the bootloader to the new disk.
>> >> 
>> >> Wouldn't that be a huge plus?
>> >> 
>> >> MfG
>> >>         Goswin
>> >
>> > Agreed to the automatic bootable of replacement disk, I still prefer the
>> > partitioning though, as it makes clear what is happening. There are two
>> > aspects here:
>> > 1/ ease of installation
>> 
>> Which isn't true. Installing thebootloader on every component device
>> is currently a pain and easy to forget when changing disks.
>
> which means it is an important aspect... And i agree at the moment easy
> to forget. So far i do not see improvement in this aspect from current
> proposal. 

My preference is to have md consider the bootloader space part of the
metadata and copy it accross to new disks when they get added to a
raid. That way you can't forget it.
 
>> > 2/ ease of debug
>> >
>> > The latter is very important in boot situations. It gets worse with any
>> > implied action. Please take a look at what you are specifying: an
>> > implicit RAID1 over 2 "special" disks, within a RAIDX device... Now you
>> > expect a user to debug that, in case it fails?? I have had too often
>> > trouble to get my systems to boot the way i wanted to boot them, to
>> > trust any BIOS to do the expected :(
>> >
>> > Cheers,
>> >
>> > Rudy
>> 
>> Not over 2 "special" disks. Plain across all disks.
>
> Which is even worse, as i have not seen *any* BIOS able to handle
> that... and i have a intel based board wich according to this email
> thread should do that (and linux did not recognise the raid it had
> configured, so let us forget about booting from it)

If it is mirrored across all disks any one disk (of the raid) will be
bootable. Every bios supports that.

The part where you need bios support only comes later once the
bootloader is loaded, activates its raid capabilities and then tries
to read a raid 0/4/5/6. If the bios does not grive access to enough
component devices of such a raid then the bootloader will be stuck
then.

But that is really nothing new. With a partition block and raid on
partitions the bootloader is just as stuck there. That just can't be
helped so I don't consider that an argument for or against anything.

MfG
        Goswin
