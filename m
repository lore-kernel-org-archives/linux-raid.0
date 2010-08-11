From: Neil Brown <neilb@suse.de>
Subject: Re: weird SparesMissing event
Date: Wed, 11 Aug 2010 21:09:28 +1000
Message-ID: <20100811210928.2785f92b@notabene>
References: <4C624B80.9030304@qumido.de>
	<20100811175711.40cb75c9@notabene>
	<4C62716E.1090902@qumido.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C62716E.1090902@qumido.de>
Sender: linux-raid-owner@vger.kernel.org
To: Tobias Gunkel <tobias.gunkel@qumido.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 11 Aug 2010 11:46:22 +0200
Tobias Gunkel <tobias.gunkel@qumido.de> wrote:

> Am 11.08.2010 09:57, schrieb Neil Brown:
> > This means that /etc/mdadm/mdadm.conf says /dev/md2 has more spare devices
> > than it currently has.  What is in /etc/mdadm/mdadm.conf
> 
> root@MCI03:~# egrep -v '^#|^$' /etc/mdadm/mdadm.conf
> DEVICE partitions
> CREATE owner=root group=disk mode=0660 auto=yes
> HOMEHOST <system>
> ARRAY /dev/md0 UUID=304f5f2a:fbc8082b:54307b3d:1949437b
>    spares=1
> ARRAY /dev/md1 UUID=b263f9c1:5c680152:54307b3d:1949437b
>    spares=1
> ARRAY /dev/md2 UUID=7aa24776:9d6e8d24:54307b3d:1949437b
>    spares=2
> MAILADDR foo@bar.com

As I thought, mdadm.conf says to expect 2 spares, but there is really only
one.  Just edit the file and the message will stop.

> 
> 
> > What do you get if you run
> > 
> >  mdadm --examine --scan --verbose
> 
> root@MCI03:~# mdadm --examine --scan --verbose
> ARRAY /dev/md0 level=raid1 num-devices=2
> UUID=304f5f2a:fbc8082b:54307b3d:1949437b
>    spares=1   devices=/dev/sdc1,/dev/sdb1,/dev/sda1
> ARRAY /dev/md1 level=raid1 num-devices=2
> UUID=b263f9c1:5c680152:54307b3d:1949437b
>    spares=1   devices=/dev/sdc2,/dev/sdb2,/dev/sda2
> ARRAY /dev/md2 level=raid1 num-devices=2
> UUID=7aa24776:9d6e8d24:54307b3d:1949437b
>    spares=2
> devices=/dev/sdc3,/dev/sdc,/dev/sdb3,/dev/sdb,/dev/sda3,/dev/sda
> 
> 
> Hm, md2 contains devices. How is that?

Partition3 on each device must start at a multiple of 64K and extend to then
end of the device.  In this case both the partition and the whole device
appear to have the same metadata, and mdadm cannot tell which is correct.
This is a short-coming of v0.90 metadata and is fixed in v1.x.
You can avoid this by changing the 'device' line in mdadm.conf to

   DEVICE /dev/sd*[0-9]

which essentially means "only partitions of sd devices should be considered
for membership in md arrays".

NeilBrown


> 
> Tobi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

