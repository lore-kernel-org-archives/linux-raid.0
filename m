From: Hendrik Visage <hvisage@envisage.co.za>
Subject: Re: mdadm --assemble --scan hassles....
Date: Sat, 25 Oct 2003 23:24:33 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031025212433.GE23767@hvs.envisage.co.za>
References: <20031008111709.GV1277@hvs.envisage.co.za> <16270.5184.302596.951547@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16270.5184.302596.951547@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Hendrik Visage <hvisage@envisage.co.za>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Oct 16, 2003 at 01:45:04PM +1000, Neil Brown wrote:
> On Wednesday October 8, hvisage@envisage.co.za wrote:
> > Right, now if md would do auto detecting on mds then my
> > problem would have disappeared, but alas....
> > 
> > Anycase, I'm trying to make use of mdadm (I've tried different options etc.
> > inside mdadm.conf from what I could see on the mailing list), but I'm still
> > stuck with the following issue:
> > (right after boot):
> > 
> > root@hvstress ~ # mdadm --assemble --scan
> > mdadm: no devices found for /dev/md/1
> 
> That would be because mdadm.conf describes /dev/md/1 as:
>     UUID=c2a91233:5ffd5398:eac27773:e12945dd
> but mdadm --examine doesn't show any arrays with that uuid.
> 
> NeilBrown

Then how do I fix it??

> 
> > root@hvstress ~ # mdadm --examine --scan   
> > ARRAY /dev/md1 level=linear num-devices=2 UUID=8eb3a6c0:02e58fd9:a662938a:56f87147
> >    devices=/dev/md/0,/dev/md/0
> > root@hvstress ~ # mdadm --examine --scan --config=partitions
> > ARRAY /dev/md0 level=raid0 num-devices=2 UUID=832ab839:9920da12:97991965:f9af96e2
> >    devices=/dev/scsi/host0/bus0/target1/lun0/part1,/dev/scsi/host0/bus0/target2/lun0/part1
> > ARRAY /dev/md1 level=linear num-devices=2 UUID=8eb3a6c0:02e58fd9:a662938a:56f87147
> >    devices=/dev/md/0,/dev/scsi/host0/bus0/target1/lun0/part2
> > 
> > root@hvstress ~ # mdadm --assemble --scan   
> > mdadm: no devices found for /dev/md/1
> > root@hvstress ~ # cat /etc/mdadm.conf 
> > DEVICE /dev/md/* /dev/sd*
> > DEVICE /dev/sd[ab]
> > DEVICE /dev/md0 
> > DEVICE /dev/md/0
> > 
> > ARRAY /dev/md/0 level=raid0 num-devices=2 UUID=832ab839:9920da12:97991965:f9af96e2
> >    devices=/dev/scsi/host0/bus0/target1/lun0/part1,/dev/scsi/host0/bus0/target2/lun0/part1
> > ARRAY /dev/md/1 level=linear num-devices=2 UUID=c2a91233:5ffd5398:eac27773:e12945dd
> > 
> > 
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
