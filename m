From: scar <scar-47zfDnpWZoPQT0dZR+AlfA@public.gmane.org>
Subject: Re: help with degraded raid1 array
Date: Tue, 05 Mar 2013 18:49:27 -0700
Message-ID: <kh67ba$2h4$1@ger.gmane.org>
References: <kh2ukl$o1s$1@ger.gmane.org> <alpine.DEB.2.00.1303050559560.14991@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1303050559560.14991-AfpWgHsPmfL18RhVG2q44w@public.gmane.org>
Sender: linux-raid-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

Mikael Abrahamsson @ 03/04/2013 10:03 PM:
> You're getting ABRT and DRDY. Use smartctl to verify that you don't have
> any "pending" or "offline_uncorrectable" sectors on the drives. If they
> are 0, then most likely it's a controller or cabling issue.

thanks. both attributes are 0 for both disks, but i noticed one of the
disks has 3 reallocated sectors and the other has 348.  they have been
powered on for 4.2 years so maybe they are still under seagate's
warranty.  probably need to dust out the insides of the system too...


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
