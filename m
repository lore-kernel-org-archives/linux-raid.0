From: Gordon Henderson <gordon@drogon.net>
Subject: Re: I'm about ready to do SW-Raid5 - pointers needed
Date: Tue, 28 Oct 2003 16:54:51 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0310281644220.25548@unicorn.drogon.net>
References: <3F9DAD4C.3000002@verizon.net> <200310281506.32013.maarten@vbvb.nl>
 <Pine.LNX.4.56.0310281418490.25548@unicorn.drogon.net> <200310281605.30225.maarten@vbvb.nl>
 <3F9E9B4D.4000600@ratnet.stw.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F9E9B4D.4000600@ratnet.stw.uni-erlangen.de>
To: schmidt@naa.net
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 28 Oct 2003, Norman Schmidt wrote:

> I use a plain kernel.org 2.4.22 kernel with tw0 Ultra133 and one
> Ultra100 in one server. It works without problems. Are you sure you
> activated ATA/IDE/MFM/RLL -> IDE, ATA and ATAPI Block devices -> PROMISE
> PDC202(68|69|70|71|75|76|77)?

Absolutely. These board do not work in generic mode. From /var/log/dmesg:

PDC20269: IDE controller at PCI slot 02:05.0
PDC20269: chipset revision 2
PDC20269: not 100% native mode: will probe irqs later
    ide2: BM-DMA at 0x3080-0x3087, BIOS settings: hde:pio, hdf:pio
    ide3: BM-DMA at 0x3088-0x308f, BIOS settings: hdg:pio, hdh:pio
PDC20269: IDE controller at PCI slot 02:07.0
PDC20269: chipset revision 2
PDC20269: not 100% native mode: will probe irqs later
    ide4: BM-DMA at 0x3090-0x3097, BIOS settings: hdi:pio, hdj:pio
    ide5: BM-DMA at 0x3098-0x309f, BIOS settings: hdk:pio, hdl:pio

and from the .config file:

# CONFIG_BLK_DEV_PDC202XX_OLD is not set
# CONFIG_PDC202XX_BURST is not set
CONFIG_BLK_DEV_PDC202XX_NEW=y
# CONFIG_PDC202XX_FORCE is not set
CONFIG_BLK_DEV_PDC202XX=y
# CONFIG_BLK_DEV_ATARAID_PDC is not set

Gordon
