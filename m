From: Al Boldi <a1426z@gawab.com>
Subject: Re: RAID0 performance question
Date: Sun, 27 Nov 2005 18:39:16 +0300
Message-ID: <200511271839.16480.a1426z@gawab.com>
References: <437E2CB6.2030903@xss.co.at> <015c01c5f292$57e0e270$0400a8c0@dcccs> <17288.61257.912938.278958@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17288.61257.912938.278958@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Saturday November 26, djani22@dynamicweb.hu wrote:
> >
> > The cat /dev/nb# >/dev/null    makes ~ 350 Mbit/s on each nodes.

Why is this so slow?
Or is this the max node-HD throughput?
What's the node HW config?

> > The cat /dev/nb0 + nb1 + nb2 + nb3 in one time parallel makes ~ 780-800
> > Mbit/s. - i think this is my network bottleneck.

How much do you get w/ nb0+1,2,3 and nb0+1+2,3 respectively?

> > But the cat /dev/md31 >/dev/null (RAID0, the sum of 4 nodes) only makes
> > ~450-490 Mbit/s, and i dont know why....
> >
> > Somebody have an idea? :-)
>
> Try increasing the read-ahead setting on /dev/md31 using 'blockdev'.
> network block devices are likely to have latency issues and would
> benefit from large read-ahead.

Also try larger chunk-size ~4mb.

--
Al

