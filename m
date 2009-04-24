From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Fri, 24 Apr 2009 21:15:09 +0200
Message-ID: <20090424191509.GA28484@lazy.lzy>
References: <20090418075436.GA2124@maude.comedia.it> <20090418083609.GA4436@lazy.lzy> <20090418101954.GA1448@maude.comedia.it> <20090418130656.GA3344@lazy.lzy> <18924.3824.677493.129885@notabene.brown> <20090420181736.GB4236@lazy.lzy> <20090420211332.GA5550@maude.comedia.it> <20090421181519.GA4114@lazy.lzy> <1240416414.10178.1.camel@cichlid.com> <9A77DB27-C12A-4BA2-94C4-D59B7DAFF32C@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9A77DB27-C12A-4BA2-94C4-D59B7DAFF32C@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 22, 2009 at 09:20:49PM -0400, Doug Ledford wrote:
>
> # This file causes block devices with Linux RAID (mdadm) signatures to
> # automatically cause mdadm to be run.
> # See udev(8) for syntax
>
> SUBSYSTEM=="block", ACTION=="add", ENV{ID_FS_TYPE}=="linux_raid_member", 
> \
> 	IMPORT{program}="/sbin/mdadm --examine --export $tempnode", \
> 	RUN+="/bin/bash -c '[ ! -f /dev/.in_sysinit ] && mdadm -I  
> $env{DEVNAME}'"

It seems the missing "change" is causing problems too.

In fact, the first time the array is connected (it's
hotpluggable), devices are "added", but the second
time the devices are already there (not removed by
unplug) and there is no "add" anymore, so the array
is not assembled.
If the devices are deleted (rm /dev/md/...), then
it works again (somehow, not really, to be honest).

bye,

-- 

piergiorgio
