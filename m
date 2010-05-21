From: Pierre =?utf-8?q?Vign=C3=A9ras?= <pierre@vigneras.name>
Subject: Re: mdadm: failed devices become spares!
Date: Fri, 21 May 2010 23:00:35 +0200
Message-ID: <201005212300.35935.pierre@vigneras.name>
References: <9D.D3.23029.CDD40FB4@cdptpa-omtalb.mail.rr.com> <20100518120637.24d875c9@notabene.brown> <4BF313CC.9030401@shiftmail.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BF313CC.9030401@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: MRK <mrk@shiftmail.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On mercredi 19 mai 2010, MRK wrote:
> On 05/18/2010 04:06 AM, Neil Brown wrote:
> > However if --monitor gets to check the array between the above to e=
vents,
> > it will first see that the working drive is now faulty, so it repor=
ts a
> > failure, and then see that the faulty device isn't faulty any more =
and in
> > fact isn't even there.  The "isn't event there" bit doesn't registe=
r and
> > it treats it as 'SpareActive'.
> >
> > I should fix that.
>=20
> However in one case the two events are not detected in the same round=
:
>=20
> Apr 12 20:10:02 phobos mdadm[3157]: Fail event detected on md device
>  /dev/md2, component device /dev/sdf1
> Apr 12 20:11:02 phobos mdadm[3157]: SpareActive event detected on md =
device
> /dev/md2, component device /dev/sdf1
>=20
>=20
> 1 minute passes between the two entries. I suppose that's the mdadm
> daemon polling time.
>=20
> In the other case all the entries are at the same time
>=20
> Apr 13 08:00:02 phobos mdadm[3157]: Fail event detected on md device
>  /dev/md2, component device /dev/sdd1
> Apr 13 08:00:02 phobos mdadm[3157]: SpareActive event detected on md =
device
> /dev/md2, component device /dev/sdd1
> Apr 13 08:00:02 phobos last message repeated 7 times
> [...many times that messages..]
>=20
>=20
> ...plus, in this second case the SpareActive triggers a lot of times
> within that same second (Pierre you cut it short, but are all the "ma=
ny
> times that messages" all at the exact same time or they span a few
>  seconds?)

Well I was probably  tired when I tried to filter the log for the bug r=
eport.=20
It seems that this 'last message repeated 7 times' is for the:

Apr 13 08:00:02 phobos kernel: [5814019.208017] nfsd: non-standard errn=
o: 5

not for the:

Apr 13 08:00:02 phobos mdadm[3157]: SpareActive event detected on md de=
vice=20
/dev/md2, component device /dev/sdd1

I looked into my log and can't find something else. Sorry, sorry, sorry=
 if=20
this led you to false conclusions.

> It looks to me like some kind of usb failure where the USB connection=
 or
> USB bridge momentarily fails then immediately gets re-detected and
> re-added to the system. But since there are no usb entries in dmesg,
> that would also be an issue of the usb driver. Could the problem also=
 be
> a mixture with some unwise udev triggers of Debian, maybe somehow
> causing the auto-re-add of the drive to the RAID?
>=20
> Pierre:
> - can you post your mdadm.conf?

Sure, but I am not sure it will be useful:

$ cat /etc/mdadm/mdadm.conf
# mdadm.conf
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default, scan all partitions (/proc/partitions) for MD superblocks=
=2E
# alternatively, specify devices to scan, using wildcards if desired.
DEVICE partitions

# auto-create devices with Debian standard permissions
CREATE owner=3Droot group=3Ddisk mode=3D0660 auto=3Dyes

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays
ARRAY /dev/md0 level=3Draid1 num-devices=3D2=20
UUID=3D13f4fdef:db0bd815:77e02d4f:1bda00b4
ARRAY /dev/md1 level=3Draid1 num-devices=3D2=20
UUID=3D4a120782:2ed3053c:e99784b3:b8e5f7bf
ARRAY /dev/md4 level=3Draid1 num-devices=3D2=20
UUID=3Db3c7212a:e95c5081:24bf28c1:396de87f
ARRAY /dev/md2 level=3Draid10 num-devices=3D4=20
UUID=3Db34f4192:f823df58:24bf28c1:396de87f
ARRAY /dev/md3 level=3Draid5 num-devices=3D3=20
UUID=3De1f30f82:0999431b:24bf28c1:396de87f



> - USB is not good for RAID imho. Many times in my life I saw problems
> with USB/SATA bridges where the drive would get disconnected on high =
I/O
> activity and then reconnected after a few seconds. Anyway, readding i=
t
> to the RAID shouldn't have happened. Also in my case there were "usb"
> entries in dmesg.

Well, that is what I discover: USB and RAID is not currently fine (hum,=
 on=20
Debian stable, not sure, we can say 'currently', kernel is:

$ uname -a
Linux phobos 2.6.26-2-686 #1 SMP Tue Mar 9 17:35:51 UTC 2010 i686 GNU/L=
inux
$

).

Anyway, it would be a great feature if USB can be used for a RAID setup=
, at=20
least for end users (actually, I am using in my setup, a "special" layo=
ut for=20
the using of RAID on several heterogeneous drives that I described here=
:

http://www.linuxconfig.org/prouhd-raid-for-the-end-user

)

Thanks for your help and regards.
--=20
Pierre Vign=C3=A9ras
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
