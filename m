From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: RAID0 performance question
Date: Sun, 18 Dec 2005 01:13:03 +0100
Message-ID: <00fd01c60367$d8d8f5d0$0400a8c0@dcccs>
References: <437E2CB6.2030903@xss.co.at> <200511272040.47644.a1426z@gawab.com> <041e01c5f605$6a7c0830$0400a8c0@dcccs> <200512022253.17282.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message ----- 
From: "Al Boldi" <a1426z@gawab.com>
To: "JaniD++" <djani22@dynamicweb.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Friday, December 02, 2005 8:53 PM
Subject: Re: RAID0 performance question


> JaniD++ wrote:
> > > > > > > But the cat /dev/md31 >/dev/null (RAID0, the sum of 4 nodes)
> > > > > > > only makes ~450-490 Mbit/s, and i dont know why....
> > > > > > >
> > > > > > > Somebody have an idea? :-)
> > > > > >
> > > > > > Try increasing the read-ahead setting on /dev/md31 using
> > > > > > 'blockdev'. network block devices are likely to have latency
> > > > > > issues and would benefit from large read-ahead.
> > > > >
> > > > > Also try larger chunk-size ~4mb.
> >
> > But i don't know exactly what to try.
> > increase or decrease the chunksize?
> > In the top layer raid (md31,raid0) or in the middle layer raids (md1-4,
> > raid1) or both?
> >
>
> What I found is that raid over nbd is highly max-chunksize dependent, due
to
> nbd running over TCP.  But increasing chunksize does not necessarily mean
> better system utilization.  Much depends on your application request size.
>
> Tuning performance to maximize cat/dd /dev/md# throughput may only be
> suitable for a synthetic indication of overall performance in system
> comparisons.

Yes, you have right!
I already know that. ;-)

But the bottleneck-effect is visible with dd/cat too.  (and i am a litte bit
lazy :-)

Now i try the system with my spare drives, with the bigger chunk size
(=4096K on RAID0 and all RAID1), and the slowness is still here. :(
The problem is _exactly_ the same as previously.
I think unneccessary to try smaller chunk size, because the 32k is allready
small for 2,5,8MB readahead.

The problem is somewhere else... :-/

I have got one (or more) question for the raid list!

The raid (md) device why dont have scheduler in sysfs?
And if it have scheduler, where can i tune it?
The raid0 can handle multiple requests at one time?

For me, the performance bottleneck is cleanly about RAID0 layer used exactly
as "concentrator" to join the 4x2TB to 1x8TB.
But it is only a software, and i cant beleave it is unfixable, or tunable.
;-)

Cheers,
Janos

>
> If your aim is to increase system utilization, then look for a good
benchmark
> specific to your application requirements which would mimic a realistic
> load.
>
> --
> Al
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

