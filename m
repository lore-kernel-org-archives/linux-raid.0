From: Sandro Dentella <sandro@e-den.it>
Subject: Re: udev and mdadm -- I'm lost
Date: Wed, 9 Nov 2005 00:39:47 +0100
Message-ID: <20051108233947.GA24210@casa.e-den.it>
References: <1b9.203c2461.30a28d17@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1b9.203c2461.30a28d17@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> 
> i.e, 
> 
> mdadm -Av -a1 --uuid=xxxxx  /dev/sd*
> or 
> mdadm -Av -a /dev/md1 --uuid=xxxxx /dev/sd*
> 
> I'm not in  the mood to guess... 

here is my personal example

	mdadm --create /dev/md0 -l1 -n2 --auto=yes /dev/sd*


*:-)

-- 
Sandro Dentella  *:-)
e-mail: sandro@e-den.it 
http://www.tksql.org                    TkSQL Home page - My GPL work
