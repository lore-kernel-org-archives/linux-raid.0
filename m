From: Neil Brown <neilb@suse.de>
Subject: Re: RAID grow and disk failure
Date: Fri, 25 Jun 2010 07:57:51 +1000
Message-ID: <20100625075751.4429f224@notabene.brown>
References: <20100624181213.GB9038@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100624181213.GB9038@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 24 Jun 2010 20:12:13 +0200
Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> wrote:

> Hi all,
> 
> I was wondering, let's say a RAID-6 has an HDD
> added and a grow is performed.
> 
> What will happen if one of the HDD of the RAID,
> possibly the newly added, will faili, i.e. die?
> 
> Will the RAID continue the grow using all the
> available parity or it will result in a
> catastrophic failure for the array?

Assuming the code doesn't have any bugs, the reshape will stop, then
immediately restart picking up where it left off.
You will of course end up with a degraded array.

I have tested this so I think the code is fine.
It is fairly easy to set up a free smallish /dev/loop devices and experiment
yourself.  Not only will this give you confidence that it works, but it will
also give you familiarity with with the mdadm commands so there will be less
room for surprises once you do it for-real.

It might be nice in these circumstances to abort the reshape and revert back
the the previous number of devices - particularly if it was the new device
that failed.  However that currently isn't supported.

> 
> As side question, assuming the above RAID volume
> is a PV (LVM physical volume), what would be the
> correct procedure to grow it and extend the PV:
> 
> 1)
> mdadm --grow ...
> mdadm --wait
> pvresize

Yes.

> 
> 2)
> mdadm --grow
> pvresize

No.
Until the reshape has completed, the extra space is not available.

NeilBrown


> 
> Thanks,
> 
> bye,
> 

