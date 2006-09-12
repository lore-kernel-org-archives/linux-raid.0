From: Henrik Holst <henrik.holst@idgmail.se>
Subject: Re: access *existing* array from knoppix
Date: Tue, 12 Sep 2006 18:38:52 +0200
Message-ID: <4506E29C.7030602@idgmail.se>
References: <200609121352.08834.Dexter.Filmore@gmx.de> <200609121637.53998.Dexter.Filmore@gmx.de> <Pine.LNX.4.64.0609121147370.19418@p34.internal.lan> <200609121829.16513.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200609121829.16513.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>, Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dexter Filmore wrote:
> Am Dienstag, 12. September 2006 17:47 schrieb Justin Piszcz:
>> Strange, what knoppix are you using? I recall doing it to fix an XFS bug
>> with 4.x and 5.x.
> 
> 5.0.1. Maybe they gone udev now and didn't handle md devices.
> I'll see if I can so something in /lib/udev/devices.

Try this:

mdadm -Av /dev/md0 --auto=yes /dev/hda1 /dev/hdb1
                   ^^^^^^^^^^

I have used this with success on many Udev systems. It will create
/dev/md0 automatic.

Henrik Holst
