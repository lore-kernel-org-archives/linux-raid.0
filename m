From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: where is the spare drive? :-)
Date: Thu, 12 Jan 2006 10:11:52 +0100
Message-ID: <004f01c61758$42a5f090$a400a8c0@dcccs>
References: <02a801c60f2a$de619ce0$a400a8c0@dcccs> <17349.51157.745149.135889@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

----- Original Message ----- 
From: "Neil Brown" <neilb@suse.de>
To: "JaniD++" <djani22@dynamicweb.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Thursday, January 12, 2006 4:07 AM
Subject: Re: where is the spare drive? :-)


> On Monday January 2, djani22@dynamicweb.hu wrote:
> >
> > 5. The question
> >
> > Why shows sdh2 as spare?
> > The MD array size is correct.
> > And i really can see, the all drive is reading, and sdh2 is *ONLY*
writing.
> >
>
>  man mdadm
>
> Towards the end of the CREATE MODE section:
>
>        When creating a RAID5 array, mdadm will automatically create a
degraded
>        array with an extra spare drive.  This is because  building  the
spare
>        into a degraded array is in general faster than resyncing the
parity on
>        a non-degraded, but not clean, array.  This feature can be
over-ridden
>        with the --force option.
>
>
> I hope this clarifies the situation.
>
> NeilBrown

Ahh, this was avoid my attention.
The mdadm man page (and functionallity) is quite large.

I think this is more important to let some people to overwrite own data.
I think it is neccessary to place some note to the man page to warn people
about this exception.

Anyway this is a good idea! :-)

Thanks to note me about this.

Cheers,
Janos

>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

