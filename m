From: Hendrik Visage <hvisage@envisage.co.za>
Subject: Re: mdadm --assemble --scan hassles....
Date: Thu, 30 Oct 2003 07:56:25 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031030055625.GE3236@hvs.envisage.co.za>
References: <20031008111709.GV1277@hvs.envisage.co.za> <16270.5184.302596.951547@notabene.cse.unsw.edu.au> <20031025212433.GE23767@hvs.envisage.co.za> <16285.38655.754527.236684@notabene.cse.unsw.edu.au> <20031028062445.GD3236@hvs.envisage.co.za> <16288.26356.482079.504183@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <16288.26356.482079.504183@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Hendrik Visage <hvisage@envisage.co.za>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Oct 30, 2003 at 12:18:44PM +1100, Neil Brown wrote:
> 
> Show me:
>  -  your current mdadm.conf
>  - the output of mdadm -Es -c partitions
>  - the output of mdadm -Ds
>  - the output of mdadm -Asv
> 
> And I'll try to tell you.

root@hvstress ~ # mdadm -Es -c partitions
ARRAY /dev/md0 level=raid0 num-devices=2 UUID=832ab839:9920da12:97991965:f9af96e
2
   devices=/dev/scsi/host0/bus0/target1/lun0/part1,/dev/scsi/host0/bus0/target2/
lun0/part1
ARRAY /dev/md1 level=linear num-devices=2 UUID=4478ef04:f7b90666:6a122182:c6b44c
f4
   devices=/dev/md/0,/dev/scsi/host0/bus0/target1/lun0/part2
root@hvstress ~ # mdadm -Ds
ARRAY /dev/md1 level=linear num-devices=2 UUID=4478ef04:f7b90666:6a122182:c6b44c
f4
   devices=/dev/md/0,/dev/scsi/host0/bus0/target1/lun0/part2
ARRAY /dev/md0 level=raid0 num-devices=2 UUID=832ab839:9920da12:97991965:f9af96e
2
   devices=/dev/scsi/host0/bus0/target2/lun0/part1,/dev/scsi/host0/bus0/target1/
lun0/part1
root@hvstress ~ # mdadm -Asv
root@hvstress ~ # cat /etc/mdadm.conf 
DEVICE /dev/md/* /dev/sd[a-z] partitions /dev/md*

ARRAY /dev/md/0 level=raid0 num-devices=2 UUID=832ab839:9920da12:97991965:f9af96
e2
   devices=/dev/scsi/host0/bus0/target1/lun0/part1,/dev/scsi/host0/bus0/target2/
lun0/part1
ARRAY /dev/md/1 level=linear num-devices=2 UUID=c2a91233:5ffd5398:eac27773:e1294
5dd
 devices=/dev/md/0,/dev/scsi/host0/bus0/target1/lun0/part2

