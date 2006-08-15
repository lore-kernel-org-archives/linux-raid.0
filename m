From: Luca Berra <bluca@comedia.it>
Subject: Re: Making bootable SATA RAID1 array in Mandriva 2006
Date: Tue, 15 Aug 2006 13:57:24 +0200
Message-ID: <20060815115724.GG21221@percy.comedia.it>
References: <44DFBB0E.90705@aol.com> <44E07D03.9020802@lesagepono.be> <44E08E41.4090705@aol.com> <44E0932B.8040801@lesagepono.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <44E0932B.8040801@lesagepono.be>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Aug 14, 2006 at 05:13:47PM +0200, Laurent Lesage wrote:
>Hi Andy,
>
>there are options for the "mkinitrd" command, that are like the 
>parameters in "mkinitrd.conf" (this is the case in "Debian"). did you 
>use the -root=xxx option?

Laurent, 
mkinitrd in debian and mandriva are two completely different beasts,
there is no relation between those two.

besides that, i believe that all Andy has to do for mkinitrd is mounting
/sys on the chroot before running mkinitrd.

there is no mkinitrd.conf on mandriva.
mkinitrd will use fstab to find the root filesystem, so the change Andy
did is correct.

and please, please, stop top-posting and try to quote relevant parts of
messages when answering, or the thread will become unreadable.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
