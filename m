From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Fw: raid 4, and bitmap.
Date: Fri, 3 Feb 2006 01:25:12 +0100
Message-ID: <04e601c62858$4c790330$9d00a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message ----- 
From: "JaniD++" <djani22@dynamicweb.hu>
To: "Neil Brown" <neilb@suse.de>
Sent: Friday, February 03, 2006 1:20 AM
Subject: Re: raid 4, and bitmap.


>
> ----- Original Message ----- 
> From: "Neil Brown" <neilb@suse.de>
> To: "JaniD++" <djani22@dynamicweb.hu>
> Cc: <linux-raid@vger.kernel.org>
> Sent: Friday, February 03, 2006 1:09 AM
> Subject: Re: raid 4, and bitmap.
>
>
> > On Friday February 3, djani22@dynamicweb.hu wrote:
> > > Hello, list, Neil,
> > >
> > > I try to add bitmaps to raid4, and mdadm is done this fine.
> > > In the /proc/mdstat shows this, and it is really works well.
> > >
> > > But on reboot, the kernel drops the bitmap(, and resync the entire
array
> if
> > > it is unclean). :(
> > >
> > > It is still uncomplete now? (2.6.16-rc1)
> >
> >
> > It is an 'internal' bitmap, or is the bitmap in a file?
> >
> > If the bitmap is in a file, you need to me sure that the file is
> > provided by mdadm when the array is assembled - using in-kernel
> > autodetect won't work.
> >
> > If it is an internal bitmap.... it should work.
> > Are there any kernel messages during boot that might be interesting?
>
> Sorry, i did not log this, and i dont want to restart the sync and system
> for this.
> Anyway, i add back the bitmap, and the next crash we will see....
>
> I mean this was:
> "bitmap is only support in raid1.
> bitmap is removed."
>
> But not so sure. :(
>
> Cheers,
> Janos
>
> >
> > NeilBrown
>

