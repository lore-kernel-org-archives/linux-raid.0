From: Mikhail Balabin <mbalabin@gmail.com>
Subject: Re: polling mdX/md/degraded in sysfs
Date: Sun, 8 Jan 2012 17:37:15 +0600
Message-ID: <CAC9iW=vb5pDNOZBxRGrDujyUdctqBJPUbKZTyDYWbSN+zP2s4g@mail.gmail.com>
References: <CAC9iW=taiG0=JOXcrEDOWKoHswEAp1uRTP2UP=4MepBXNf2Lrg@mail.gmail.com>
 <CAGRgLy5CsmEU_-GnvXH3ffqK4Wnj7V6a_-TWnhA3ysbo2HKGqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5CsmEU_-GnvXH3ffqK4Wnj7V6a_-TWnhA3ysbo2HKGqQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

To trigger my script, I was doing mdadm --fail with my array. I have
not not waited enough time to finish array resync with the script
running. So, it's possible that some events can be caught by the
script. I will check it later to make sure.

Still, md.txt states that "any increase or decrease in the count of
missing devices will trigger an event". It is strange that arguably
the most important event, a disk failure, does not trigger poll. I
think that the behavior specified in documentation is more logical and
the lack of the event may be considered as a (very minor) kernel bug.
I use 2.6.39 Debian-shipped kernel, by the way.

The workaround is simple, though: polling /proc/mdstat works fine for
both disk failure and disk resync event. After the detection of an
event I can read /sys entries, it's much more comfortable than parsing
human-readable /proc/mdstat.

I tried mdadm --monitor first, but it did not fully suit my needs. The
story is, I have been running a raid-1 array on my workstation for
about a year now. Some time ago one of the disks started failing, but
I've noticed the failure a month or so later. So, I decided that I
need a small tool to monitor array's health. I thought that mdadm's
email notification is somewhat clumsy and unreliable solution for a
workstation. mdadm --program can popup a message, but it does not work
if the array is already degraded at startup (if the array was shut
down uncleanly as a result of power failure, for example). mdadm is
typically started before graphical shell, so I could not see a popup
message in this case. So I've hacked a small script displaying a
system tray icon which turns red when something bad happens to my
array. Nice little project to do if you've caught cold and stay home
on new year's holidays :)

Mikhail Balabin

2012/1/8 Alexander Lyakas <alex.bolshoy@gmail.com>:
> Hi,
> well, at least according to 2.6.38-8 kernel code, this attribute is
> notified in 3 cases:
> # When the array is started (e.g., via RUN_ARRAY ioctl)
> # When "reshape" is initiated via sysfs
> # When a spare is activated after successful completion of
> resync/recover/check/replair
>
> If you want to monitor changes in the array, what works for me is the=
 following:
> # Arrange some script/executable to be called by MD monitor
> # Every time your script/executable is called, go and check the
> details you are interested in (e.g., mdadm --detail). The MD monitor
> also provides the description of the event (see man mdadm for possibl=
e
> events), but at least for me it is not always accurate, especially
> when there are several very fast changes in the array.
> # If you want to monitor resync/recover/check/repair progress, you
> need to specify both --delay and --increment options to MD monitor.
>
> Alex.
>
>
> On Thu, Jan 5, 2012 at 10:34 AM, Mikhail Balabin <mbalabin@gmail.com>=
 wrote:
>> Hi!
>>
>> I'm playing around with monitoring software raid status via sysfs
>> entries. In my case it's a raid1 array. According to
>> Documentation/md.txt any md device with redundancy should contain fi=
le
>> "degraded" (for example, /sys/block/md0/md/degraded) with the number
>> of devices by which the arrays is degraded. It is stated that this
>> file can be polled to monitor changes in the array, but it does not
>> work for me. Here is my (stripped-down) python code:
>>
>> import select
>> fileName =3D "/sys/block/md0/md/degraded"
>> epoll =3D select.epoll()
>> while(True):
>> =C2=A0file =3D open(fileName)
>> =C2=A0status =3D file.read()
>> =C2=A0print(status)
>>
>> =C2=A0epoll.register(file.fileno(), select.EPOLLPRI|select.EPOLLERR)
>> =C2=A0epoll.poll()
>> =C2=A0print("=3D=3D=3D=3D poll =3D=3D=3D=3D")
>> =C2=A0epoll.unregister(file.fileno())
>> =C2=A0file.close()
>>
>> The script works fine for /proc/mdstat or /proc/mounts, but does not
>> show any events for /sys/block/md0/md/degraded. Is there a problem i=
n
>> my code? Or is the documentation inaccurate?
>>
>> Mikhail Balabin
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
