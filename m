From: Liam Kurmos <quantum.leaf@gmail.com>
Subject: Re: mdadm raid1 read performance
Date: Thu, 5 May 2011 09:49:21 +0100
Message-ID: <BANLkTikvrTSsYKQ3W2eKNjv_+SG6X9_Rxw@mail.gmail.com>
References: <BANLkTim8Ehn0fANtibg7X1cMVvOgt7CNMA@mail.gmail.com>
	<20110504105822.21e23bc3@notabene.brown>
	<BANLkTimzqu1C+_Z2t5m1bjduXFeRwbgssQ@mail.gmail.com>
	<4DC0F2B6.9050708@fnarfbargle.com>
	<BANLkTinbFZf=kV=3eUe2S6XNAOst_McX4w@mail.gmail.com>
	<BANLkTikQTKPuY+Mg8h9ZOkJPoEQ-jGTeLg@mail.gmail.com>
	<20110505100610.66c93e08@natsu>
	<4DC25A71.6090705@oldum.net>
	<BANLkTi=bM6=9ZhA=yOkj3OU=tjCHueWQMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=bM6=9ZhA=yOkj3OU=tjCHueWQMQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nikolay Kichukov <hijacker@oldum.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

from reboot:

zoizoi@shankara:~$ sudo blockdev --getra  /dev/md0
[sudo] password for zoizoi:
256
zoizoi@shankara:~$ sudo blockdev --setra 2048 /dev/md0
zoizoi@shankara:~$ sudo dd if=3D/dev/md0 of=3D/dev/null bs=3D1M count=3D=
4000
4000+0 records in
4000+0 records out
4194304000 bytes (4.2 GB) copied, 7.53149 s, 557 MB/s
zoizoi@shankara:~$ sudo dd if=3D/dev/md0 of=3D/dev/null bs=3D1M count=3D=
4000
4000+0 records in
4000+0 records out
4194304000 bytes (4.2 GB) copied, 0.600264 s, 7.0 GB/s
zoizoi@shankara:~$


Liam


On Thu, May 5, 2011 at 9:39 AM, Liam Kurmos <quantum.leaf@gmail.com> wr=
ote:
> On Thu, May 5, 2011 at 9:06 AM, Nikolay Kichukov <hijacker@oldum.net>=
 wrote:
>> -----BE
>> It seems like he is reading directly from the raid device and not th=
rough the filesystem. So there are no filesystem
>> caches in this way.
>
> phew! =A0... i think (see below)
>
>
> I installed ubuntu 11.04 on the new system last night.
> this morning i went to reconnect the old system drive (id disconnecte=
d
> it for safety) =A0and 'pop' a small piece of metal must have touched =
the
> back of the loose drive and fried the board! ... oh joy.
>
> --luckily its an old drive and i have an identical spare so im hoping
> i can swap the board and save all my work since last git commit.
>
> anyway.. this look different in 11.04. mdadm 3.1.4
>
> /dev/md0:
> =A0Timing buffered disk reads: 594 MB in =A03.00 seconds =3D 197.79 M=
B/sec
> zoizoi@shankara:~$ sudo dd if=3D/dev/md0 of=3D/dev/null bs=3D1M count=
=3D1000
> 1000+0 records in
> 1000+0 records out
> 1048576000 bytes (1.0 GB) copied, 5.84755 s, 179 MB/s
> zoizoi@shankara:~$ sudo dd if=3D/dev/md0 of=3D/dev/null bs=3D1M count=
=3D1000
> 1000+0 records in
> 1000+0 records out
> 1048576000 bytes (1.0 GB) copied, 0.152353 s, 6.9 GB/s
>
> even though im accessing the block device directly it does look like
> im getting buffering in natty! I don't think i was in 10.10 and
> certainly wasnt getting 7GB/s
>
> raid10 f2 performance is right down vs what i got last night (i got
> 470MB/s first try after creating the array so dont think there was
> buffering.
>
> my md1 raid5 was also slow again. readahead on both defaulted down to
> 256 on 11.04
>
> I applied Neil's x8 fix to both md0 and md1 and now the dd test look
> much better.
>
> sudo dd if=3D/dev/md0 of=3D/dev/null bs=3D1M count=3D4000
> 4000+0 records in
> 4000+0 records out
> 4194304000 bytes (4.2 GB) copied, 7.62018 s, 550 MB/s
>
> a little too good!
> i could see in the system monitor that i didnt have the large 4G
> buffer (i do post this test). Something i did must have reset the
> buffer. I could see a small amount of buffer in system monitor so
> maybe it was 1GB. I appreciate these are not the best test but not
> that hdparm is much worse. Once i set the 2048 sector readahead i get=
s
> totally unrealistic.
>
> zoizoi@shankara:~$ sudo blockdev --setra 2048 /dev/md0
> zoizoi@shankara:~$ sudo hdparm -t /dev/md0
>
> /dev/md0:
> =A0Timing buffered disk reads: 5294 MB in =A03.00 seconds =3D 1762.34=
 MB/sec
> zoizoi@shankara:~$ sudo blockdev --setra 256 /dev/md0
> zoizoi@shankara:~$ sudo hdparm -t /dev/md0
>
> /dev/md0:
> =A0Timing buffered disk reads: 582 MB in =A03.00 seconds =3D 193.78 M=
B/sec
>
> anyway, it looks like i'm getting good read speed now with 2048
> lookahead, ill do another dd test on reboot.
>
>
> thanks to you all for the helpful responses,
>
> Liam
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
