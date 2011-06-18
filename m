From: NeilBrown <neilb@suse.de>
Subject: Re: raid6 issues
Date: Sun, 19 Jun 2011 09:01:04 +1000
Message-ID: <20110619090104.0b8c0a51@notabene.brown>
References: <BANLkTi=ky+t1uM0p_HhQPScG78BFxE8Hjw@mail.gmail.com>
	<BANLkTinT48ryUV01cuveutM=mDHLzy0ggg@mail.gmail.com>
	<BANLkTimZ28GKnq41T78NfVPg8s4d9eRkfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimZ28GKnq41T78NfVPg8s4d9eRkfw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chad Walker <chad@chad-cat-lore-eddie.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 18 Jun 2011 12:55:12 -0700 Chad Walker <chad@chad-cat-lore-eddie.com>
wrote:

> also output from "mdadm --assemble --scan --verbose"
> 
> mdadm: looking for devices for /dev/md1
> mdadm: cannot open device /dev/sdp1: Device or resource busy
> mdadm: /dev/sdp1 has wrong uuid.
> mdadm: cannot open device /dev/sdo1: Device or resource busy
> mdadm: /dev/sdo1 has wrong uuid.
> mdadm: cannot open device /dev/sdn1: Device or resource busy
> mdadm: /dev/sdn1 has wrong uuid.
> mdadm: cannot open device /dev/sdm1: Device or resource busy
> mdadm: /dev/sdm1 has wrong uuid.
> mdadm: cannot open device /dev/sdl1: Device or resource busy
> mdadm: /dev/sdl1 has wrong uuid.
> mdadm: cannot open device /dev/sdk1: Device or resource busy
> mdadm: /dev/sdk1 has wrong uuid.
> mdadm: cannot open device /dev/sdj1: Device or resource busy
> mdadm: /dev/sdj1 has wrong uuid.
> mdadm: cannot open device /dev/sdi1: Device or resource busy
> mdadm: /dev/sdi1 has wrong uuid.
> mdadm: cannot open device /dev/sdh1: Device or resource busy
> mdadm: /dev/sdh1 has wrong uuid.
> mdadm: cannot open device /dev/sdg1: Device or resource busy
> mdadm: /dev/sdg1 has wrong uuid.
> mdadm: cannot open device /dev/sdf1: Device or resource busy
> mdadm: /dev/sdf1 has wrong uuid.
> mdadm: cannot open device /dev/sde1: Device or resource busy
> mdadm: /dev/sde1 has wrong uuid.
> mdadm: cannot open device /dev/sdd1: Device or resource busy
> mdadm: /dev/sdd1 has wrong uuid.
> mdadm: cannot open device /dev/sdc1: Device or resource busy
> mdadm: /dev/sdc1 has wrong uuid.
> mdadm: cannot open device /dev/sdb1: Device or resource busy
> mdadm: /dev/sdb1 has wrong uuid.
> 
> 

Try

  mdadm -Ss
the the above --assemble with --force added.

NeilBrown
