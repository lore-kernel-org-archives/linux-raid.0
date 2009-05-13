From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Change Chunk Size on Array?
Date: Wed, 13 May 2009 09:33:38 +0200
Message-ID: <878wl1ihil.fsf@frosties.localdomain>
References: <16137381.post@talk.nabble.com> <23514897.post@talk.nabble.com>
	<18954.20603.952706.467047@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18954.20603.952706.467047@notabene.brown> (Neil Brown's message
	of "Wed, 13 May 2009 14:45:47 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: SandeepKsinha <sandeepksinha@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:

> Online changing of chunk size for raid5 is very close to being
> implemented.
> All the kernel side support will be in 2.6.30.
> I just need to spend some time getting mdadm to make it work.
> Because data is being rearranged in-place, and because you don't want
> to lose everything if your systems crashes, mdadm will have to work in
> tandem with the kernel making a backup copy of a section of the array,
> allowing the kernel to reshape that section, and then moving on to the
> next section.  It will be slow, but it will be reliable.
>
> NeilBrown

Shouldn't mdadm create a file and pass the FD to the kernel or a
loopback device and pass the major/minor and the kernel then moves
data there itself? Seems like a bad idea to pass all the data of the
raid to userspace just so it can be passed back to the kernel again.

MfG
        Goswin
