From: "Andreas Pelzner" <Andreas.Pelzner@aixvision.net>
Subject: RE: md: only binds to one mirror after reboot
Date: Mon, 28 Aug 2006 15:54:42 +0200
Message-ID: <C05CC316E92A964C9BDD81EE36AE05343C7075@x2k3.a-team.ihs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

thanks a lot,

you told me the rigt way. I had to add the lines "raid1" and "md_mod" to
/etc/mkinitrd/modules. After recreating the initrd image "mkinitrd -o
/boot/initrd.img-2.6.17.8 /lib/modules/2.6.17.8" the server boots into
both raid disk correctly.

isp:~# cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 hda1[0] hdb1[1]
      154191744 blocks [2/2] [UU]

unused devices: <none>

Andreas Pelzner
> 
> On Monday August 28, Andreas.Pelzner@aixvision.net wrote:
> > Pls. find the kernel messages here.
> 
> Thanks.
> 
> 'md' and the drivers for you disks are not compiled into the kernel
> but are present as modules in an 'initrd'.
> So the kernel parameter or
>   md=0,/dev/hda1,/dev/hdb1
> is ignored and the code in the inird is completely responsible for
> assembling md0.
> You have a look at what it does:
>   
>   mkdir /foo
>   mount -t cramfs /initrd.img  /foo
>                   ^^^^^^^^^^^
> 
> You have to find the initrd that is being used and use that name here.
> Then have a look at etc mdadm.conf in /foo.
> 
> Once you understand the problem you will need to remake your initrd to
> get this right.
> 
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
