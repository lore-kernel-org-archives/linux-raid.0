From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: RAID0 performance question
Date: Thu, 1 Dec 2005 00:13:37 +0100
Message-ID: <041e01c5f605$6a7c0830$0400a8c0@dcccs>
References: <437E2CB6.2030903@xss.co.at> <200511271839.16480.a1426z@gawab.com> <001f01c5f36e$9ec7e620$0400a8c0@dcccs> <200511272040.47644.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

> > > > > But the cat /dev/md31 >/dev/null (RAID0, the sum of 4 nodes) only
> > > > > makes ~450-490 Mbit/s, and i dont know why....
> > > > >
> > > > > Somebody have an idea? :-)
> > > >
> > > > Try increasing the read-ahead setting on /dev/md31 using 'blockdev'.
> > > > network block devices are likely to have latency issues and would
> > > > benefit from large read-ahead.
> > >
> > > Also try larger chunk-size ~4mb.
> >
> > Ahh.
> > This is what i can't do. :-(
> > I dont know how to backup 8TB! ;-)
>
> Maybe you could use your mirror!?

I have one idea! :-)

I can use the spare drives in the disknodes! :-)

But i don't know exactly what to try.
increase or decrease the chunksize?
In the top layer raid (md31,raid0) or in the middle layer raids (md1-4,
raid1) or both?

Can somebody help me to find the performance problem source?

Thanks,
Janos


>
> --
> Al

