From: Massimiliano Masserelli <negro@interim.it>
Subject: Re: RAID1 root - troubles booting in degraded mode
Date: Wed, 30 Oct 2002 21:18:49 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021030201849.GL5337@sgabanaz.interim.it>
References: <20021029230751.GP1472@sgabanaz.interim.it> <200210302118.13644.emilio.gargiulo@infinito.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210302118.13644.emilio.gargiulo@infinito.it>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Oct 30, 2002 at 09:18:13PM +0100, Emilio Gargiulo wrote:

> Have you tryed to set partition id to 0xFD <raid autodetect>, and use
> a boot string as: root=/dev/md1 ro devfs=mount vga=791

Yes, I tried, but to no avail. Creating an initrd image with mdadm in
the startup script solved the issue.

Bye.
-- 
Massimiliano Masserelli
-------------------------------------------------------------------------------
L'importante e` di non fare di tutta la merda un fascio.
                -- Altan
