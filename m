From: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 support handoff after pivotroot
Date: Wed, 10 Feb 2010 12:33:21 +1100
Message-ID: <20100210123321.324e5de6@notabene.brown>
References: <1263242294-5353-3-git-send-email-dledford@redhat.com>
	<20100119110930.107ca42e@notabene>
	<4B55F138.7060008@redhat.com>
	<20100204174009.6072ec07@notabene.brown>
	<4B6B15B3.8030205@redhat.com>
	<e9c3a7c21002041504w17565653m5a8b8cd90543cf1e@mail.gmail.com>
	<4B6DAC06.6060909@redhat.com>
	<e9c3a7c21002061307le6f5d56ked4fa3711bdd2367@mail.gmail.com>
	<4B702EA5.3030103@redhat.com>
	<20100209083838.6568cac0@notabene.brown>
	<20100209021949.GB11780@lapse.rw.madduck.net>
	<4B71C6CA.3010407@redhat.com>
	<alpine.LNX.2.01.1002091553580.10004@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LNX.2.01.1002091553580.10004-pIN9qAC4yfKseEBmXaVrNB5FPEiCeG3sAL8bYrjMMd8@public.gmane.org>
Sender: initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Mr. James W. Laferriere" <babydr-hujCQpUib4khwW3g317DAQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-raid maillist <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, initramfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Marek <mmarek-l3A5Bk7waGM@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bill Nottingham <notting-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids

On Tue, 9 Feb 2010 15:58:52 -0900 (AKST)
"Mr. James W. Laferriere" <babydr-hujCQpUib4khwW3g317DAQ@public.gmane.org> wrote:

>  	Hello Doug ,
> 
> On Tue, 9 Feb 2010, Doug Ledford wrote:
> > On 02/08/2010 09:19 PM, martin f krafft wrote:
> ...snip...
> >> I am all for finding a solution that works, but I don't think it's
> >> as easy as "the standards are slow, so let's just forge ahead with
> >> mdadm only and give them something to standardise".
> >>
> >> I wouldn't mind avoiding all the bikeshedding, and maybe it'll just
> >> work, but having to change things later might possibly be a lot of
> >> trouble ? after all, we don't want to break people's systems then.
> >
> > I don't think so.  Once it's all set up, any future change should be no
> > more than a coordinate package update cycle where initscripts, mkinitrd,
> > dracut, and a few other select packages that use the locations are all
> > updated simultaneously.
> 
>  	The key words in the above are: 'select packages' & 'simultaneously' .
>  	How is the community of linux distributors going to accomplish this ?
>  	Heck some of the distributors don't even use the same names for packages 
> that do exactly the same thing .
> 
>  	The Simultainity is going to hurt alot more than is mentioned here .

Simultaneity only needs to be within one host, not across all distros.  I
don't think it should be that hard to manage.

> 
>  	But that said ,  the idea of a /'name' area for this is imo a very good 
> thing .  Rather hiding it below others .

Thanks.

One idea that has occurred to me is that maybe /sys is the right place to put
this stuff!!!  If only sysfs directories could be writeable, I could write the
pid file in /sys/class/block/md0/md/mdmon.pid and create a socket with a
similar name.
I could of course get the md module to create a file called "mdmon.pid" and
allow it to be read and written much like a normal file.  But I don't think I
want to do that - and I couldn't use that solution for the socket in any case.

Not a short-term solution, but something to keep in mind longer-term maybe...

NeilBrown
