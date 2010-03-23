From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: (Re: Questions regarding startup of imsm container)
Date: Tue, 23 Mar 2010 15:41:02 -0700
Message-ID: <e9c3a7c21003231541u705b60a1w9388a8225275dfa4@mail.gmail.com>
References: <7db987b31003222056i46c42112s541ba949821a6759@mail.gmail.com>
	 <20100323080419.GA9374@maude.comedia.it>
	 <7db987b31003230558l5993817fwb283c66bbf3633e9@mail.gmail.com>
	 <7db987b31003230733n127ed0e2u35bbd1de3cb57733@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7db987b31003230733n127ed0e2u35bbd1de3cb57733@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Randy Terbush <randy@terbush.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 23, 2010 at 7:33 AM, Randy Terbush <randy@terbush.org> wrot=
e:
> To follow-up this startup challenge... here is what I am getting.
>
> mdraid is being started with mdadm -As
>
> I have the following in mdadm.conf
>
> HOMEHOST Volume0
> #DEVICE /dev/sd[bcde]
> AUTO +imsm hifi:0 -all
> ARRAY metadata=3Dimsm UUID=3D30223250:76fd248b:50280919:0836b7f0
> ARRAY /dev/md/Volume0 container=3D30223250:76fd248b:50280919:0836b7f0
> member=3D0 UUID=3D8a4ae452:da1e7832:70ecf895:eb58229c
>
> The following devices are being created.
>
> # ls -l /dev/md/
> total 0
> lrwxrwxrwx 1 root root 6 Mar 23 08:10 0 -> ../md0
> lrwxrwxrwx 1 root root 8 Mar 23 08:17 126 -> ../md126
> lrwxrwxrwx 1 root root 8 Mar 23 08:17 127 -> ../md127
> lrwxrwxrwx 1 root root 8 Mar 23 08:17 imsm0 -> ../md127
> lrwxrwxrwx 1 root root 8 Mar 23 08:17 Volume0 -> ../md126
>
> cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [ra=
id4]
> md126 : active raid5 sdb[3] sdc[2] sdd[1] sde[0]
> =A0 =A0 =A02930280448 blocks super external:/md127/0 level 5, 64k chu=
nk,
> algorithm 0 [4/4] [UUUU]
> =A0 =A0 =A0[>....................] =A0resync =3D =A01.8% (18285824/97=
6760320)
> finish=3D182.6min speed=3D87464K/sec
>
> md127 : inactive sde[3](S) sdb[2](S) sdc[1](S) sdd[0](S)
> =A0 =A0 =A09028 blocks super external:imsm
>
> unused devices: <none>
>
> So the container device is getting moved from md0 to md127. Not sure =
why.

You didn't specify a device name for it in the configuration file so
mdadm picked one for you.

> And would sure like to have a write-intent bitmap active to avoid thi=
s
> resync issue which seems to be happening way too frequently.

This could also be a problem with your distribution not taking care of
mdmon properly at shutdown.  The shutdown scripts need to keep mdmon
alive over the final "remounting rootfs readonly" event and wait for
it to mark the array/metadata clean.  Otherwise there is a good chance
that the array will be left dirty and require a resync at startup.

Also note that recent versions of mdadm (3.1.2) and the kernel
(2.6.33) can checkpoint imsm resyncs so at least it will not start
over from the beginning when you reboot in the middle of a resync.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
