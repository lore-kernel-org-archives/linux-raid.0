From: "Scott D'Vileskis" <sdvileskis@gmail.com>
Subject: Re: Problem Syncing raid1
Date: Thu, 3 Apr 2014 16:48:50 -0400
Message-ID: <CAK_KU4Z9ND2ivU-09qGSTsBAyVToNnUBAzwpGkQpY_M+khwcvg@mail.gmail.com>
References: <BAY177-W404434C6EBAB450FA96A77C86D0@phx.gbl>
	<CADNH=7EwjLirv+zdUKu-Hsrw1djLNpPoz=WSg4pJwUc0giRzOw@mail.gmail.com>
	<BAY177-W961648C4893E888EECA18C86D0@phx.gbl>
	<CAK_KU4bh3S+rwMmJt4_8pyrOYbiLn83BHYabF79c4M59UoW1TA@mail.gmail.com>
	<BAY177-W35793297D3F640EF11F48C86D0@phx.gbl>
	<BAY177-W48FA7C4D5A92389BFC0667C86C0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY177-W48FA7C4D5A92389BFC0667C86C0@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Schmitz <schnet@hotmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Apr 3, 2014 at 3:54 PM, Christian Schmitz <schnet@hotmail.com> wrote:
> Well i do
> dd if=server.img of=/dev/sde2
> where sde is the new disk for server data.
> dd was aborted saying input/output error.
> at 750mb ( 0.7G of 550G of partition)
> So as you say i do
> smartctl -t long /dev/sde2
> It takes 150 minutes.
> After that i do:
> dd if=server.img of=/dev/sde2
> Is running since 6 hours so seem solved 750mb error.
>
> I am starting  the smartctl -t long to all hard disk jejejeje.
>
> Best regards
> Christian
>
be free, be linux
>

When you run the smartctl -t long on a disk, the disk will try to read
everything on the disk (note, the disk performs this test, not the
OS);
Any sectors it has trouble with it will attempt to remap to 'spare'
data reserved on the disk.
Suppose the sector '1234' at the 750GB mark is bad.. After the drive
test remaps it, (or after several read errors in operation) future
read requests of '1234' are answered by the data at the remapped
sector '2345', and since this area of the disk isn't bad (hopefully)
this request is only a slight diversion and completes without errors.

In typical operation, I don't believe the RAID subsystem will wait
long enough for the disk to attempt to re-read and ultimately remap
the data, so it'll throw your array into degraded mode. There are
probably tuning parameters that could use some adjusting to prevent an
occasional bad sector from throwing a RAID offline.

I suspect you'll see your reallocted_sector_count has increased
slightly. I don't usually let a few remapped sectors bother me, it's
when this number starts increasing that you have to start worrying.
Once upon a time I bought about 9 refurbished Seagate 7200.10 drives,
some had bad sectors out of the box, but in 6 years of operation never
had a total drive failure. (Once or twice RAID flagged a disk as bad)

My advice:
a) smartctl -t long on all your drives
b) examine the results of smartctl -a and pay close attention to
reallocated sector counts.
c) offline, power up each of your drives and make a note of any that
are significantly louder than the others.
d) re-add drives you deem safe to your RAID array(s)
