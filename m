From: "John Stoffel" <stoffel@lucent.com>
Subject: Re: Half of RAID1 array missing on 2.6.7-rc3
Date: Thu, 5 Aug 2004 16:05:16 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16658.37628.400095.731330@gargle.gargle.HOWL>
References: <16658.16220.904470.117836@gargle.gargle.HOWL>
	<16658.35999.308999.766527@gargle.gargle.HOWL>
	<20040805195229.GD7030@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040805195229.GD7030@percy.comedia.it>
To: linux-raid@vger.kernel.org, Luca Berra <bluca@comedia.it>
List-Id: linux-raid.ids


Luca> how are you using device mapper?
     
To setup some volume groups on top of an MD array of two mirrored
disks.  I think.  All I know currently is that it's required by LVM2
to have it setup and around.  I have /dev/mapper/data_vg-*_lv and some
other devices currently.  All I really want are the LVM2 devices to be
covered.  And since those devices are built on top of /dev/md0 (for
now, might add more later), I don't need other devices looked at.
Period. 

Can you tell me what I'm doing wrong here?

Luca> recent versions of lvm2 ignore md components by default or you
Luca> can specify a filter in the configuration file.

Which file is that?  There's nothing in /etc/dm/... that I can see.
There's some stuff in /etc/lvm/lvm.conf, but I haven't touched that at
all.

Basically, I don't want Device Mapper to scan and take over all my
disks.  From my dmesg file, I see a bunch of these on startup now:

    device-mapper: error adding target to table
    device-mapper: : dm-linear: Device lookup failed

    device-mapper: error adding target to table
    device-mapper: : dm-linear: Device lookup failed

    device-mapper: error adding target to table
    device-mapper: : dm-linear: Device lookup failed

    device-mapper: error adding target to table
    device-mapper: : dm-linear: Device lookup failed

    device-mapper: error adding target to table
    device-mapper: : dm-linear: Device lookup failed

And I don't know where they are coming from.

