From: Neil Brown <neilb@suse.de>
Subject: Re: Raid5 over sbp2 : sbp2 command abort
Date: Tue, 31 Jan 2006 09:09:06 +1100
Message-ID: <17374.36482.175051.360224@cse.unsw.edu.au>
References: <fd8d0180601300550k7316bb14t@mail.gmail.com>
	<43DE7053.1030706@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stefan Richter on Monday January 30
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Francois Barre <francois.barre@gmail.com>, linux1394-devel@lists.sourceforge.net, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday January 30, stefanr@s5r6.in-berlin.de wrote:
> 
> Question to the linux-raid folks: Does md support disks on different 
> SCSI host adapters to be in the same RAID set?
> 

md doesn't notice and doesn't care what the underlying devices are.
It just sees Linux block devices, and sends read/write requests as
appropriate.  Obviously if the different devices are badly mis-matched
you might get poor performance, but it should "work".

NeilBrown
