From: Alex <mysqlstudent@gmail.com>
Subject: Re: Converting RAID1 to RAID5
Date: Sun, 11 Sep 2011 11:40:57 -0400
Message-ID: <CAB1R3sgXWSCO+=GZf2aY9ktnDuHhauz132O4FN1ZTSbMcthakw@mail.gmail.com>
References: <CAB1R3si_QAtOwfzmYkrUz=+xPO7zSMoZEpO5+oEdXvbUnR1zzw@mail.gmail.com>
	<20110911055703.73deb44d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110911055703.73deb44d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

>> I have a a few two-disk RAID1 partitions that I'd like to convert to
>> three-disk RAID5 partitions using fedora15 with ext4. I've read a fe=
w
>> docs online, but none that are authoritative or current. Some even s=
ay
>> to zero the superblock first, which doesn't sound safe at all.
=2E..
>> Is the general process to first convert the RAID1 to a two-disk RAID=
5,
>> then --add the third disk?
>
> I strongly suggest that you create a couple of loop-back devices and
> experiment.
> ie.
>
> =A0for i in 0 1 2
> =A0do
> =A0 =A0dd if=3D/dev/zero of=3D/tmp/file$i bs=3D1M count=3D100
> =A0 =A0losetup /dev/loop$i /tmp/file$i
> =A0done
>
> =A0mdadm -C /dev/md0 -l1 -n2 -e 1.0 /dev/loop0 /dev/loop1
> =A0mkfs /dev/md0
> =A0mount /dev/md0 /mnt
> =A0cp -r /lib /mnt
>
> =A0then try some things. e.g.
>
> =A0mdadm /dev/md0 --add /dev/loop2
> =A0mdadm --grow /dev/md0 --level=3D5 --raid-devices=3D3
>
> =A0Try failing a device during the reshape. =A0Check if the data is s=
till OK.
> =A0Try it as two separate steps and see if it makes a difference.
>
> Experimenting will give you a lot more confidence than any mount of
> authoritative statements about what it should do.

Yes, definitely. I have an understanding now of what needs to be done,
and am comfortable with mdadm, just not this procedure. I've followed
your steps and they worked successfully.

I just wasn't sure from my reading whether this was a supported
procedure, or whether there were still experimental steps required.

> There was once a tool called raidreconf which would reshape an array =
while it
> is offline. =A0That isn't supported anymore.

Yes, I came across that as well, but sounds like it's just not
necessary any longer because it's so well supported in mdadm itself,
correct?

Thanks,
Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
