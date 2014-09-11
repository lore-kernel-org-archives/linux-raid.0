From: Apple Yin <bravery.apple@gmail.com>
Subject: Howto start reshape from 100% when change readonly raid to readwrite
Date: Thu, 11 Sep 2014 11:06:59 +0800
Message-ID: <CAFvwrujsWB_zdvW0xfoGtOOrH5TH89m9CLEj-fBqn17N88LHpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I met a prolem which confused me long time.
Background:
I have two machines which connected to the same HDDs, both of them are
linux software raid. Machine 1 called Master, Machine 2 called Slave.
Master can readwrite the HDD, Slave can read the HDD only.

/dev/md1 was  created on Master, and level is raid5 with 3 active
disks + 1 spare disk. On slave I assemble the md1 as readonly with the
same disks.Here is my steps:
Create md1(raid5) on Master:
#mdadm --create /dev/md1 -l 5 -n 3 -x 1 /dev/sd[bcde]
Assemble md1(raid5) as readonly on Slave:
#mdadm -A /dev/md1 /dev/sd[bcde] -o


When Master doing the reshape(#mdadm --grow --raid-devices 4 /dev/md1
), Slave need to do the same reshape( #mdadm --grow --raid-devices 4
/dev/md1).But md on Slave is readonly, so md_do_sync() not start.
After Master finish the reshape, all data has moved from 3disks to
4disks. How can I ask Slave's md1 to start the reshape from 100% after
set it to readwrite ? Here is my steps:

1.On Slave, I modify the reshape_position_store() of md.c in kernel,
to let user space to set reshape_position to =E2=80=9Cnone=E2=80=9D (10=
0%):
static ssize_t
reshape_position_store(struct mddev *mddev, const char *buf, size_t len=
)
{
=E2=80=A6
if (cmd_match(buf, =E2=80=9Cnone=E2=80=9D))
;
else if (buf =3D=3D e || (*e && *e !=3D =E2=80=98\n=E2=80=99))
return -EINVAL;

if (cmd_match(buf, =E2=80=9Cnone=E2=80=9D))
mddev->reshape_position =3D MaxSector;
else
mddev->reshape_position =3D new;
=E2=80=A6
}
#echo none > /sys/block/md1/md/reshape_position

2. change readonly raid to readwrite on Slave
#mdadm =E2=80=93readwrite /dev/md1


Result: the reshape didn=E2=80=99t start . Slave's md1 size still the o=
ld size
( with 3 disk size)



BRs,
AppleYin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
