From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH] mdadm: Check bitmap first when reshape raid1 to raid0
Date: Tue, 27 Oct 2015 02:24:17 -0400 (EDT)
Message-ID: <1369719330.43095568.1445927057223.JavaMail.zimbra@redhat.com>
References: <1445751362-15677-1-git-send-email-xni@redhat.com> <284284227.42321345.1445751531086.JavaMail.zimbra@redhat.com> <877fmag0mn.fsf@notabene.neil.brown.name> <1424506067.42737315.1445862310535.JavaMail.zimbra@redhat.com> <877fm9dy5i.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877fm9dy5i.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jes Sorensen <jes.sorensen@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



----- Original Message -----
> From: "Neil Brown" <neilb@suse.de>
> To: "Xiao Ni" <xni@redhat.com>
> Cc: "Jes Sorensen" <jes.sorensen@redhat.com>, linux-raid@vger.kernel.org
> Sent: Tuesday, October 27, 2015 7:10:17 AM
> Subject: Re: [PATCH] mdadm: Check bitmap first when reshape raid1 to raid0
> 
> On Mon, Oct 26 2015, Xiao Ni wrote:
> 
> >> 
> >
> > Thanks for printing out the mistake. I checked the nearby code and found
> > I missed close the cfd. Is this I missed? But I'm wondering that it doesn't
> > close it in the following code. Now it's just closed when it's failed to
> > reshape raid1/raid10 to raid0.
> 
> That is a very sensible question to ask - thanks.
> After a quick look - it does seem very strange.  That handling of 'cfd'
> and 'fd' seems quite odd.
> 
> If you would like to work out what should happen and find a simple way
> to fix the code, that would be great.  But I don't insist.

I'll try it and re-send a patch then. 
> 
> The patch below is quite acceptable as it is a simple solution to a
> simple problem and appear consistent with nearby code.  So if you gave
> it a proper description, formatted it properly and posted it in a way
> that didn't mess up all the white space, I would very likely accept it.
> 
> However:
>  - maybe we should just remove the bitmap rather than complain if we
>    find one.  After all, we are removing other things (extra devices).
>    A raid0 can never had a bitmap, so when converting to a raid0, it
>    does make sense to remove the bitmap.


Yes, :) it's better to remove the bitmap than check it. 

> 
>  - The test you used only checks for an internal bitmap, not an external
>    one.  External bitmaps are hardly ever used except by people who know
>    exactly what they are doing, so I'm not too fussed about handling
>    them perfectly, but testing for and removing an external bitmap
>    might make sense.
> 
> Thanks,
> NeilBrown

As you said, I haven't used external bitmaps before. I'll check how to handle
them and add it to the patch too.

Best Regards
Xiao
