From: "Luca Berra" <bluca@comedia.it>
Subject: Re: stacked raid devices not autodetected?
Date: Fri, 3 Dec 2004 16:34:59 +0100 (CET)
Message-ID: <51419.164.129.1.39.1102088099.squirrel@164.129.1.39>
References: <912C966151E990A5186A8A78@pcmy.sei.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <912C966151E990A5186A8A78@pcmy.sei.cmu.edu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On boot, the kernel automatically detects and starts md0 through md4.
> However, md5 is *not* autodetected.  Using the RAID_AUTORUN ioctl also
> has no effect.  The only way I've found to reliably start md5 is to
> have rc.sysinit run "mdadm -assemble --scan".
>
> Is this a bug?  A design limitation?  Something else?
this is one of the limitations of the in-kernel autodetection

> (I am currently using kernel-2.6.9-1.675_EL on the RHEL 4AS beta.  But
> I've never been able to get autodetection of stacked raid devices to
> work using any kernel.)
if you are not booting from the stacked raid device you can safely have
mdadm called from rc.sysinit, if you are you better use mdassemble in
initrd.

Regards,
L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \


