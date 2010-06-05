From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: RAID Configuration For New Home Server
Date: Sat, 5 Jun 2010 17:45:29 +0000
Message-ID: <AANLkTim1GIDahyG_Sx37SL0rmPa3J3W7nNfYEiMzsyu3@mail.gmail.com>
References: <C5.28.17309.03BF50C4@cdptpa-omtalb.mail.rr.com>
	<e35643473b05cc946fc35c0df2e85fcd.squirrel@mail.monkii.net>
	<AANLkTilAzPKlOMecKpQLIEPOqAhFDglR5STq3_QP_caW@mail.gmail.com>
	<4C06794F.8030908@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C06794F.8030908@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Carlos Mennens <carloswill@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jun 2, 2010 at 3:31 PM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
>
> I'd consider a larger than default chunk size for the RAID-5.

+1 absolutely

When building a server for storing mostly video files on RAID-6, the
files being around 500MB to 4GB in size, I ended up with 256KB chunks.
Gained quite a bit of speed compared to the default! (Also remember to
play around with stripe cache after you're up and running.)

(I did some very basic benchmarking. I repeated some tests I found
online, which indicated that RAID chunks around 256KB were fastest. My
tests agreed.)

I would consider not building a swap partition at all, but rather use
a swap *file*, that you can put on any partition. Here's a howto:
http://www.linux.com/archive/feature/113956 Alternately consider
putting the swap file on a RAID0 for the most speed, which also costs
you a smaller chunk of each disk for the same swap size. The safest
swap is mirrored though, and I'd agree with RAID10,f2 in that case.

Hmm ... no conclusion ... I'm thinking out loud more than I intended
to. To state something concrete: I think my conclusion du jour
regarding swap RAID is probably that swap space isn't that important
anyway for regular use - one should always have enough memory to begin
with so relegating swap mostly to emergency use. Regarding swap as an
emergency feature, it's probably best to have it mirrored - you
wouldn't want your swap space to ever vanish in the middle of
anything. And so I'd go with RAID10,f2, which is by far the fastest
mirror.

-- Kristleifur
