From: SoulBlazer <soul@lamp-post.net>
Subject: Re: 2 HBA's and Multipath.
Date: Fri, 19 Apr 2002 14:28:29 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020419183049Z312834-22651+12088@vger.kernel.org>
References: <20020408190441Z313735-22651+2113@vger.kernel.org> <20020411094959.GE3256@colombina.comedia.it> <20020419162031Z312453-22651+11469@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20020419162031Z312453-22651+11469@vger.kernel.org>
To: bluca@comedia.it, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Additionally this is an email I wrote to Matthew Jacob describing what im 
doing in more detail:


Subject: FCAL/Linux : Perhaps something different
Date: Fri, 19 Apr 2002 14:25:46 -0400
X-Mailer: KMail [version 1.3.2]
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Status: RO
X-Status: S
 
Hey Matthew,

I would like to start off by thanking you for such a superb Linux qlogic 
isp2x00 driver.  You cannot imagine the headaches I have had trying to get 
the bundled kernel qlogicfc, or the Qlogic 4.27B drivers to work properly.

Now if you would be so kind as to indulge a problem I am wrestling with at 
the moment.

=)


--Intended Goal--
Use Linux/x86 with two Qlogic ISP2100F FCAL HBA's to access an StoreEdge 
a5200 Storage array at 2Gbps* (1Gbps*/HBA).  Accomplish this by trunking / 
bonding / loadbalancing / ? both hba's to both GBIC ports on the array via 
independent private loops.

* The speed being subjective, I'm told that I can expect on average 85%+ 
'real' raw throughput out of these cards.

--Testbed Setup--
I have a Linux Server :

Dual AMD 1.2GHz, Tyan ThunderK7 PCI-64
2x Qlogic ISP2100F HBA's 
Kernel 2.4.18

Connected to: 

Sun StoreEdge A5200, 22 Disk (18.2GB/drive)
2x SES FCAL GBIC Ports

Where : 

HBA 1 (Linux) is wired directly via multimode fibre to A5200 GBIC port 1

and 

HBA 2 (Linux) is wired directly via multimode fibre to A5200 GBIC port 2

--Kernel Snippage--

# insmod isp_mod.o isp_fcduplex=1

ISP SCSI and Fibre Channel Host Adapter Driver
      Linux Platform Version 2.1
      Common Core Code Version 2.5
      Built on Apr 17 2002, 17:41:10
isp0: Board Type 2100, Chip Revision 0x4, loaded F/W Revision 1.19.20
isp0: Installed in 64-Bit PCI slot
isp0: Last F/W revision was 0.789.8224
isp0: NVRAM Port WWN 0x200000e08b02ba29
isp0: Loop ID 11, AL_PA 0xd4, Port ID 0xd4, State 0x2, Topology 'Private Loop'
isp1: Board Type 2100, Chip Revision 0x3, loaded F/W Revision 1.19.20
isp1: Installed in 64-Bit PCI slot
isp1: NVRAM Port WWN 0x200000e08b006999
scsi2 : Driver for a Qlogic ISP 2100 Host Adapter
scsi3 : Driver for a Qlogic ISP 2100 Host Adapter
isp1: Loop ID 125, AL_PA 0x1, Port ID 0x1, State 0x2, Topology 'Private Loop'
scsi::resize_dma_pool: WARNING, dma_sectors=64, wanted=28576, scaling
scsi::resize_dma_pool: WARNING, dma_sectors=64, wanted=21440, scaling
<Description of all the detected Drives>
...

--Notes and Questions--

First off, is what I'm trying to do here even possible ?

Assuming it is, I have tried creating a multipath meta-device via the 
software raid facility in the 2.4 kernel.

--Snippit from /etc/raidtab--
raiddev /dev/md/0
        raid-level      multipath
        nr-raid-disks   2

        device          /dev/scsi/host2/bus0/target0/lun0/part1
        raid-disk       0
        device          /dev/scsi/host3/bus0/target0/lun0/part1
        raid-disk       1

--Snippit from /proc/mdstat--
# : cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [multipath]
read_ahead 1024 sectors

md0 : active multipath scsi/host3/bus0/target0/lun0/part1[0]                  
                                      scsi/host2/bus0/target0/lun0/part1[1]
                                      17688448 blocks [1/1] [U]

Where host2 is the qlogic hba registered as isp0, host3 is the qlogic hba 
registered as isp1, and target0/lun0/part1 is the first detected disk in the 
a5200.

Now I realise that multipath in linux is really meant for failover/HA however 
after discussing this on linux-raid, Luca Berra proposed the following 
modifications to the existing multipath code:

Add "int last_used;"  to struct multipath_private_data in 
"include/linux/raid/multipath.h".

Replace the original multipath_read_balance function in multipath.c
with the following:

static int multipath_read_balance (multipath_conf_t *conf)
{
    int disk;

    for (disk = conf->last_used + 1; disk != conf->last_used; disk++) {
        if (disk > conf->raid_disks)
            disk = 0;
        if (conf->multipaths[disk].operational)
            return disk;
        }
    BUG();
    return 0;
}

I made these changes and recompiled, after which I noticed that while doing a 
dd(1) write to a raid-0 set consisting of multipath volumes the following was 
happening: 

--BEGIN SNIPPIT--
# cd /proc/scsi/isp
# until [ 1 -gt 2 ] ; do grep Request 2 3; sleep 1; done
2: Req In 159   Req Out 158   Result 82 Nactv 0 HiWater 1 QAVAIL 1022 WtQHi 0
3: Req In 222   Req Out 226   Result 82 Nactv 255 HiWater 295 QAVAIL 3 WtQHi 0

2: Req In 159   Req Out 158   Result 82 Nactv 0 HiWater 1 QAVAIL 1022 WtQHi 0
3: Req In 744   Req Out 869   Result 82 Nactv 53 HiWater 295 QAVAIL 124 WtQHi

2: Req In 159   Req Out 158   Result 82 Nactv 0 HiWater 1 QAVAIL 1022 WtQHi 0
3: Req In 1001 Req Out 1016 Result 82 Nactv 295 HiWater 295 QAVAIL 14 WtQHi 0

2: Req In 159   Req Out 158   Result 82 Nactv 0 HiWater 1 QAVAIL 1022 WtQHi 0
3: Req In 592   Req Out 595   Result 82 Nactv 256 HiWater 295 QAVAIL 2 WtQHi 0
--END SNIPPIT--

This confirms that only 1 of my FCAL Hba's (host3/isp1) was doing the work 
(active) while the other (host2/isp0) remained dormant.

Anyhow any feedback you can offer would be appreciated, perhaps I'm going 
about this all wrong or have overlooked something.


Cheers,
-- 
Ex Ignis, Palam Tempestas, Electus Evasto
