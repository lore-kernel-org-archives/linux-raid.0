From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: Software Raid 1 data corruptions..
Date: Mon, 17 Nov 2003 14:19:13 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16312.15921.440148.830272@notabene.cse.unsw.edu.au>
References: <3FB65EA6.4080905@calixo.net>
	<PPEOJEIEFLAONFNHJPOOGEEGGOAA.jim@jimtreats.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from James R Bamford on Saturday November 15
To: James R Bamford <jim@jimtreats.com>
Cc: david.anderson@calixo.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday November 15, jim@jimtreats.com wrote:

> raiddev /dev/md0
>         raid-level      1
>         nr-raid-disks   2
>         nr-spare-disks  0
>         chunk-size      4
>         persistent-superblock   1
>         device          /dev/hde1
>         raid-disk       0
>         device          /dev/hdh1
>         raid-disk       1

Would I be right in guessing that hde1 is a master, but hdh1 is a
slave (though on different busses)?  That's kind of an odd
configuration. 

You could try turning of DMA on the drives (hdparm ...) and see if you
still get corruption.  If you don't, the finger point very much at the
IDE controller...

NeilBrown
