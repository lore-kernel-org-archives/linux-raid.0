From: "Majed B." <majedb@gmail.com>
Subject: Re: sync_action missing in action in linux-2.6.12 ?
Date: Fri, 11 Sep 2009 01:06:35 +0300
Message-ID: <70ed7c3e0909101506q7565e41cxd71ede871a18d544@mail.gmail.com>
References: <1252617509.4735.19.camel@lgelinas>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1252617509.4735.19.camel@lgelinas>
Sender: linux-raid-owner@vger.kernel.org
To: Louis-Michel Gelinas <coradiant.kernel@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If flashing the firmware to a newer one provides a newer kernel, this
is a better option.

These boxes come very customized and stripped down, so it may be
tricky, if possible, to achieve what you want. If this NAS box has
been around for more than 2 years, someone may have already tinkered
with it. I guess...

On Fri, Sep 11, 2009 at 12:18 AM, Louis-Michel
Gelinas<coradiant.kernel@gmail.com> wrote:
> Hi all,
>
> I bought this neat little NAS box (dlink dns-323).
>
> I runs linux-2.6.12.6 and mdadm 2.5.6
>
> There is a nice community and tools to "hack" it and use it as a
> "normal" linux system.
>
> I would like to run raid1 "repair" and "check" sync_action.
>
> However, I do not have a sync_action file in /sys.
>
> sysfs was not mounted, maybe that is the problem...
>
> There is a /sys folder holding stuff that does not look like a sysfs
> heirachy:
> ls -l /sys
> total 4
> drwxr-xr-x 18 root root =C2=A0197 Mar 27 02:41 crfs
> drwxr-xr-x =C2=A03 root root 1024 Sep =C2=A09 17:29 custom
> drwxr-xr-x =C2=A02 root root 1024 Sep =C2=A09 17:29 mtd1
> drwxr-xr-x =C2=A02 root root 1024 Feb 13 =C2=A02006 mtd2
>
>
> So i did :
> mkdir /sys2
> mount -t sysfs /sys2 /sys2 =C2=A0( This worked, is it proper? =C2=A0)
>
> The structure under /sys2 looks familiar, however, in /sys2/block/md0=
 I
> have no md folder! only :
> /sys2/block/md0 # ls -l
> total 0
> -r--r--r-- 1 root root 4096 Sep 10 09:39 dev
> -r--r--r-- 1 root root 4096 Sep 10 09:39 range
> -r--r--r-- 1 root root 4096 Sep 10 09:39 removable
> -r--r--r-- 1 root root 4096 Sep 10 09:39 size
> -r--r--r-- 1 root root 4096 Sep 10 09:39 stat
>
> I have been reading this list for a few years now and I know I am a
> little off topic and should go to the forums about the dns-323... But=
 I
> found nothing anywhere.
>
> So, am I doing something wrong with sysfs ? Should i assemble the arr=
ay
> after sysfs is mounted? Is there a sync_action in 2.6.12?
>
> Also, is there any other way to trigger the check/repair? I can
> code/compile my own userspace tool to call an ioctl if needed...
>
> Is my only option to write my own scripted sector diff/remap tool?
>
> Upgrading the kernel is an option but requires flashing the firmware,
> something I would rather avoid at this point.
>
>
> any help appreciated.
> lmg
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
