From: asho@chuany.net
Subject: Re: Software RAID0 behaviour/performance on ATA drives
Date: Fri, 25 Mar 2005 20:37:23 +0800
Message-ID: <20050325123723.GA3472@acer1200>
References: <4242EAFB.9060008@nospam.com> <16963.37953.872779.652517@cse.unsw.edu.au> <20050325090454.GA8352@acer1200> <16963.57868.98689.304581@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=big5
Content-Disposition: inline
In-Reply-To: <16963.57868.98689.304581@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil

> Right about what?  I don't think that anything that I wrote can
> reasonably be interpreted to say that you can just use one channel
> without losing performance.
> 
> I said "If ... the devices handles the required parallelism".  I don't
> know much in detail about IDE (I use SCSI mostly) but if it is true
> that you cannot talk to a slave and a master at the same time, then
> the drives DO NOT handle the required parallelism, so you don't get
> any parallelism.  
> It is basically completely out of md's hands.  It won't get in the way
> of parallelism, but it won't make it magically happen if the
> drives/controller/drivers cannot make it happen.
> 
> Is that any clearer?  Or did I misunderstand you.
yes, I think I misunderstood first. sorry for that. :-)

I found that some discussion in hardware forums that if UDMA is enabled,
the IDE channel can attach two drivers with a little performance
leakage.

I only tested it with one dvdrw and one dvdrom which attach in the same
channel. The kernel is 2.6 and hdparm -d1 enabled. When I use growisofs
isos to dvdrw and copy data from dvdrom, both of them would slow down
for transfer.

So, I think the IDE isn't parallelism at all. It's better to plug one
driver in an IDE channel. I hope I am not wrong?

Although the IDE and SCSI are different at many perspectives, e.g. SCSI
devices are capable to read/write in the same channel(parallelism).
I still wonder if IDE can do it. 
The IDE cables become a mess while many disks in a box. :-(

Thanks for reply.

Asho Yeh
-- 
    ~    Asho Yeh <asho@debian.org.tw>
   'v'   GnuPG-Key ID: 1CC92D7F
  // \\  Fingerprint: 192B 76FD 5643 6EE7 3DEC  9EAF 3088 48D2 1CC9 2D7F
 /(   )\ 
  ^`~'^
