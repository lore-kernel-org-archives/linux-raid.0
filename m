From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Write intent bitmaps
Date: Fri, 19 Jun 2009 17:01:31 +0200
Message-ID: <87ab44mfn8.fsf@frosties.localdomain>
References: <20090608021026139.GMOD14139@cdptpa-omta02.mail.rr.com>
	<18989.6010.582386.812296@fisica.ufpr.br>
	<19002.62697.475588.28776@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19002.62697.475588.28776@notabene.brown> (Neil Brown's message
	of "Fri, 19 Jun 2009 12:16:09 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Carlos Carvalho <carlos@fisica.ufpr.br>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:

> On Monday June 8, carlos@fisica.ufpr.br wrote:
>>  >If so, would ext2 probably be the best choice?
>> 
>> That's what the man page says. I find it strange since if it's a file
>> the filesystem shouldn't matter. Neil?
>
> The way that md writes to the bitmap file is not entirely portable
> across different filesystems.  As the man page say,  it is known to
> work for ext2 and ext3.  Either is a fine choice.
> A new filesystem interface is being introduced in 2.6.31 as part of
> the swap-over-NFS work.  I might end up using that to write to bitmap
> files, as it has the right characteristics.  But that is very much in
> the future.
>
> NeilBrown

How about support to write to a device instead of a file?

MfG
        Goswin
