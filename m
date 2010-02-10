From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
	support handoff after pivotroot
Date: Wed, 10 Feb 2010 08:49:03 -0700
Message-ID: <e9c3a7c21002100749u2c6d7c51qa0cc1830452f84cb@mail.gmail.com>
References: <1263242294-5353-3-git-send-email-dledford@redhat.com>
	 <e9c3a7c21002041504w17565653m5a8b8cd90543cf1e@mail.gmail.com>
	 <4B6DAC06.6060909@redhat.com>
	 <e9c3a7c21002061307le6f5d56ked4fa3711bdd2367@mail.gmail.com>
	 <4B702EA5.3030103@redhat.com> <20100209083838.6568cac0@notabene.brown>
	 <20100209021949.GB11780@lapse.rw.madduck.net>
	 <4B71C6CA.3010407@redhat.com>
	 <alpine.LNX.2.01.1002091553580.10004@filesrv1.baby-dragons.com>
	 <20100210123321.324e5de6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100210123321.324e5de6-wvvUuzkyo1EYVZTmpyfIwg@public.gmane.org>
Sender: initramfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>
Cc: "Mr. James W. Laferriere" <babydr-hujCQpUib4khwW3g317DAQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-raid maillist <linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, initramfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Marek <mmarek-l3A5Bk7waGM@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bill Nottingham <notting-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids

On Tue, Feb 9, 2010 at 6:33 PM, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org> wrote:
> On Tue, 9 Feb 2010 15:58:52 -0900 (AKST)
> "Mr. James W. Laferriere" <babydr-hujCQpUib4khwW3g317DAQ@public.gmane.org> wrote:
>>
>> =A0 =A0 =A0 But that said , =A0the idea of a /'name' area for this i=
s imo a very good
>> thing . =A0Rather hiding it below others .
>
> Thanks.
>
> One idea that has occurred to me is that maybe /sys is the right plac=
e to put
> this stuff!!! =A0If only sysfs directories could be writeable, I coul=
d write the
> pid file in /sys/class/block/md0/md/mdmon.pid and create a socket wit=
h a
> similar name.

Hmm... we already have /sys/kernel/debug as a simple mount point for
debugfs.  What about adding /sys/kernel/init as a mount point for this
tmpfs?

--
Dan
