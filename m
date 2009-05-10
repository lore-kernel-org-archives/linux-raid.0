From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: md extension to support booting from raid whole disks.
Date: Sun, 10 May 2009 03:29:34 +0200
Message-ID: <8763g9ycch.fsf@frosties.localdomain>
References: <49F68CE0.2010906@zytor.com> <1240963225.18303.858.camel@ezra>
	<49F7997C.2070808@zytor.com> <1240964410.18303.895.camel@ezra>
	<49F79F26.9060309@zytor.com> <1240965831.18303.944.camel@ezra>
	<20090429064333.GB9372@boogie.lpds.sztaki.hu>
	<87hc04leau.fsf@frosties.localdomain>
	<1241217394.4418.4.camel@poledra.romunt.nl>
	<1241226246.4862.24.camel@ezra>
	<6c4602af0905021002i6fb0e667mdde8fb589f34ead6@mail.gmail.com>
	<87ab5n45dc.fsf@frosties.localdomain> <4A052EBE.5010605@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A052EBE.5010605@rabbit.us> (Peter Rabbitson's message of "Sat,
	09 May 2009 09:20:30 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: Micha Przyuski <mikylie@gmail.com>, Daniel Reurich <daniel@centurion.net.nz>, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

Peter Rabbitson <rabbit+list@rabbit.us> writes:

> Goswin von Brederlow wrote:
>> If the hidden raid1 is just reserved space that is considered part of
>> the raid metadata then this moves completly into mdadm userspace. The
>> extra complexity comes down to "read reserved space from old disk,
>> write reserved space to new disk". In the most basic form that is 3
>> lines of code (declare buffer, read, write).
>> 
>
> This is the best description of the problem/benefit so far. Also when
> deciding on the size of the reserved space, factor in possible
> bitmap size explosion when moving from say a 4x300G raid6 to a 4x2T raid6.
>
> +1 on this feature request
>
> Cheers

From what Neil described it should be no problem to resize the amount
of space used for metadata. It would have to copy around all the data
of the raid, do a reshape basically, but that isn't hard. Or it could
be limited to adding drives, which would need to do a resync anyway,
e.g. something like

mdadm --add --reserved-space=3M --bitmap-space=4M /dev/md0 /dev/sdx

MfG
        Goswin

PS: tests seem to show though that smaller bitmaps are faster
