From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: RAID0 performance question
Date: Sun, 27 Nov 2005 20:02:35 +0100
Message-ID: <009d01c5f385$24d02d70$0400a8c0@dcccs>
References: <437E2CB6.2030903@xss.co.at> <200511271839.16480.a1426z@gawab.com> <001f01c5f36e$9ec7e620$0400a8c0@dcccs> <200511272040.47644.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids


----- Original Message ----- 
From: "Al Boldi" <a1426z@gawab.com>
To: "JaniD++" <djani22@dynamicweb.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Sunday, November 27, 2005 6:40 PM
Subject: Re: RAID0 performance question


> JaniD++ wrote:
> > Al Boldi wrote:
> > > Neil Brown wrote:
> > > > On Saturday November 26, djani22@dynamicweb.hu wrote:
> > > > > The cat /dev/nb# >/dev/null    makes ~ 350 Mbit/s on each nodes.
> > > > > The cat /dev/nb0 + nb1 + nb2 + nb3 in one time parallel makes
> > > > > ~780-800 Mbit/s. - i think this is my network bottleneck.
> > >
> > > How much do you get w/ nb0+1,2,3 and nb0+1+2,3 respectively?
> >
> > I unable to test write, because this is a productive system.
> > Think this value is about 75-80 per node and ~200-250 in md31.
>
> How much do you get with:
> cat nb# + nb# > /dev/null
> cat nb# + nb# + nb# > /dev/null
> respectively?

md1 = 280- 291Mbit
md1+md2 = 450-480 Mbit
md1+md2+md3 = 615-630 Mbit
md1+md2+md3+md4 = now the peak is 674 Mbit....

...on a lightly used online system.  (~44Mbit download + ~60Mbit upload)
This time dd if=/dev/md1 of=/dev/null bs=1M count=4096 what i have used.

I think, this is normal.

I have try the md31 with different readahead settings:

1. nb0,1,2,3 + md1,2,3,4 readahead = 0 and md31 readahead =4096
result: 380 Mbit

2 all readahead . = 0
result:  88-98 Mbit

3. nb0,1,2,3 + md1,2,3,4 readahead = 2048 and md31 readahead = 0
result: 88-96 Mbit   - I wonder! :-O

4. nb# + md# readahead = 0 and md31 readahead = 8192
result: 96-114 Mbit

The winner is my default profile :-D
all 2048 and md31 = 4096

result : 403-423 Mbit

Neil!

What do you say? :-)

>
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

There is no mirrors!
This is only further options!
To be able easy replace, repair one node....

Thanks
Janos

>
> --
> Al

