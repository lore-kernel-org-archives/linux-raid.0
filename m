From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: md device not unmounting on reboot
Date: Thu, 25 Jul 2002 11:09:50 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15679.20446.54527.572884@notabene.cse.unsw.edu.au>
References: <20020724202553.GD8844@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Micah Anderson on Wednesday July 24
To: Micah Anderson <micah@riseup.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday July 24, micah@riseup.net wrote:
> 
> On particular md device on our system never seems to unmount cleanly
> on a restart. This causes us to have to fsck the device on EVERY boot,
> which is kind of irritating because it is a large partition. 
> 
> Does anyone know why this could be happening and what we can do to
> make it stop?

If you need to fsck, then the filesystem isn't being unmounted, so it
doesn't seem to be a RAID issue.
Presumably something is holding the filesystem active... a process?
and NFS export?  what is using the filesytem.

NeilBrown

> 
> Thanks,
> Micah
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
