From: Al Boldi <a1426z@gawab.com>
Subject: Re: RAID0 performance question
Date: Fri, 2 Dec 2005 22:53:17 +0300
Message-ID: <200512022253.17282.a1426z@gawab.com>
References: <437E2CB6.2030903@xss.co.at> <200511272040.47644.a1426z@gawab.com> <041e01c5f605$6a7c0830$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <041e01c5f605$6a7c0830$0400a8c0@dcccs>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

JaniD++ wrote:
> > > > > > But the cat /dev/md31 >/dev/null (RAID0, the sum of 4 nodes)
> > > > > > only makes ~450-490 Mbit/s, and i dont know why....
> > > > > >
> > > > > > Somebody have an idea? :-)
> > > > >
> > > > > Try increasing the read-ahead setting on /dev/md31 using
> > > > > 'blockdev'. network block devices are likely to have latency
> > > > > issues and would benefit from large read-ahead.
> > > >
> > > > Also try larger chunk-size ~4mb.
>
> But i don't know exactly what to try.
> increase or decrease the chunksize?
> In the top layer raid (md31,raid0) or in the middle layer raids (md1-4,
> raid1) or both?
>

What I found is that raid over nbd is highly max-chunksize dependent, due to 
nbd running over TCP.  But increasing chunksize does not necessarily mean 
better system utilization.  Much depends on your application request size.

Tuning performance to maximize cat/dd /dev/md# throughput may only be 
suitable for a synthetic indication of overall performance in system 
comparisons.

If your aim is to increase system utilization, then look for a good benchmark 
specific to your application requirements which would mimic a realistic 
load.

--
Al

