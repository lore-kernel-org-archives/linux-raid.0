From: Neil Brown <neilb@suse.de>
Subject: Re: disable creation of md127
Date: Sat, 11 Dec 2010 08:58:59 +1100
Message-ID: <20101211085859.55d0f889@notabene.brown>
References: <4D029DD6.5070705@feystorm.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D029DD6.5070705@feystorm.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Patrick H." <linux-raid@feystorm.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 10 Dec 2010 14:38:30 -0700 "Patrick H." <linux-raid@feystorm.net>
wrote:

> How can I prevent the MD driver from auto-creating md127 on boot?
> I have a server which is exporting /dev/sdb1 via iSCSI. The remote 
> client for this device is using it in a raid device so it has raid 
> metadata on it. However because of this, when the target server boots 
> up, the md driver shoves it into md127. And because of this, the iSCSI 
> target daemon (tgtd) wont export the device as its now part of a raid 
> device.
> The partition type is 0x83, not 0xfd.
> 
> RHEL6 2.6.32-71

The md driver isn't auto-creating this.  
mdadm is being run and being asked to create this, possibly implicitly.

Exactly how you stop this from happening depends on where it is an initrd
script or a boot script that is doing it, and which version of mdadm you have.

If you have 3.0 or later, then putting
   AUTO -all

in mdadm.conf might be enough.
If you have a 2.x, you probably need to tell the init script not to run
mdadm, maybe edit the script, maybe set some default variable.  I know little
about RHEL and so cannot suggest specifics.

NeilBrown

