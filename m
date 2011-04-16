From: Drew <drew.kay@gmail.com>
Subject: Re: single threaded parity calculation ?
Date: Sat, 16 Apr 2011 06:45:18 -0700
Message-ID: <BANLkTims2gPKdxOo4_dd1NAnOz=CcL6yGQ@mail.gmail.com>
References: <4DA89A18.5010002@mcnair.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DA89A18.5010002@mcnair.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: simon@mcnair.co.uk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> iostat reports 83MB/s for each disk, running up to 830MB/s for all 10 disks,
> but the max read speed of the array is approx 256MB/s.

This may be a dumb question but what motherboard & disk controllers
are you using and how are they setup?

That 256MB/s feels to me like you may be bumping up against a
bandwidth limitation of your bus. PCI (32bit/33MHz) is limited to
133MB/s max and PCIe(1.0/2.0) is limited to 250/500MB/s per lane. To
sustain 830MB/s you need at least a PCIe (1.0) x4 or PCI-X 133
controller card which are both rated for (theoretically) 1GB/s.

As an aside, for read speeds on a RAID-5, the parity disk isn't used
so theoretical maximum in this case is 9x83MB/s or 747MB/s. ;-)


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
