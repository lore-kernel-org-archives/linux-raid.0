From: Jaap Winius <jwinius@umrk.nl>
Subject: Re: Can this array be recovered?
Date: Tue, 25 Dec 2012 15:56:38 +0000 (UTC)
Message-ID: <kbcibm$ste$2@ger.gmane.org>
References: <kbb975$nj1$1@ger.gmane.org> <50D9422F.9010403@turmel.org>
	<kbcgf7$ste$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 25 Dec 2012 15:24:23 +0000, Jaap Winius wrote:

> ... pvscan still doesn't see anything on /dev/md1
> and now also mentions "Incorrect metadata area
> header checksum" when run.

The output of this command looks promising:

# pvscan -u
  Incorrect metadata area header checksum
  PV /dev/md2 with UUID 0iEU34-XNSd-vNpu-G3uW-2F1v-wEy9-Bw199N VG 
volgrp3         lvm2 [931.51 GiB / 11.51 GiB free]
  PV /dev/md0 with UUID Lb3KzG-9tZM-5MbQ-1DUa-5ErW-DYf1-NqvMJW VG 
volgrp1         lvm2 [697.70 GiB / 5.44 GiB free]
  PV /dev/md1 with UUID uWDdXr-8fRw-aJDG-SzdQ-
yeIl-6dsv-28vJYs                    lvm2 [697.70 GiB]
  Total: 3 [2.27 TiB] / in use: 2 [1.59 TiB] / in no VG: 1 [697.70 GiB]

That last UUID is still associated with a bunch of volgrp2 objects in my 
current LVM configuration (the old LVM volume on /dev/md1), even though 
pvscan currently doesn't recognize it as such.

Christmas cheers,

Jaap


