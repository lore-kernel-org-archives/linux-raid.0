From: "Tim Harvey" <tharvey@alumni.calpoly.edu>
Subject: RE: Autodetection howto
Date: Wed, 16 Jun 2004 14:25:49 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000001c453e8$7f3d2c10$7001a8c0@darwin>
References: <Pine.LNX.4.58.0406160824390.7934@desktop.agenda.si>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.58.0406160824390.7934@desktop.agenda.si>
To: danci@agenda.si
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of danci@agenda.si
> Sent: Tuesday, June 15, 2004 11:35 PM
> To: Tim Harvey
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Autodetection howto
> 
> On Tue, 15 Jun 2004, Tim Harvey wrote:
> 
> > Greetings,
> >
> > I've got a 4-disk RAID5 array that I'm able to manually assemble and
> > mount, however I can't figure out how to get the autodetection to
work.
> > In reading the Linux Software RAID howto it seems like it should
'just
> > work', but I'm running into a snag which doesn't seem to be
described in
> > the HOWTO/FAQ.
> 
> > - How do I get around the 'personality 4 is not loaded'?  Did I need
to
> > run something after I modified /etc/modules.conf for it to take
effect?
> > - It would appear that the mounting of filesystems via /etc/fstab
occurs
> > before md autoscans.  How can I delay the mounting of the filesystem
> > that exists on the RAID5 array?
> 
> 
> 1. You need to set the partition that are in the array to the correct
>    partition type - fd.
> 

Got this covered, and md is creating the array(s)... just still failing
with the 'md-personality' error which would seem to be why I need your
second step:

> 2. If you have raid compiled as modules, you need a proper initrd
which
>    will load appropriate modules (raid5) and then re-autodetect the
arrays
>    (SuSE uses 'raidautorun' for that) - all that before your OS
actually
>    starts booting.

I'm not exactly sure how to do this... could you give me an example?  My
existing initrd is /boot/initrd-2.4.22-1.2140.nptl_30.rhfc1.at.img so
I'm attempting:

# mkinitrd --preload raid5.o
/boot/initrd-2.4.22-1.2140.nptl_30.rhfc1.at.img 2.4.22-1

I'm getting a usage error and I'm evidently not understanding mkinitrd's
man page.

Thanks for your help,

Tim

> 
> As far as 'personality 4 is not loaded' - I think you don't need to
worry
> about it. It just tells you that it's not loaded...
> 
>  D.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

