From: Andre Hedrick <andre@linux-ide.org>
Subject: Translating /etc/raidtab to mdadm (Re: RAID help ...)
Date: Thu, 10 Apr 2003 02:39:02 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10304100055540.12558-100000@master.linux-ide.org>
References: <16020.42223.970387.800192@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16020.42223.970387.800192@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Neil,

Okay fair point so I will dump this back out for you!

Thanks again for the example translation.


Andre Hedrick
LAD Storage Consulting Group


On Thu, 10 Apr 2003, Neil Brown wrote:

> On Wednesday April 9, andre@linux-ide.org wrote:
> > 
> > Neil,
> > 
> > I need some help with your raid management suite.
> > I have verified that raidstart is a bust!  Then finding your emails about
> > it being a bust!
> > 
> > Can you help?
> > 
> Probably, though I generally suggest people send questions like this
> to linux-raid, partly because someone else might answer more quickly,
> and partly so the Q and A gets archived.
> 
> 
> > #
> > # /etc/raidtab.dba
> > #
> > raiddev /dev/md0
> >         raid-level              1
> >         nr-raid-disks           2
> >         persistent-superblock   1
> >         chunk-size              32
> > 
> >         device                  /dev/sdb1
> >         raid-disk               0
> >         device                  /dev/sdc1
> >         raid-disk               1
> > 
> > mkraid -c /etc/raidtab.dba /dev/md0
> 
> mdadm -C /dev/md0 --level 1 -n 2 -c 32 /dev/sdb1 /dev/sdc1
> 
> > raidstart -c /etc/raidtab.dba /dev/md0
> 
> Several options for this, depending on admin policies, but for a
> one-off machine, I would:
>    echo DEV partitions > /etc/mdadm.conf
>    mdadm --describe --brief /dev/md0 > /etc/mdadm.conf
> 
> edit /etc/mdadm.conf and remove the "devices=" phrase.
> 
> and then whenever you want to start the array:
>    mdadm --assemble --scan /dev/md0
> 
> 
> > raidstop -c /etc/raidtab.dba /dev/md0
> 
>    mdadm --stop /dev/md0
> 
> NeilBrown
> 

