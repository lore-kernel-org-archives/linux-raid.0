From: Iakiv Shchelkunov <iakiv.shchelkunov@globallogic.com>
Subject: mdadm monitoring for RAID-1 - no events after pulling out all disks.
Date: Wed, 18 Feb 2015 13:42:06 +0200
Message-ID: <CAMvRQV2Pc4Crv8APkH6XZrLrQcCst7kzoMZ6HBaprbcnG5e3mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello everyone. Please, help me with one mdadm monitoring issue.
I use mdadm 3.2.5 on Debian 7.6. Besides system HDD, I have 2 SSDs
with the same partition table.
I have an array RAID1 over those SSDs with the same partitions in it.
As I need to monitor mdadm errors, I have a tool for monitoring.
So, I do next:
mdadm =E2=80=93assemble /dev/md1 /dev/sda1 /dev/sdb1
            //run the md which was created earlier
mdadm --monitor --daemonize --scan --syslog
--program=3D/usr/local/mdmonitor            //monitoring

The md  /dev/md1 is running, everything is okey.
When I pull out the first SSD and try to write anything on active
array, mdadm calls my program with parameters =E2=80=9CFail=E2=80=9D (o=
r =E2=80=9CFailSpare=E2=80=9D),
the md device name /dev/md1 and partition name, as it=E2=80=99s suppose=
d to
do.
But when I pull out second SSD and there is no one SSD is present,
then try to write data on the md, mdadm doesn=E2=80=99t run my program =
to
inform about fail.
Also /proc/mdstat isn=E2=80=99t changed  =E2=80=93 the array is still =E2=
=80=98active=E2=80=99, even
without any physically present SSD. Of course, I can=E2=80=99t do any w=
rite
operations, I=E2=80=99ve got an error trying to do that, but I have no =
event
from mdadm monitoring.
Has anybody faced with similar troubles? Is there any solution?

Thanks in advance for your time, Iakiv.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
