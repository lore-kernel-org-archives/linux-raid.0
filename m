From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: RAID MIA. Again. (Kinda.)
Date: Thu, 4 Mar 2010 17:22:34 -0800
Message-ID: <4877c76c1003041722p5a6d7c13xb2f7f641d6c5e5d9@mail.gmail.com>
References: <ef2f0a4210283390480f4adbd9a547de.squirrel@webmail.jots.org>
	 <20100305075016.51e98363@notabene.brown>
	 <b305ada429c44b2b62b03c101f7ecf0a.squirrel@webmail.jots.org>
	 <4877c76c1003041421s42717938he6567434b74ec125@mail.gmail.com>
	 <e787a69f754f9d4348ebf2d608434f6b.squirrel@webmail.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e787a69f754f9d4348ebf2d608434f6b.squirrel@webmail.jots.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ken D'Ambrosio <ken@jots.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 4, 2010 at 3:41 PM, Ken D'Ambrosio <ken@jots.org> wrote:
> On Thu, March 4, 2010 5:21 pm, Michael Evans wrote:
>> Try providing the output of;
>> for ii in /dev/[sh]d[a-z] ; do parted $ii print ; done
>
> Mea culpa; I'd said:
>
> =A0I went through all 24 permutations of
> =A0mdadm --assemble /dev/md0 /dev/sda2 /dev/sdb2 /dev/sdc2 /dev/sdd2
> =A0since I wasn't sure if the drive order was significant. =A0All of =
them
> =A0"worked," inasmuch as they created /dev/md0, but in all cases it w=
as
> =A0partitionless.
>
> Which I assumed implied that /dev/sd[a-d]2 was valid on all disks, th=
ough,
> in hindsight, I wasn't explicit. =A0So: /dev/sd[a-d]2 exists on all d=
rives
> as partition id "fd" (Linux raid autodetect). =A0It's /dev/md0 that s=
hows as
> a valid, 4.4 TB disk... with no partition.
>
> -Ken

It sounds like you might be interested in this script:

http://www.linuxfoundation.org/collaborate/workgroups/linux-raid/raid_r=
ecovery

It's untested, but it may produce a sequence that shows you valid data.

Also if you 'partitioned' the resulting raid device what you most
likely did was use it as an LVM physical volume, and then create
logical volumes from it.  At least that's the way I'd do it.

After you have /dev/md0 (or whatever) running try running this;

vgscan ; vgdisplay

You might see your 'partitions' listed, at which point you can do a
read-only fsck, then read-only mount and determine if they are in fact
whole, or if they are instead corrupt in that configuration.

If you manually let mdadm guess where to put the devices based on the
stored metadata then it will probably determine the correct order for
you; presuming you haven't already over-written that with invalid
data.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
