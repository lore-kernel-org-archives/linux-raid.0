From: "Scott D'Vileskis" <sdvileskis@gmail.com>
Subject: Re: Nvidia Raid5 Failure
Date: Thu, 10 Apr 2014 10:36:32 -0400
Message-ID: <CAK_KU4ZHZik=_=2=fMPW1c_y-xc0DW_9=ucsYQXU2e=eSOtYQg@mail.gmail.com>
References: <DUB122-W521994A2683B8CBD327D3DA3550@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <DUB122-W521994A2683B8CBD327D3DA3550@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: peter davidson <merrymeetpete@hotmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I would advise keeping operating systems off RAID arrays in general,
Windows or Linux, because most bootloaders are loaded to a single
disk. If *that disk fails, you may not be able to boot, even if your
RAID is in degraded mode. Having your data on the RAID and a separate
OS disk allows troubleshooting with OS tools (NVIDIA's toolkit in
Windows, MDADM in Linux, or microsoft's disk manager in Windows).  I
would also advise against what is known as 'fake raid' controllers
like your NVIDIA hardware likely is, (or Promise, highpoint, Intel,
etc)  because it can be difficult to recover data if you have a
controller/mobo failure without exact hardware.

For Setting up Linux, I would advise picking up a 64 or 120GB SSD,
(even a 16/32GB would be enough). For your first steps in Linux, I
would go with a flavor of Ubuntu Linux. (XUbuntu is really nice, and
doen't have the bastardized Unity desktop environment). From most
modern Linux distros, you can setup RAID arrays at install time, or
wait until your desktop is up and running and do it from GUI tools

Another idea is to grab a diskless NAS appliance like a Lenovo/Iomega
IX4 300D or a Synology for $200-400 and move your disks over. (You'll
likely have to back up all your data and wipe your disks though). I
like the Lenovo/Iomega product because is uses a custom build of
Debian Linux and linux software RAID, which I could always recover in
my linux Desktop if I had a NAS hardware failure.

Good luck!

On Thu, Apr 10, 2014 at 1:00 AM, peter davidson
<merrymeetpete@hotmail.com> wrote:
> Hi Folks,
>
> My computer suddenly shut down due to a failed memory module - damaging the 1.8TB RAID5 array of three disks.
>
> The computer was able to boot with a degraded array (Windows 7 OS was on the array) but I was unable to get the array to rebuild using the Nvidia toolset - either at BIOS level or in Windows 7. Now the computer will not boot from the array.
>
> I had something very similar to this happen a few weeks ago when the mother board failed - I was able to limp things along to get a backup of all important data.
>
> I am interested to know if LINUX will be able to recover the array for me this time. Having got part way through this process before on the previous failure (which led me to this forum), I am keen to follow this through as an exercise knowing I have a backup of the really important stuff.
>
> I intend to build LINUX onto a new disk and work through this in the coming days - what would be my best choice of distro for this exercise? I am hoping to find something that has all the relevant tools and is relatively simple to get up and running with a friendly GUI to help me navigate round.
>
> I used to work on various databases running on UNIX servers so I hope I can still can find my way round a terminal window.
>
> Thanks in advance for any support anyone can offer me!
>
> Regards,
>
> Peter.
>                                           --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
