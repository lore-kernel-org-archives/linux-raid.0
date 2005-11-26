From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: Re: RAID0 performance question
Date: Sat, 26 Nov 2005 17:56:01 +0200
Message-ID: <5d96567b0511260756t3989df8ep8c98326fc394ca18@mail.gmail.com>
References: <437E2CB6.2030903@xss.co.at>
	 <17282.22120.327672.720044@cse.unsw.edu.au>
	 <20051122220531.GU26862@skl-net.de>
	 <015c01c5f292$57e0e270$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <015c01c5f292$57e0e270$0400a8c0@dcccs>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

look at the cpu consumption.

On 11/26/05, JaniD++ <djani22@dynamicweb.hu> wrote:
> Hello list,
>
> I have searching the bottleneck of my system, and found something what i
> cant cleanly understand.
>
> I have use NBD with 4 disk nodes. (raidtab is the bottom of mail)
>
> The cat /dev/nb# >/dev/null    makes ~ 350 Mbit/s on each nodes.
> The cat /dev/nb0 + nb1 + nb2 + nb3 in one time parallel makes ~ 780-800
> Mbit/s. - i think this is my network bottleneck.
>
> But the cat /dev/md31 >/dev/null (RAID0, the sum of 4 nodes) only makes
> ~450-490 Mbit/s, and i dont know why....
>
> Somebody have an idea? :-)
>
> (the nb31,30,29,28 only possible mirrors)
>
> Thanks
> Janos
>
> raiddev         /dev/md1
> raid-level      1
> nr-raid-disks   2
> chunk-size      32
> persistent-superblock 1
> device          /dev/nb0
> raid-disk       0
> device          /dev/nb31
> raid-disk       1
> failed-disk     /dev/nb31
>
> raiddev         /dev/md2
> raid-level      1
> nr-raid-disks   2
> chunk-size      32
> persistent-superblock 1
> device          /dev/nb1
> raid-disk       0
> device          /dev/hb30
> raid-disk       1
> failed-disk     /dev/nb30
>
> raiddev         /dev/md3
> raid-level      1
> nr-raid-disks   2
> chunk-size      32
> persistent-superblock 1
> device          /dev/nb2
> raid-disk       0
> device          /dev/nb29
> raid-disk       1
> failed-disk     /dev/nb29
>
> raiddev         /dev/md4
> raid-level      1
> nr-raid-disks   2
> chunk-size      32
> persistent-superblock 1
> device          /dev/nb3
> raid-disk       0
> device          /dev/nb28
> raid-disk       1
> failed-disk     /dev/nb28
>
> raiddev         /dev/md31
> raid-level      0
> nr-raid-disks   4
> chunk-size      32
> persistent-superblock 1
> device          /dev/md1
> raid-disk       0
> device          /dev/md2
> raid-disk       1
> device          /dev/md3
> raid-disk       2
> device          /dev/md4
> raid-disk       3
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--
Raz
