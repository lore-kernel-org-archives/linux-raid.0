From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Question regarding mdadm and RAID boxes
Date: Mon, 1 Nov 2004 14:06:15 +1100
Message-ID: <16773.43047.28740.455757@cse.unsw.edu.au>
References: <4185A048.1070308@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Cronk on Sunday October 31
Sender: linux-raid-owner@vger.kernel.org
To: Bill Cronk <ngc4013@cox.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday October 31, ngc4013@cox.net wrote:
> 
> Now the question: Is there anything in mdadm allowing one to take a 
> previously setup RAID box from another server and attach it to a second 
> SCSI port and modify only the superblocks to change out the /dev/md0 to 
> /dev/md1 or md2 or ....... so on?
> 

Yes.  --update=super-minor during --assemble

It is best to identify array by "uuid".  Use "mdadm --examine" on
various component devices to discover the uuid or
e.g.
   mdadm --examine --scan --config=partitions

Once you have determined a particular UUID use
e.g.
   mdadm --assemble /dev/mdX --update=super-minor --uuid=ebe07606:c0b4c223:3f00e978:949a6a60  /dev/sd*a

This will find all devices with the right uuid, assemble them in
/dev/mdX (you choose X) and update the superblock to reflect the
correct md number.

NeilBrown
