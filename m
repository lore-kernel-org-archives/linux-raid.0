From: Neil Brown <neilb@suse.de>
Subject: Re: raid1 mysteriously switching to read-only
Date: Sat, 10 Dec 2005 23:10:33 +1100
Message-ID: <17306.50617.458648.8740@cse.unsw.edu.au>
References: <20051128102824.14498.patches@notabene>
	<1051127234104.14937@suse.de>
	<ee0ae26a0512092241v3ee5e445r@mail.gmail.com>
	<17306.31969.240202.416327@cse.unsw.edu.au>
	<ee0ae26a0512092350k43b6dc8l@mail.gmail.com>
	<17306.35737.880103.939683@cse.unsw.edu.au>
	<ee0ae26a0512100010v4d93d107k@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Yanggun on Saturday December 10
Sender: linux-raid-owner@vger.kernel.org
To: Yanggun <yang.geum.seok@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday December 10, yang.geum.seok@gmail.com wrote:
> 
> Should I do format after make RAID-1(/dev/md0) device?

Yes.  format (mkfs) must come AFTER make RAID1 (mdadm -C).
> 
> After I format disks(/dev/sda1, /dev/sdb1), do not you compose to
> RAID-1?

Don't format sda1 or sdb1.  Compose the RAID-1 first, and then format
md0.

NeilBrown
