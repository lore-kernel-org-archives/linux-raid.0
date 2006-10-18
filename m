From: Bruno Costacurta <pubmb02@skynet.be>
Subject: Re: Doubts about array size
Date: Wed, 18 Oct 2006 06:34:18 +0200
Message-ID: <200610180634.19719.pubmb02@skynet.be>
References: <200610172221.49080.pubmb02@skynet.be> <1161123592.3931.3.camel@x1-6-00-0d-60-fd-e8-4c>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1161123592.3931.3.camel@x1-6-00-0d-60-fd-e8-4c>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday 18 October 2006 00:19, Forrest Taylor wrote:
> On Tue, 2006-10-17 at 22:21 +0200, Bruno Costacurta wrote:
> > Hello,
> >
> > I built my first RAID with 2 disks.
> >
> > Array looks active (please see hereafter) but I'm confusing about size :
> > having 2 disks of 160-Gb each I expect a size of 160-Gb (correct ?) but
> > array size seems around 103-Gb.
>
> Your array is not 103-Gb, but 103-Mb.
>
> > Disk /dev/md0: 106 MB, 106823680 bytes
> > 2 heads, 4 sectors/track, 26080 cylinders
> > Units = cylinders of 8 * 512 = 4096 bytes
> >
> > 'mdadm --detail /dev/md0'  :
> > -start-
> > /dev/md0:
> >         Version : 00.90.03
> >   Creation Time : Tue Oct 17 21:26:43 2006
> >      Raid Level : raid1
> >      Array Size : 104320 (101.89 MiB 106.82 MB)
> >     Device Size : 104320 (101.89 MiB 106.82 MB)
>
> What did you do to create the device?  Did you change the disks
> recently, or add new disks?
>
> You could try to grow the RAID (mdadm -G /dev/md0 -z max), but I would
> be wary of doing that until I knew why the disks showed the small size.
>
> Forrest

Hello,
looks better now...
It seems my previous fdisk commands to set type 'Linux raid autodetect' were 
incorrect because not completely removed previous partitions.
Size looks correct.
...
mdadm --misc --detail /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Tue Oct 17 23:24:25 2006
     Raid Level : raid1
     Array Size : 154304192 (147.16 GiB 158.01 GB)
    Device Size : 154304192 (147.16 GiB 158.01 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Oct 18 06:20:20 2006
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : c27fb118:876d28b2:47dd7e83:d14c4332
         Events : 0.12

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
...

Bye,
Bruno

