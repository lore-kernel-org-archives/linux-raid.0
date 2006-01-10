From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: Re: raid5 read performance
Date: Tue, 10 Jan 2006 22:05:25 +0200
Message-ID: <5d96567b0601101205o6ecd1987vef0766234940bbf4@mail.gmail.com>
References: <5d96567b0601030616n42d95089pf6422002591b5d78@mail.gmail.com>
	 <Pine.LNX.4.44.0601031533460.14492-100000@coffee.psychology.mcmaster.ca>
	 <5d96567b0601040014y7f1410c3n665fd65aa15f435c@mail.gmail.com>
	 <013a01c6110c$d2353560$a400a8c0@dcccs>
	 <5d96567b0601040549g36de7891w47e7d99afb09e718@mail.gmail.com>
	 <045b01c61178$9efdaad0$a400a8c0@dcccs>
	 <5d96567b0601091525h355b0d75tad6b4710b8355abc@mail.gmail.com>
	 <006701c615d7$b17f74f0$a400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <006701c615d7$b17f74f0$a400a8c0@dcccs>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NBD for network block device ?
why do u use it ?
what type of elevator do you use ?


On 1/10/06, JaniD++ <djani22@dynamicweb.hu> wrote:
>
> ----- Original Message -----
> From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
> To: "JaniD++" <djani22@dynamicweb.hu>
> Cc: "Linux RAID Mailing List" <linux-raid@vger.kernel.org>
> Sent: Tuesday, January 10, 2006 12:25 AM
> Subject: Re: raid5 read performance
>
>
> > 1. it is not good to use so many disks in one raid. this means that in
> > degraded mode
> >     10 disks would be needed to reconstruct one slice of data.
> > 2. i did not understand what is raid purpose.
>
> Yes, i know that.
> In my system, this was the best choise.
>
> I have 4 disk node inside 4x12 Maxtor 200GB (exactly 10xIDE+2xSATA).
> The disk nodes sevres nbd.
> The concentrator joins the nodes with sw-raid0
>
> The system is a generally free web storage.
>
> > 3. 10 MB/s is very slow. what sort of disks do u have ?
>
> 4x(2xSATA+10xIDE) Maxtor 200GB
>
> The system sometimes have 500-800-1000 downloaders at same time.
> In this load, the per node traffic is only 10MB/s. (~100Mbit/s)
>
> First i think the sync/async IO problem.
> At this time i think the bottleneck on the nodes is the PCI-32 with 8 HDD.
> :(
>
> > 4. what is the raid stripe size ?
>
> Currently all raid layers have 32KB chunks.
>
> Cheers,
> Janos
>
> >
> > On 1/4/06, JaniD++ <djani22@dynamicweb.hu> wrote:
> > >
> > > ----- Original Message -----
> > > From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
> > > To: "JaniD++" <djani22@dynamicweb.hu>
> > > Cc: "Linux RAID Mailing List" <linux-raid@vger.kernel.org>
> > > Sent: Wednesday, January 04, 2006 2:49 PM
> > > Subject: Re: raid5 read performance
> > >
> > >
> > > > 1. do you want the code ?
> > >
> > > Yes.
> > > If it is difficult to set.
> > > I use 4 big raid5 array (4 disk node), and the performace is not too
> good.
> > > My standalone disk can do ~50MB/s, but 11 disk in one raid array does
> only
> > > ~150Mbit/s.
> > > (With linear read using dd)
> > > At this time i think this is my systems pci-bus bottleneck.
> > > But on normal use, and random seeks, i am happy, if one disk-node can do
> > > 10MB/s ! :-(
> > >
> > > Thats why i am guessing this...
> > >
> > > > 2. I managed to gain linear perfromance with raid5.
> > > >     it seems that both raid 5 and raid 0 are caching read a head
> buffers.
> > > >     raid 5 cached small amount of read a head while raid0 did not.
> > >
> > > Aham.
> > > But...
> > > I dont understand...
> > > You wrote that, the RAID5 is slower than RAID0.
> > > The read a head buffering/caching is bad for performance?
> > >
> > > Cheers,
> > > Janos
> > >
> > >
> > > >
> > > >
> > > > On 1/4/06, JaniD++ <djani22@dynamicweb.hu> wrote:
> > > > >
> > > > > ----- Original Message -----
> > > > > From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
> > > > > To: "Mark Hahn" <hahn@physics.mcmaster.ca>
> > > > > Cc: "Linux RAID Mailing List" <linux-raid@vger.kernel.org>
> > > > > Sent: Wednesday, January 04, 2006 9:14 AM
> > > > > Subject: Re: raid5 read performance
> > > > >
> > > > >
> > > > > > I guess i was not clear enough.
> > > > > >
> > > > > > i am using raid5 over 3 maxtor disks. the chunk size is 1MB.
> > > > > > i mesured the io coming from one disk alone when I READ
> > > > > > from it with 1MB buffers , and i know that it is ~32MB/s.
> > > > > >
> > > > > > I created raid0 over two disks and my throughput grown to
> > > > > > 64 MB/s.
> > > > > >
> > > > > > Doing the same thing with raid5 ended in 32 MB/s.
> > > > > >
> > > > > > I am using async io since i do not want to wait for several disks
> > > > > > when i send an IO. By sending a buffer which is striped aligned
> > > > > > i am supposed to have one to one relation between a disk and an
> > > > > > io.
> > > > > >
> > > > > > iostat show that all of the three disks work but not fully.
> > > > >
> > > > > Hello,
> > > > >
> > > > > How do you set sync/async io?
> > > > > Please, let me know! :-)
> > > > >
> > > > > Thanks,
> > > > > Janos
> > > > >
> > > > >
> > > > >
> > > >
> > > >
> > > > --
> > > > Raz
> > >
> > >
> >
> >
> > --
> > Raz
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


--
Raz
