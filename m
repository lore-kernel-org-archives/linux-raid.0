From: Arne Jansen <sensille@gmx.net>
Subject: Raid on USB flash disk
Date: Sat, 10 Feb 2007 19:24:25 +0100
Message-ID: <45CE0DD9.4050009@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I just tried to setup a one-device raid onto an USB flash drive.
Creating, setting up ext3 and filling with data was no problem.
But when I tried to work with it afterwards the metadevice was
unresponsive. I tried both linear and raid0 levels, but that
made no difference.
For my uneducated eye it looks like something is deadlocking if
md tries to read from the device.

I'm using kernel 2.6.18 (gentoo) on a VIA EPIA CN10000 mainboard
with a 2GB USB flash drive (extreme). Please ask if I should provide
more information like dmesg or lspci.

The main reason why I'm trying this weird setup is that the USB
drive is always enumerated last in my kernel, and I want to boot
from it. That means every time I add a disk or remove one I have
to edit grub.conf and fstab. Very inconvenient. So my idea was
to create a single device md on it and leave it to the autodetection
to find the device. So I never have to edit /etc/fstab again for
a simple hardware change and I'm independent of any enumeration
changes in future kernel releases.

But unfortunately it doesn't work :-(

Any help appreciated.

--Arne
