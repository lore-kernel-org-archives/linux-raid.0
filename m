From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: I just trashed my RAID5 array - recovery possible?
Date: Thu, 20 Mar 2003 11:20:26 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15993.2378.97234.342504@notabene.cse.unsw.edu.au>
References: <20030320000358.ALLYOURBASEAREBELONGTOUS.A6336@bla.fasel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Wolfram Schlich on Thursday March 20
To: Wolfram Schlich <lists@schlich.org>
Cc: Linux-RAID mailinglist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday March 20, lists@schlich.org wrote:
> Hi,
> 
> I just trashed my RAID5 array. The Promise IDE driver messed up
> sharing IRQs with a network interface card while writing a file to
> the array via the mentioned NIC card.
> Is any recovery possible? I wouldn't care about some lost
> megabytes... really. Thanks in advance!

I recommend:
	mdadm -A /dev/md1 --force /dev/sd[egik]1

NeilBrown
