From: Marek <mlf.conv@gmail.com>
Subject: mdadm format for manual destriping
Date: Sat, 24 Oct 2015 21:28:08 +0200
Message-ID: <CA+sqOsZoJn5arXKBCW6OdLkqRc4sWf_tTRv9MouBOpJEqA9uig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

is there a documentation available on how mdadm stores data? E.g.
1.  super-block
2.  offset of first block on each drive
3. whether mdadm stores blocks as raw data or stores some kind of
metadata associated with each block e.g. disk 1 -> data_block1
immidiatelly followed by data_block 5 or
metadata_for_block_1 | data_block 1 |  metadata_for_block_5 | data_block 5 |
4. how and where mdadm stores its backup superblock
5. what klind of XOR algorithm is used by mdadm

thanks,

Marek
