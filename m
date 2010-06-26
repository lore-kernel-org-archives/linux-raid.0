From: Shaochun Wang <scwang@ios.ac.cn>
Subject: RAID5 write hole?
Date: Sat, 26 Jun 2010 22:31:25 +0800
Message-ID: <20100626143125.GA1010@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi:

Recently I heard of the so called "write hole" problem of raid5 in
Linux software raid. I use ext4 filesystem on my NAS, which assembles
data disks using Linux software raid. So I wonder how safe my such
system!

If the "write hole" is inevitable, will it result in the corruption of
ext4 filesystem? 

-- 
Shaochun Wang <scwang@ios.ac.cn>

Jabber: fungusw@jabber.org
