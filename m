From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: replacing faulty hd
Date: Mon, 28 Oct 2002 09:53:37 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15804.28273.492046.444615@notabene.cse.unsw.edu.au>
References: <200210251430.21466.bernd-schubert@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bernd Schubert on Friday October 25
To: Bernd Schubert <bernd-schubert@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday October 25, bernd-schubert@web.de wrote:
> Hi,
> 
> we have a raid5 with persistent superblock and need to replace one of the 
> harddisks.
> 
> Currently 3 of 4 md-devices (each built from 5 partition of 5 disks) work fine 
> and have full raid5 support, but for md0 only 4 partitions are active.
> 
> What happens if we shutdown the server and replace the faulty disk by a new 
> unpartitioned one ? I'm a bit worried that due to the autostart due to the 
> persistent superblock something could become destroyed.

It should work fine.

> 
> Actually I would prever an kernel parameter to disable raid autostart and 
> first partition the harddisk, but so far I havn't found something like this.
> 

raid=noautodetect

NeilBrown
