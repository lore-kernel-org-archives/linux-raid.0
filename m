From: "Donghui Wen" <dhwen@protegonetworks.com>
Subject: Re: 3ware bad write speed.
Date: Sat, 22 Mar 2003 13:36:45 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <008401c2f0bb$231d2b60$df01010a@moon>
References: <8075D5C3061B9441944E137377645118012EA6@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks, Andrew:
    What ATA RAID controllers are you using? Do you have any benchmark data
about sequential write?

Donghui
 
----- Original Message ----- 
From: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
To: "Donghui Wen" <dhwen@protegonetworks.com>; <linux-raid@vger.kernel.org>
Sent: Saturday, March 22, 2003 1:07 PM
Subject: RE: 3ware bad write speed.


> >  I have several questions:
> > 
> >  (1) Does this problem only exists in 3ware ide raid adaptor? 
> > We test SCSI
> > too, it is much faster.
> >      If it is 3ware's driver problem, scsi raid should have the same
> > problem.
> >  (2) Has 3ware fixed this problem yet? They claim they support linux.
> 
> 
> Not sure about these as I have no experience with the 3ware cards
> 
> 
> >  (3) One solution is to setup 3ware in jbod mode and use linux
> > software-raid.
> >      what percentage of CPU used if using software-raid? It 
> > might cost too
> > much CPU power
> >      without using hardware raid.
> 
> I just setup a 26 disk software RAID10 array on Linux and it has put a
> minimal load on the CPU's (my box is a Dell PowerEdge 6600 with quad
> Xeon 1.4GHz with HT enabled).  I will be moving this box to a 52 disk
> software RAID10 setup as soon as I finish testing some kernel patches.
> 
> I can recommend software RAID on Linux without hesitation.  The kernel
> developers have done a great job with MD.
> 
> >  (4) Other than 3ware, is there any better raid card 
> > supported by linux?
> > 
> 
> We moved from hardware to software RAID because we couldn't find a
> hardware card that gave us the performance that we wanted.  I have the
> 52 disk RAID10 array described above setup on some test hardware at work
> and tiobench, with 4 threads and 32KB blocks shows 515MB/s sequential
> reads (ext3 default journaling mode).  And as I said earlier, the load
> on the CPU's is minimal in my setup (OLTP and batch database
> processing).
> 
> 
> >  I appreciate your guys help
> > 
> > 
> > Donghui Wen
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe 
> > linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
