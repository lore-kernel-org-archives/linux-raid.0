From: Guillaume Filion <gfk@logidac.com>
Subject: Re: Crooked raid
Date: Wed, 16 Nov 2005 18:55:31 -0500
Message-ID: <437BC6F3.5070704@logidac.com>
References: <200511161541.jAGFfBjZ027253@cichlid.com> <437B60B3.5030601@logidac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <437B60B3.5030601@logidac.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guillaume Filion a =E9crit :
> Andrew Burgess a =E9crit :
 >> Do you recall why it didn't want to boot?

I retried to boot and here's the error that I'm getting:
EXT3-fs: unable to read superblock
cramfs: wrong magic

>> Do you know why the system sometimes says=20
>> ide/host0/bus1/target0/lun0/part2 and
>> sometimes says hd[cg]2 ? Its confusing...
>=20
> No, that's something that confuses me too. I installed devfsd sometim=
e=20
> in the past but deinstalled it because I didn't need it.

I decided to resintall devfsd to correct that problem. I think it=20
helped, at least I'm seeing ide/host0/... everywhere now.

One thing that's strange is that mdadm doesn't seem to recognise=20
/dev/md0 (or /dev/md/0) but it's clearly mounted and working...

gfk@ali:~$ sudo mdadm -D /dev/md0
mdadm: md device /dev/md0 does not appear to be active.
gfk@ali:~$ mount
/dev/md/0 on / type ext3 (rw,errors=3Dremount-ro)
/dev/ide/host2/bus0/target0/lun0/part1 on /boot type ext2=20
(rw,errors=3Dremount-ro)
proc on /proc type proc (rw)
devpts on /dev/pts type devpts (rw,gid=3D5,mode=3D620)
tmpfs on /dev/shm type tmpfs (rw)
gfk@ali:~$ cat /proc/mdstat
Personalities : [raid1]
read_ahead not set
md0 : inactive ide/host2/bus1/target0/lun0/part2[0]
       0 blocks
unused devices: <none>

>> And any raid autodetect partitions around?
>>   fdisk -l | grep raid
>=20
> fdisk -l doesn't output anything.

After reinstalling devfds, fdisk -l is working:
gfk@ali:~$ sudo fdisk -l | fgrep raid
/dev/ide/host2/bus1/target0/lun0/part2   *        1276      155061=20
77508144   fd  Linux raid autodetect
/dev/ide/host0/bus1/target0/lun0/part2   *        1276      155061=20
77508144   fd  Linux raid autodetect

--=20
Guillaume Filion, ing. jr
Logidac Tech., Beaumont, Qu=E9bec, Canada - http://logidac.com/
PGP Key and more: http://guillaume.filion.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
