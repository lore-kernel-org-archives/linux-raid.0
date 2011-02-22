From: "Patrick J. LoPresti" <lopresti@gmail.com>
Subject: Re: Two questions about stripe_cache_size
Date: Tue, 22 Feb 2011 14:35:46 -0800
Message-ID: <AANLkTi=25QozqVfn814=2Tm=BLGQz7C=eejsOFNLwBQj@mail.gmail.com>
References: <AANLkTi=bvRBoyUCH+9_9ZTjrWKdqjkfzpnNtdhmvgYCk@mail.gmail.com>
	<20110223090105.4be62a1e@notabene.brown>
	<AANLkTin-Ub0PAvdWDQwzqUyvzVDKia5FGGpyK4ip_=Lo@mail.gmail.com>
	<20110223092422.230875fa@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110223092422.230875fa@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 22, 2011 at 2:24 PM, NeilBrown <neilb@suse.de> wrote:
>
>
> Write-through.
>
> However I am tempted to make it write-back as filesystems now submit =
'flush'
> requests which can be used to flush the cache. =A0I wonder if you wou=
ld be able
> to notice any performance difference...

I imagine it would depend on your file system and what you are doing wi=
th it.

In my application, I am typically generating multi-gigabyte files,
with linear writes, at a reasonably fast pace.  So write-back might
help.

On the other hand, "flush" alone might not be sufficient for high
performance.  I do not know much about Linux file system internals,
but it seems to me that there are two separate but related concepts.
One is ordering of operations (to ensure file system consistency).
The other is flushing (for data integrity; i.e. fsync()).  If the file
system actually has to flush to ensure consistency -- rather than just
tagging its writes with ordering constraints -- I think you might lose
a lot of your performance to all of that flushing.

But since I really do not know what the kernel provides internally in
this regard I will stop rambling now.

 - Pat
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
