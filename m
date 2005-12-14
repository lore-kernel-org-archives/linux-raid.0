From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: array size
Date: Wed, 14 Dec 2005 00:54:12 -0500
Message-ID: <200512140554.jBE5sIE11670@www.watkins-home.com>
References: <20051213170953.GO29915@earth.overmeer.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051213170953.GO29915@earth.overmeer.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mark Overmeer' <solutions@overmeer.net>, 'Ming Zhang' <mingz@ele.uri.edu>
Cc: 'Sharif Islam' <mislam@uiuc.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The last disk is not excluded, since the excluded space is used for parity
(xor).

An equal part of all disks is excluded (the parity data).

However, the size is the same as 1 disk being excluded.  :)

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Mark Overmeer
> Sent: Tuesday, December 13, 2005 12:10 PM
> To: Ming Zhang
> Cc: Sharif Islam; linux-raid@vger.kernel.org
> Subject: Re: array size
> 
> * Ming Zhang (mingz@ele.uri.edu) [051213 16:15]:
> > 4 disks, 0 spare, so 3x capacity
> > 586075008 = 3 x 195358336
> >
> > On Tue, 2005-12-13 at 10:01 -0600, Sharif Islam wrote:
> > > Shouldn't the size of the array be around 760GB? It says spare device
> 0.
> 
> > > /dev/md0:
> > >         Version : 00.90.01
> > >   Creation Time : Mon Dec 12 15:56:58 2005
> > >      Raid Level : raid5
> > >      Array Size : 586075008 (558.92 GiB 600.14 GB)
> > >     Device Size : 195358336 (186.31 GiB 200.05 GB)
> 
> The description of the field is a little confusing.  It should read
> "Netto Array Size" or "Available Disk Space" or some.  Then it is clear
> that the last disk is excluded from the shown size.
> --
> Regards,
> 
>                MarkOv
> 
> ------------------------------------------------------------------------
>        Mark Overmeer MSc                                MARKOV Solutions
>        Mark@Overmeer.net                          solutions@overmeer.net
> http://Mark.Overmeer.net                   http://solutions.overmeer.net
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

