From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: polling mdX/md/degraded in sysfs
Date: Sun, 8 Jan 2012 11:06:59 +0200
Message-ID: <CAGRgLy5CsmEU_-GnvXH3ffqK4Wnj7V6a_-TWnhA3ysbo2HKGqQ@mail.gmail.com>
References: <CAC9iW=taiG0=JOXcrEDOWKoHswEAp1uRTP2UP=4MepBXNf2Lrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9iW=taiG0=JOXcrEDOWKoHswEAp1uRTP2UP=4MepBXNf2Lrg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mikhail Balabin <mbalabin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
well, at least according to 2.6.38-8 kernel code, this attribute is
notified in 3 cases:
# When the array is started (e.g., via RUN_ARRAY ioctl)
# When "reshape" is initiated via sysfs
# When a spare is activated after successful completion of
resync/recover/check/replair

If you want to monitor changes in the array, what works for me is the f=
ollowing:
# Arrange some script/executable to be called by MD monitor
# Every time your script/executable is called, go and check the
details you are interested in (e.g., mdadm --detail). The MD monitor
also provides the description of the event (see man mdadm for possible
events), but at least for me it is not always accurate, especially
when there are several very fast changes in the array.
# If you want to monitor resync/recover/check/repair progress, you
need to specify both --delay and --increment options to MD monitor.

Alex.


On Thu, Jan 5, 2012 at 10:34 AM, Mikhail Balabin <mbalabin@gmail.com> w=
rote:
> Hi!
>
> I'm playing around with monitoring software raid status via sysfs
> entries. In my case it's a raid1 array. According to
> Documentation/md.txt any md device with redundancy should contain fil=
e
> "degraded" (for example, /sys/block/md0/md/degraded) with the number
> of devices by which the arrays is degraded. It is stated that this
> file can be polled to monitor changes in the array, but it does not
> work for me. Here is my (stripped-down) python code:
>
> import select
> fileName =3D "/sys/block/md0/md/degraded"
> epoll =3D select.epoll()
> while(True):
> =A0file =3D open(fileName)
> =A0status =3D file.read()
> =A0print(status)
>
> =A0epoll.register(file.fileno(), select.EPOLLPRI|select.EPOLLERR)
> =A0epoll.poll()
> =A0print("=3D=3D=3D=3D poll =3D=3D=3D=3D")
> =A0epoll.unregister(file.fileno())
> =A0file.close()
>
> The script works fine for /proc/mdstat or /proc/mounts, but does not
> show any events for /sys/block/md0/md/degraded. Is there a problem in
> my code? Or is the documentation inaccurate?
>
> Mikhail Balabin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
