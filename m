From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Is there a good reason why I can't "mdadm -Gfn1 /dev/md1" ?
Date: Thu, 9 Jun 2005 08:07:51 +0200
Message-ID: <nu2ln2-tfg.ln1@news.it.uc3m.es>
References: <E1DgFzi-0007K9-00@mta2.cl.cam.ac.uk>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Piete Brooks <Piete.Brooks@cl.cam.ac.uk> wrote:
> I really love having my partitions as RAID1 devices as it allows the actual 
> partition major and minor numbers to change, and allows me to "move" 
> partitions by adding and removing them from the array.

Good idea.

> As such I do this even when there is only one partition. To move it, I can 
> make it a two way mirror, add the new partition, then remove the old. However, 
I think I'd call that "copying", not moving!

> I can't then shrink it back to being a one way mirror. Is there a good reason 
> for this, or is it just not something that was considered sane?
> [ "really" just runs a command as root ]

> bedat-32:~: really mdadm -Gn1 /dev/md1
> mdadm: '1' is an unusual number of drives for an array, so it is probably
>      a mistake.  If you really mean it you will need to specify --force before
>      setting the number of drives.
> bedat-32:~: really mdadm -G --force -n1 /dev/md1
> mdadm: option f not valid in grow mode
> bedat-32:~: really mdadm --force -Gn1 /dev/md1
> mdadm: -G would set mode to grow, but it is already manage.
> bedat-32:~:  mdadm -V
> mdadm - v1.6.0 - 4 June 2004
> bedat-32:~: rpm -q mdadm       
> mdadm-1.6.0-2
> bedat-32:~: 

Well, you could always just remake the mirror with --dangerous-no-resync
using mkraid. I don't know if mdadm permits that. I would have thought
it supported the semantics in mode create or assemble or whatever, just
by virtue of the fact of making an array with one compnent. So try -C
or -A.

Peter

