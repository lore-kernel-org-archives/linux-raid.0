From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: RAID backup
Date: 04 Oct 2002 13:52:23 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1033735943.31839.12.camel@irongate.swansea.linux.org.uk>
References: <Pine.LNX.3.96.1021004041421.5688A-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.3.96.1021004041421.5688A-100000@Maggie.Linux-Consulting.com>
To: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Cc: Illtud Daniel <illtud.daniel@llgc.org.uk>, Effrem Norwood <enorwood@effrem.com>, Kanoalani Withington <kanoa@cfht.hawaii.edu>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>, jbradford@dial.pipex.com, jakob@unthought.net, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2002-10-04 at 12:20, Alvin Oga wrote:
> we can build an 8-drive ( 120GB at $200ea )  or ( 160GB at $300>? each )
> 1U box...about 0.960 - 1.28 TB each backup server ( 1U ) for under $2,500 in parts
> +  cost of raid setup/testing is up to the user
> 	- am thinking the 1.6TB of storage for 10K lira(?) is too much
> 
> i prefer disks to backup data.. so that its always a semi-warm backup
> ( tapes have always been way tooo slow to find a file and to restore 

The problem with disks is you still have to archive them somewhere, and
they are bulky. I also dont know what studies are available on the
degradation of stored disk media over time. 

Capacity is not a problem, 3ware do a 12 channel sata card, with maxtor
drives that comes in at 320x12 = 3.5Tb

