From: Mark Overmeer <solutions@overmeer.net>
Subject: Re: array size
Date: Tue, 13 Dec 2005 18:09:53 +0100
Message-ID: <20051213170953.GO29915@earth.overmeer.net>
References: <439EF06E.7050306@uiuc.edu> <1134490533.10254.214.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1134490533.10254.214.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Zhang <mingz@ele.uri.edu>
Cc: Sharif Islam <mislam@uiuc.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

* Ming Zhang (mingz@ele.uri.edu) [051213 16:15]:
> 4 disks, 0 spare, so 3x capacity
> 586075008 = 3 x 195358336
> 
> On Tue, 2005-12-13 at 10:01 -0600, Sharif Islam wrote:
> > Shouldn't the size of the array be around 760GB? It says spare device 0.

> > /dev/md0:
> >         Version : 00.90.01
> >   Creation Time : Mon Dec 12 15:56:58 2005
> >      Raid Level : raid5
> >      Array Size : 586075008 (558.92 GiB 600.14 GB)
> >     Device Size : 195358336 (186.31 GiB 200.05 GB)

The description of the field is a little confusing.  It should read
"Netto Array Size" or "Available Disk Space" or some.  Then it is clear
that the last disk is excluded from the shown size.
-- 
Regards,

               MarkOv

------------------------------------------------------------------------
       Mark Overmeer MSc                                MARKOV Solutions
       Mark@Overmeer.net                          solutions@overmeer.net
http://Mark.Overmeer.net                   http://solutions.overmeer.net

