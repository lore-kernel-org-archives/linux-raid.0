From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Advice requested re: hard drive setup for RAID arrays
Date: Thu, 05 Nov 2015 14:02:59 +0800
Message-ID: <563AF113.1020002@fnarfbargle.com>
References: <CAPpdf595q7qsU-3e4rm_9qKKdoOzZi6mVTtrr=Hczqk=UsNf5Q@mail.gmail.com>	<563A0462.9000200@turmel.org> <CAPpdf59BqCABOw=gHw=y8zO-xVzFDn30FLbgqFDjmiBzrgAaHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf59BqCABOw=gHw=y8zO-xVzFDn30FLbgqFDjmiBzrgAaHA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>, Phil Turmel <philip@turmel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/11/15 22:30, o1bigtenor wrote:
>
> Those 2 drives are in a separate USB connected tray.
> When I ran the smartctl* command that you had me run to check the status
> and configuration of the drives it borked on that drive telling me that it was
> connected using USB and I needed to add some other command.

Right. USB is a bit of a strange animal for storage. Different USB-SATA 
interfaces pass or block different commands and it's very vendor 
specific. I'd not have expected that script to work on USB drives 
because it was written to solve *my* particular issue and I don't use 
USB connected drives for anything vaguely critical.

You might be able to get it to work on USB drives, but I'd be very 
surprised if their error recovery behaviour was suitable or deterministic.

This is what it looks like on my system.
root@srv:~# bin/set_sct
/dev/sda  is good Device Model:     SAMSUNG SSD 830 Series
/dev/sdb  is good Device Model:     SAMSUNG SSD 830 Series
/dev/sdc  is good Device Model:     WDC WD20EFRX-68AX9N0
/dev/sdd  is good Device Model:     SAMSUNG SSD 830 Series
/dev/sde  is good Device Model:     WDC WD20EFRX-68EUZN0
/dev/sdf  is good Product:              ST3300655SS
/dev/sdg  is good Product:              ST3300655SS
/dev/sdh  is good Product:              ST3300655SS
/dev/sdi  is good Product:              ST3300655SS
/dev/sdj  is good Device Model:     WDC WD20EARS-60MVWB0
/dev/sdk  is good Device Model:     WDC WD20EARS-60MVWB0
/dev/sdl  is good Device Model:     WDC WD20EARS-60MVWB0
/dev/sdm  is good Device Model:     WDC WD20EARS-60MVWB0
/dev/sdn  is good Device Model:     WDC WD20EARS-60MVWB0
/dev/sdo  is good Device Model:     WDC WD20EARS-60MVWB0
/dev/sdp  is good Device Model:     WDC WD20EFRX-68AX9N0
/dev/sdq  is good Device Model:     WDC WD20EARS-60MVWB0
/dev/sdr  is good Device Model:     WDC WD20EARS-60MVWB0
/dev/sds  is good Device Model:     WDC WD20EFRX-68AX9N0
/dev/sdt  is good Device Model:     WDC WD20EARS-60MVWB0
/dev/sdu  is  bad Device Model:     INTEL SSDSC2CT240A3
/dev/sdv  is  bad Device Model:     INTEL SSDSC2CT240A3
/dev/sdw  is  bad Device Model:     INTEL SSDSC2CT240A3
/dev/sdx  is good Device Model:     WDC WD20EFRX-68AX9N0

Notice all my WD Green drives support ERC. I must have got the very last 
of the drives before they knobbled the firmware.

I iterate *every* drive in the system because every drive in the system 
is part of an array. Again, it was written to scratch my itch and 
possibly serve as an (perhaps bad) example to others.

There are 3 arrays on that system. 6xSSD in a RAID10, 4x15k SAS in a 
RAID10 and 14x2TB SATA in a RAID6. I've experienced catastrophic data 
loss with RAID twice in 10 years. The first time due to a bad IDE 
controller dropping multiple drives and md not being as robust about 
recovery as it is these days (and it was a RADI5), and the second due to 
a SIL PCIe controller silently corrupting writes which gently sprinkled 
corruption across 16TB over a long period. Both times by backups were 
inadequate because I believed RAID==Backup. I know better now.

You need to pay close attention to the whole storage stack to get a 
reliable system. I'd be doing something to replace those USB connections 
with something more suitable, but that's just me.


