From: Neil Brown <neilb@suse.de>
Subject: Re: Growing Linear RAID
Date: Thu, 10 Dec 2009 12:33:53 +1100
Message-ID: <20091210123353.66100b41@notabene.brown>
References: <8338BD137FF1B64EB341218BD702985E02C8C03B@BLR-EC-MBX03.wipro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8338BD137FF1B64EB341218BD702985E02C8C03B@BLR-EC-MBX03.wipro.com>
Sender: linux-raid-owner@vger.kernel.org
To: senthilkumar.muthukalai@wipro.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 9 Dec 2009 20:31:54 +0530
<senthilkumar.muthukalai@wipro.com> wrote:

> Hi,
> 
> I am trying to add a disk to a Linear Raid which was created with 2
> disks.
> We use linux-2.6.18 and mdadm-2.6.4.
> I guess these support the above mentioned disk addition.

Yes, should work.  This functionality was introduced in 
2.6.18.


> root@NAS00226b1755a0 ~]# mdadm /dev/md0 --grow --add /dev/sata3  

This is the correct usage but,
   
> mdadm: Cannot add new disk to this array

This indicates that something went wrong.

Do you get any messages in the kernel logs at this point?

NeilBrown
