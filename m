From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: recover short-time-power-failure of raid 5?
Date: Mon, 25 Nov 2002 10:45:22 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15841.25746.94261.22043@notabene.cse.unsw.edu.au>
References: <E18G2yN-0001VC-00@config7.kundenserver.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from krause@mogli-soft.de on Sunday November 24
To: krause@mogli-soft.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday November 24, krause@mogli-soft.de wrote:
> hi folks!
> 
> i am using a small 3-disk software raid on a linux redhat 7.3 system for
> my home directory. 
> never had any problems since today, somehow the power cable of to two of
> my disks dropped (a fan in the case got loose which was connected to the
> same cable!). only some seconds later i shut down the system, switched
> it off and reconneceted the disks. the raid device /dev/md0 was not used
> by the time the power failure happend (i was not logged in, /dev/md0
> only contains /home), so actually there should be no loss of data.
> but how do i tell the system just to reuse the disks? 


 mdadm -A /dev/md0 --force /dev/sda1 /dev/sdb1 /dev/sdc2

NeilBrown
