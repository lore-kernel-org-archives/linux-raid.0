From: Guillaume Rousse <rousse@ccr.jussieu.fr>
Subject: Post-install Raid setup
Date: Mon, 10 Jun 2002 17:13:49 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200206101713.49154.rousse@ccr.jussieu.fr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From following 
http://marc.theaimsgroup.com/?l=linux-raid&m=101435499712822&w=2 message, i 
understand this is possible by 
1) setting a up a degraded raid array
2 copying at filesystem level files from normal partitions to raid partitions
3) mouting raid partitions in place normal partitions
4) restoring raid array to normal state

However, the previous mail mention a mdctl tool that is not present in my 
Linux distribution (mdk 8.2). I suppose this is just another raid management 
tool, and that i can safely use mkraid from raidtools instead, provided i set 
my normal partitions as "failed-disk" in /etc/raidtab, as explained in 
http://unthought.net/Software-RAID.HOWTO/Software-RAID.HOWTO-4.html#ss4.4
Am i correct here ?
-- 
Guillaume Rousse <rousse@ccr.jussieu.fr>
GPG key http://lis.snv.jussieu.fr/~rousse/gpgkey.html
