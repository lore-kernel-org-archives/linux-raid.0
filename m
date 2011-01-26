From: Wolfgang Denk <wd@denx.de>
Subject: Re: Optimize RAID0 for max IOPS?
Date: Wed, 26 Jan 2011 09:42:24 +0100
Message-ID: <20110126084224.4E6E3CEA577@gemini.denx.de>
References: <20110118210112.D13A236C@gemini.denx.de> <20110125171017.GA24921@infradead.org> <20110125184115.1119FB187@gemini.denx.de> <20110125213523.GA14375@infradead.org> <20110126071616.824BEBB0B9@gemini.denx.de> <4D3FDC31.3010502@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4D3FDC31.3010502@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Stan Hoeppner,

In message <4D3FDC31.3010502@hardwarefreak.com> you wrote:
> 
> > # lvcreate -L 32G -n test castor0
> >   Logical volume "test" created
> > # mkfs.xfs /dev/mapper/castor0-test
> 
> Is this on that set of 4 low end Maxtor disks?  Is the above LV sitting atop
> RAID 0, RAID 5, or concatenation?

No, this is the other system, using 6 x Seagate ST31000524NS on a
Marvell MV88SX6081 8-port SATA II PCI-X Controller.

LVM is sitting on top of a RAID6 here:

md2 : active raid6 sda[0] sdi[5] sdh[4] sde[3] sdd[2] sdb[1]
      3907049792 blocks super 1.2 level 6, 16k chunk, algorithm 2 [6/6] [UUUUUU]

> Try adding some concurrency, say 8, to bonnie++ and retest both XFS and ext4.

OK, will do.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
The price of curiosity is a terminal experience.
                         - Terry Pratchett, _The Dark Side of the Sun_
