From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: where is the spare drive? :-)
Date: Thu, 5 Jan 2006 12:06:25 +0100
Message-ID: <007f01c611e8$135573d0$a400a8c0@dcccs>
References: <02a801c60f2a$de619ce0$a400a8c0@dcccs> <20060105061133.M54165@liquid-nexus.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc <linux-raid@liquid-nexus.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message ----- 
From: "Marc" <linux-raid@liquid-nexus.net>
To: "JaniD++" <djani22@dynamicweb.hu>; <linux-raid@vger.kernel.org>
Sent: Thursday, January 05, 2006 7:16 AM
Subject: Re: where is the spare drive? :-)


> On Mon, 2 Jan 2006 00:26:58 +0100, JaniD++ wrote
> > Hello, list,
> >
> > I found something interesting when i try to create a brand new array
> > on brand new drives....
> >
>
> <snip>
>
> > 5. The question
> >
> > Why shows sdh2 as spare?
> > The MD array size is correct.
> > And i really can see, the all drive is reading, and sdh2 is *ONLY*
writing.
> >
>
> I'm not 100% sure but from a post by Neil a while a go on the list, the
spare
> device is a temporary construct created during the resync operation. Once
the
> resync is complete it should disappear.
>
> You could try searching the list archives for the post - choice of
keywords is
> up to you ;)

Thanks, but i have found the bug already. ;-)

If i create new raid5, it should only parity resyncing, and not spare
rebuilding!

This happens, only if i use mdadm.
With raidtools works fine.

My problem is now the bitmap. :(
Only mdadm supports this....

Cheers,
Janos

>
> Regards,
> Marc
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

