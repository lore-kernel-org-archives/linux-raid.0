From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: "mdadm -n": component device selection when delta_disks<0
Date: Thu, 7 May 2020 21:36:38 +0100
Message-ID: <5EB47156.9050902@youngman.org.uk>
References: <20200507193636.5B4FE53E95@mail.meta-dynamic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200507193636.5B4FE53E95@mail.meta-dynamic.com>
Sender: linux-raid-owner@vger.kernel.org
To: David F <raid@meta-dynamic.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/05/20 20:36, David F wrote:
> I'm planning to use use three mdadm commands to accomplish the
> reshape, as follows:
> 
> mdadm --grow --size=6000G --assume-clean /dev/md0
> mdadm --grow --array-size=12000G /dev/md0
> mdadm --grow --raid-devices=3 --backup-file=/root/md-backup /dev/md0
> 
> 
> Ideally, I'd prefer a single command,
> mdadm --grow --size=6000G --raid-devices=3 /dev/md0
> ... but that seems not possible [1].
> 
> 
> In either case, my question still applies: when reshaping to
> reduce the number of devices in the array (--raid-devices), is
> there any way to specify exactly which device(s) are to be
> removed from active sync (I suppose they become spares) and which
> ones kept? 

You should be able to stick --remove /dev/sdX on the command line ...

BUT. Before you start, what version of mdadm are you running? The
latest? What version of linux? An old LTS with a heavily patched
frankenkernel? You really want to be running both a recent kernel and
recent mdadm.

The other point, if you don't need --backup, DON'T USE IT. It doesn't do
any real harm provided you use it right, but it shouldn't be necessary
and it causes needless confusion and trouble.

Cheers,
Wol
