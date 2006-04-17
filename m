From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 recovery trouble, bd_claim failed?
Date: Mon, 17 Apr 2006 13:04:15 +1000
Message-ID: <17475.1455.344850.506978@cse.unsw.edu.au>
References: <1145106091.18173.18.camel@nemo.qabal.org>
	<17474.51499.479497.322081@cse.unsw.edu.au>
	<1145242458.18173.49.camel@nemo.qabal.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nathanial Byrnes on Sunday April 16
Sender: linux-raid-owner@vger.kernel.org
To: Nathanial Byrnes <nate@qabal.org>
Cc: Nathanial Byrnes <nate@nemo.qabal.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday April 16, nate@qabal.org wrote:
> Hi Neil,
> 	Thanks for your reply. I tried that, but here is there error I
> received:
> 
> root@finn:/etc# mdadm --assemble /dev/md0
> --uuid=38081921:59a998f9:64c1a001:ec53 4ef2 /dev/hd[efgh]
> mdadm: failed to add /dev/hdf to /dev/md0: Device or resource busy
> mdadm: /dev/md0 assembled from 2 drives and -1 spares - not enough to
> start the array.

What is /dev/hdf busy? Is it in use? mounted? something?

> 
> The output from lsraid against each device is as follows (I think that I
> messed up my superblocks pretty well...): 

Sorry, but I don't use lsraid and cannot tell anything useful from it's
output.

NeilBrown
