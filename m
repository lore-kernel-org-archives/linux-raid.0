From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: RAID0 performance question
Date: Sun, 27 Nov 2005 00:37:28 +0100
Message-ID: <02f101c5f2e2$5f10e2c0$0400a8c0@dcccs>
References: <437E2CB6.2030903@xss.co.at><17282.22120.327672.720044@cse.unsw.edu.au><20051122220531.GU26862@skl-net.de><015c01c5f292$57e0e270$0400a8c0@dcccs> <17288.61257.912938.278958@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,

This is my init script's one part:

blockdev --setra 2048 /dev/nb0
blockdev --setra 2048 /dev/nb1
blockdev --setra 2048 /dev/nb2
blockdev --setra 2048 /dev/nb3
blockdev --setra 2048 /dev/md1
blockdev --setra 2048 /dev/md2
blockdev --setra 2048 /dev/md3
blockdev --setra 2048 /dev/md4
blockdev --setra 4096 /dev/md31

:-)

This is the "default" for me.
The test is have made with this settings.
The problem is somewhere else....

Thanks
Janos

----- Original Message ----- 
From: "Neil Brown" <neilb@suse.de>
To: "JaniD++" <djani22@dynamicweb.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Sunday, November 27, 2005 12:27 AM
Subject: Re: RAID0 performance question


> On Saturday November 26, djani22@dynamicweb.hu wrote:
> > Hello list,
> >
> > I have searching the bottleneck of my system, and found something what i
> > cant cleanly understand.
> >
> > I have use NBD with 4 disk nodes. (raidtab is the bottom of mail)
> >
> > The cat /dev/nb# >/dev/null    makes ~ 350 Mbit/s on each nodes.
> > The cat /dev/nb0 + nb1 + nb2 + nb3 in one time parallel makes ~ 780-800
> > Mbit/s. - i think this is my network bottleneck.
> >
> > But the cat /dev/md31 >/dev/null (RAID0, the sum of 4 nodes) only makes
> > ~450-490 Mbit/s, and i dont know why....
> >
> > Somebody have an idea? :-)
>
> Try increasing the read-ahead setting on /dev/md31 using 'blockdev'.
> network block devices are likely to have latency issues and would
> benefit from large read-ahead.
>
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

