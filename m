From: Steve Cousins <steve.cousins@maine.edu>
Subject: Re: Raid on USB flash disk
Date: Sat, 10 Feb 2007 13:57:51 -0500
Message-ID: <45CE15AF.5454B3A4@maine.edu>
References: <45CE0DD9.4050009@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Arne Jansen <sensille@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Arne Jansen wrote:
> 
> The main reason why I'm trying this weird setup is that the USB
> drive is always enumerated last in my kernel, and I want to boot
> from it. That means every time I add a disk or remove one I have
> to edit grub.conf and fstab. Very inconvenient. So my idea was
> to create a single device md on it and leave it to the autodetection
> to find the device. So I never have to edit /etc/fstab again for
> a simple hardware change and I'm independent of any enumeration
> changes in future kernel releases.
> 
> But unfortunately it doesn't work :-(

Sorry not to answer your main question but why not use labels in your
USB device partitions and use the labels in your fstab.  This will make
it so it doesn't matter which dev file it uses.

Steve
