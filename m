From: =?UTF-8?Q?Pawe=C5=82_Brodacki?= <pawel.brodacki@googlemail.com>
Subject: Re: [md PATCH 08/23] md: don't set md arrays to readonly on shutdown.
Date: Mon, 30 Apr 2012 12:32:03 +0200
Message-ID: <CACVpCE7jjsJ2enWP6mFmLs7=RCpMCJ7G802cNVn7pG2GDf2NXg@mail.gmail.com>
References: <20120314043555.7978.75486.stgit@notabene.brown>
	<20120314044040.7978.64156.stgit@notabene.brown>
	<CAGRgLy5UYf27335hQmEQQ8V2GSatQ-1aev9DdTia0j-Hv4wsEg@mail.gmail.com>
	<20120419084833.39379a6f@notabene.brown>
	<CAGRgLy6LXB34JtmfZYQEdAK4GLCV-hn-V8cT1zCwo_=ERyK90A@mail.gmail.com>
	<20120419195740.6e35ea02@notabene.brown>
	<CACVpCE5mpJcY5u=8Kqp7TkCHN63aMfncDwbnP77NOFjubhqoPA@mail.gmail.com>
	<20120420220151.623df648@notabene.brown>
	<CACVpCE6UZvBia2VwRMaFhJJuB2quvKKQc1byLFRP4YPTE8LHSQ@mail.gmail.com>
	<20120422064203.65eee938@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120422064203.65eee938@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Alexander Lyakas <alex.bolshoy@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2012/4/21 NeilBrown <neilb@suse.de>:
> On Sat, 21 Apr 2012 17:18:58 +0200 Pawe=C5=82 Brodacki
> <pawel.brodacki@googlemail.com> wrote:
>
> "For what, we ask, is life - without a touch of poetry in it".
>
> Maybe not an entirely relevant quote, but it is the first that came t=
o mind.
>
> "What's life without whimsy?"
>
> Would be a slightly more modern quote.
>
> Can you place them without google's help?

I pledge ignorance in both cases. After employing Google I can say, tha=
t
1) Arthur Sullivan and W. S. Gilbert. kinda ring the bell, but no, I
wouldn't guess.
2) I was dimly aware of existence of character of dr S. Cooper, but at
no point did I memorise his words.
>> Neil, could you point us to a bug report which inspired you to write
>> this patch? My google fu failed me and I was able to find just one b=
ug
>> entry from before 2 yerars, and even that hit is of dubious relevanc=
e.
>>
>> Pretty please with sugar on top?
>>
>
> https://bugzilla.novell.com/show_bug.cgi?id=3D713148
>
> But that is against our "enterprise" product so is not globally visib=
le :-(
>
> But it gave me some search-term hints so:
>
> http://lists.debian.org/debian-kernel/2011/05/msg00264.html
>
> http://www.issociate.de/board/post/491554/Kernel_BUG.html
>
> http://www.gossamer-threads.com/lists/xen/devel/174884?do=3Dpost_view=
_threaded
>
> https://lkml.org/lkml/2008/11/24/414
> http://comments.gmane.org/gmane.linux.raid/20710
>
> The important elements are:
> =C2=A01/ you see "md: stopping all devices". =C2=A0This means that "r=
eboot" has
> =C2=A0 really started. =C2=A0This is printed by mds reboot notifier.
>
> =C2=A02/ A stack trace showing something submitting IO.
> =C2=A0 In the first link it is bdi_writeback_task
> =C2=A0 In the second it is kjournald
>
Amazingly enough, this is about what I found via google. Our
perception of "recent kernel" differs, though. Serves me well for
reading too much of linux-btrfs ;).

> This pattern can only happen on an unclean shutdown.
>
> NeilBrown
>

Thanks a lot for a clear, definitive and catharsis-bringing reply.

Kind regards,
Pawe Brodacki
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
