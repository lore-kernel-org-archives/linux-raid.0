From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Creating RAID1 with "missing"  - mdadm 1.90
Date: Sun, 6 Mar 2005 10:17:57 +1100
Message-ID: <16938.15909.711119.913667@cse.unsw.edu.au>
References: <422A2FD1.2010106@panix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from berk walker on Saturday March 5
Sender: linux-raid-owner@vger.kernel.org
To: berk walker <berk@panix.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday March 5, berk@panix.com wrote:
> What might the proper [or functional] syntax be to do this?
> 
> I'm running 2.6.10-1.766-FC3, and mdadm 1.90.

It would help if you told us what you tried as then we could possible
give a more focussed answer, however:


   mdadm --create /dev/md1 --level=raid1 --raid-devices=2 /dev/sda3 missing

might be the sort of thing you want.

NeilBrown

> 
> Thanks for the time.
> b-
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
