From: Sandro Dentella <sandro@e-den.it>
Subject: raid1, cylinder, LBA and inexistent partitions
Date: Mon, 10 Jan 2005 17:51:28 +0100
Message-ID: <20050110165128.GA28377@bluff>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

   A customer of mine have a sistem w/ very simple raid1
   configuration. Yesterday, the UPS has been manually switched off by
   mistake. The system woke up in degraded mode but in a strange way: one of
   the discs does not seem to be partitioned, according to devfs. So that I
   cannot use mdadm to assemble the partition. 

   More: fdisk, cfdisk and /proc do not agree on the unmber of
   cylinders. Only cfdisk sees it as remapped in LBA mode (9964) the others
   see 158816: does that mean anything usefull? Should I change the disk (3
   weeks) or can I try something different?

   Thanks in advance
   sandro
   *:-)

   PS: not to mention that the disk on bus1 was partitioned exactly as the
   other one...

# tree /dev/ide
/dev/ide
`-- host0
    |-- bus0
    |   `-- target0
    |       `-- lun0
    |           |-- disc
    |           |-- part1
    |           |-- part2
    |           |-- part5
    |           |-- part6
    |           `-- part7
    `-- bus1
        |-- target0
        |   `-- lun0
        |       `-- disc
        `-- target1
            `-- lun0
                `-- cd

root@fw-voltimum root # cat /proc/mdstat 
Personalities : [raid1] 
read_ahead 1024 sectors
md0 : active raid1 ide/host0/bus0/target0/lun0/part1[1]
      32000 blocks [2/1] [_U]
      
md1 : active raid1 ide/host0/bus0/target0/lun0/part5[1]
      995904 blocks [2/1] [_U]
      
md2 : active raid1 ide/host0/bus0/target0/lun0/part6[1]
      1951744 blocks [2/1] [_U]
      
md3 : active raid1 ide/host0/bus0/target0/lun0/part7[1]
      77055616 blocks [2/1] [_U]



-- 
Sandro Dentella  *:-)
e-mail: sandro@e-den.it 
http://www.tksql.org                    TkSQL Home page - My GPL work
