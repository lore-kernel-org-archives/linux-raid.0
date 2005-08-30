From: dechris@koli.kando.hu (Deak Krisztian)
Subject: 2 partition kicked from 6 raid5
Date: Tue, 30 Aug 2005 20:10:15 +0200
Message-ID: <20050830181015.GA24181@koli.kando.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

i have a big problem. A had a sw raid5 array with 6 partition. The array
has been damaged because problems of power connectors. 2 partitions/disks don't work,
because during the time the SATA power connections didn't work. 
Some write/read operations where running. Now when i want to
run the array loading the kernel, i get the next message:

raid5: device sdl1 operational as raid disk 0
raid5: device sdj1 operational as raid disk 5
raid5: device sdh1 operational as raid disk 3
raid5: device sdg1 operational as raid disk 2
raid5: not enough operational devices for md0 (2/6 failed)
RAID5 conf printout:
 --- rd:6 wd:4 fd:2
 disk 0, o:1, dev:sdl1
 disk 2, o:1, dev:sdg1
 disk 3, o:1, dev:sdh1
 disk 5, o:1, dev:sdj1
raid5: failed to run raid set md0

I think, that the dammaged partitions have to be used anyway, to get the
datas back.

I attached the result of "mdadm --examine".
Could somebody help me?

Chris     
