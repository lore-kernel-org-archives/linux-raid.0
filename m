From: "Rene Scherer" <rene@scherer-online.com>
Subject: /proc/mdstat output
Date: Thu, 23 May 2002 11:54:01 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <64718.139.149.1.195.1022151241.squirrel@www.scherer-online.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

I've got a small question about the output of "cat /proc/mdstat"

I've got 3 RAIDs configured (RAID-1 mirror), md0, md1 and md2
When I run "cat /proc/mdstat", I get the following output:

Personalities : [raid1]
read_ahead 1024 sectors
md1 : active raid1 sdb2[1] [dev 08:02][0]
      10241344 blocks [2/2] [UU]

md2 : active raid1 sdb3[1] [dev 08:03][0]
      38130176 blocks [2/2] [UU]

md0 : active raid1 sdb1[1] [dev 08:01][0]
      10241280 blocks [2/2] [UU]

unused devices: <none>

It looks like all 3 arrays are working fine (e.g. [UU]), but only 1
partition is listed (e.g. sdb1[1]). Why is it's mirror sda1 not listed?

Because of this webmin thinks all the sda disk are down. :-(

Any ideas?

Thanks,
Rene



---------------------------------------------------------------------------
Rene Scherer, 12 Bushwood Drive, London SE1 5RE, United Kingdom
Tel: +44 (20) 7232 1867, Fax: +44 (20) 7232 1867
Email: rene@scherer-online.com, Web: http://www.scherer-online.com


