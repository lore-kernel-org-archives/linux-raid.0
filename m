From: Heinz.Mauelshagen@t-online.de (Heinz J . Mauelshagen)
Subject: Re: [linux-lvm] Re: Changing MD device partition type
Date: Fri, 6 Jun 2003 10:17:56 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030606101756.A26563@sistina.com>
References: <3EDFBB67.5030504@india.hp.com> <20030606065703.GB19765@percy.comedia.it>
Reply-To: mauelshagen@sistina.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030606065703.GB19765@percy.comedia.it>; from bluca@comedia.it on Fri, Jun 06, 2003 at 08:57:04AM +0200
To: prakasha@india.hp.com, linux-raid@vger.kernel.org, linux-lvm@sistina.com
List-Id: linux-raid.ids

On Fri, Jun 06, 2003 at 08:57:04AM +0200, Luca Berra wrote:
> On Thu, Jun 05, 2003 at 02:51:35PM -0700, Prakash Achuthan wrote:
> >I have a software RAID volume (of four 160 GB harddisk) which is to be 
> >added to a separate volume group. Now, when I do a pvcreate (pvcreate 
> >/dev/md3), it fails saying "Invalid phyiscal volume". All the disks in 
> >the RAID volume have their partition type set to "linux auto detect". 
> >One of the mails in a mailing list says that the partition type of the 
> >md0 should be "8e".
> 
> nope, you cant' change the partition type and you don't need to,
> the problem lies somewhere else.
> lvm1 is very picky (serverely broken) about device file names,
> do a lvmdiskscan and or cat /proc/partitions and check which device name
> you find.

Well, that's why device names are handled better in LVM2.

Want to give it a try ? ;)

> if you have devfs compiled in the kernel and not mounted lvm user tools
> will NOT work.
> 
> i cc-ed lvm list which is a better place to ask elp on lvm...
> regards,
> L.
> 
> 
> -- 
> Luca Berra -- bluca@comedia.it
>         Communication Media & Services S.r.l.
>  /"\
>  \ /     ASCII RIBBON CAMPAIGN
>   X        AGAINST HTML MAIL
>  / \
> 
> _______________________________________________
> linux-lvm mailing list
> linux-lvm@sistina.com
> http://lists.sistina.com/mailman/listinfo/linux-lvm
> read the LVM HOW-TO at http://tldp.org/HOWTO/LVM-HOWTO/

-- 

Regards,
Heinz    -- The LVM Guy --

*** Software bugs are stupid.
    Nevertheless it needs not so stupid people to solve them ***

=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

Heinz Mauelshagen                                 Sistina Software Inc.
Senior Consultant/Developer                       Am Sonnenhang 11
                                                  56242 Marienrachdorf
                                                  Germany
Mauelshagen@Sistina.com                           +49 2626 141200
                                                       FAX 924446
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
