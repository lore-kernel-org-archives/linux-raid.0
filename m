From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: RAID0 performance question
Date: Tue, 22 Nov 2005 02:56:26 +0100
Message-ID: <00fd01c5ef07$f41bf690$a700a8c0@dcccs>
References: <437E2CB6.2030903@xss.co.at><200511272040.47644.a1426z@gawab.com><041e01c5f605$6a7c0830$0400a8c0@dcccs><200512022253.17282.a1426z@gawab.com><00fd01c60367$d8d8f5d0$0400a8c0@dcccs> <17320.45715.533255.759042@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message ----- 
From: "Neil Brown" <neilb@suse.de>
To: "JaniD++" <djani22@dynamicweb.hu>
Cc: "Al Boldi" <a1426z@gawab.com>; <linux-raid@vger.kernel.org>
Sent: Wednesday, December 21, 2005 2:40 AM
Subject: Re: RAID0 performance question


> On Sunday December 18, djani22@dynamicweb.hu wrote:
> >
> > The raid (md) device why dont have scheduler in sysfs?
> > And if it have scheduler, where can i tune it?
>
> raid0 doesn't do any scheduling.
> All it does is take requests from the filesystem, decide which device
> they should go do (possibly splitting them if needed) and forwarding
> them on to the device.  That is all.
>
> > The raid0 can handle multiple requests at one time?
>
> Yes.  But raid0 doesn't exactly 'handle' requests.  It 'directs'
> requests for other devices to 'handle'.
>
> >
> > For me, the performance bottleneck is cleanly about RAID0 layer used
exactly
> > as "concentrator" to join the 4x2TB to 1x8TB.
> > But it is only a software, and i cant beleave it is unfixable, or
> > tunable.
>
> There is really nothing to tune apart from chunksize.
>
> You can tune the way the filesystem/vm accesses the device by setting
> readahead (readahead on component devices of a raid0 has exactly 0
> effect).

First i want to sorry, about "Neil not interested" thing in previous mail...

:-(
I have already try the all available options, including readahead in all
layer (result in earlyer mails), and chunksize.
But with this settings, i cannot workaround this.
And the result is incomprehensible for me!
The raid0 performance is not equal with one component , with sum of all
component , and not equal with the slowest component!

>
> You can tune the underlying devices by choosing a scheduler (for a
> disk drive) or a packet size (for over-the-network devices) or
> whatever.

The NBD has a scheduler, and this is already tuned for really top
performance, and for the components it is really great! :-)
(I have planned to set the NBD to 4KB packets, but this is hard, becaused by
my NICs are not supported the jumbo packets...)

>
> But there is nothing to tune in raid0.
>
>
> Also, rather than doing measurements on the block devices (/dev/mdX)
> do measurements on a filesystem created on that device.
> I have often found that the filesystem goes faster than the block
> device.

I use XFS, and the two performance is almost equal, depends on kind of load.
But in most often case, it is almost equal.

Thanks,
Janos

>
>
> NeilBrown

