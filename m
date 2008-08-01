From: Neil Brown <neilb@suse.de>
Subject: Re: SLES, not large enough to join array
Date: Fri, 1 Aug 2008 15:16:03 +1000
Message-ID: <18578.39955.3571.303546@notabene.brown>
References: <f3c8d0240807311308k7085724ardf6769d772e00fdc@mail.gmail.com>
	<f3c8d0240807311309i4005357aib7a10584cf741fe6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Diego Ramos on Thursday July 31
Sender: linux-raid-owner@vger.kernel.org
To: Diego Ramos <leituras@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday July 31, leituras@gmail.com wrote:
>  Hi.
> 
> I have a setup with SLES 10 SP2 installed in 1 DELL PowerEdge 2950 attached
> to 5 DELL MD1000 SAS storages (5 TB each).
> 
> I used mdadm to make a single RAID unit of my storages. I'm using RAID 5 to
> prevent data loss if one of the storages fail.
> 
> I had a storage fail. I removed the faulty storage (mdadm /dev/md0 -r
> /dev/sdb1) and restarted the system to replace this storage with a good one.
> 
> 
> The new storage is an exact copy of the faulty one (including internal
> HD's).
> 
> When I tried to add the new storage to my degraded array ( mdadm /dev/md0 -a
> /dev/sdX1), I get the following message: /dev/sdX: not large enough to join
> array.
> 
> I used the same steps in another site (with the same storages, but with only
> 500 GB each) and it worked all right.
> 
> Any suggestions?

Yes. Upgrade :-)

This looks like the bug that was fixed in SLES10-SP2 by an update on
May 9th this year.

The relevant bugzilla is
  https://bugzilla.novell.com/show_bug.cgi?id=368704

There is a patch linked in there.
If you cannot find an upgrade, you could just compile your own mdadm
from the latest source.

NeilBrown
