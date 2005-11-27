From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: RAID0 performance question
Date: Sun, 27 Nov 2005 17:21:17 +0100
Message-ID: <001f01c5f36e$9ec7e620$0400a8c0@dcccs>
References: <437E2CB6.2030903@xss.co.at> <015c01c5f292$57e0e270$0400a8c0@dcccs> <17288.61257.912938.278958@cse.unsw.edu.au> <200511271839.16480.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,


----- Original Message ----- 
From: "Al Boldi" <a1426z@gawab.com>
To: "JaniD++" <djani22@dynamicweb.hu>
Cc: <linux-raid@vger.kernel.org>; "Neil Brown" <neilb@suse.de>
Sent: Sunday, November 27, 2005 4:39 PM
Subject: Re: RAID0 performance question


> Neil Brown wrote:
> > On Saturday November 26, djani22@dynamicweb.hu wrote:
> > >
> > > The cat /dev/nb# >/dev/null    makes ~ 350 Mbit/s on each nodes.
>
> Why is this so slow?

Yes. :-)
This system tries to serv about 500-800 downloads.
The final goal is the 1k! ;-)

And this point why i am asking the list, because the HW performance is much
more without raid0 layer. :-/
The 780-800 Mbit is "almost" enough to 1k downloaders.

> Or is this the max node-HD throughput?

Yes.

> What's the node HW config?

P4-3G -HT
12x 200Gb hdd (10 IDE+2 SATA)
2G Ram
realtek gige.

RAID5 inside! ;-)


>
> > > The cat /dev/nb0 + nb1 + nb2 + nb3 in one time parallel makes ~
780-800
> > > Mbit/s. - i think this is my network bottleneck.
>
> How much do you get w/ nb0+1,2,3 and nb0+1+2,3 respectively?

I unable to test write, because this is a productive system.
Think this value is about 75-80 per node and ~200-250 in md31.

>
> > > But the cat /dev/md31 >/dev/null (RAID0, the sum of 4 nodes) only
makes
> > > ~450-490 Mbit/s, and i dont know why....
> > >
> > > Somebody have an idea? :-)
> >
> > Try increasing the read-ahead setting on /dev/md31 using 'blockdev'.
> > network block devices are likely to have latency issues and would
> > benefit from large read-ahead.
>
> Also try larger chunk-size ~4mb.

Ahh.
This is what i can't do. :-(
I dont know how to backup 8TB! ;-)

Thanks,
Janos


>
> --
> Al
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

