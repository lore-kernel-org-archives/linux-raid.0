From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: SCSI or Ultra-ATA/133
Date: Mon, 9 Jun 2003 10:33:21 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0306091026121.12147-100000@chaos.egr.duke.edu>
References: <Pine.SGI.4.44.0306090850090.1754-100000@cobalt.hhmi.umbc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.SGI.4.44.0306090850090.1754-100000@cobalt.hhmi.umbc.edu>
To: Yu Chen <chen@hhmi.umbc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 9 Jun 2003 at 9:41am, Yu Chen wrote

> We are using hardware RAID, and considering expanding. I am wondering
> if someone could give me some advices on SCSI-SCSI RAID and SCSI-IDE RAID
> (like nexsan's ATA-boy2, configured with ultra-ATA/133 diskes). It seems
> the ultra-ATA raid is very impressive, but I don't know if we will notice
> the slowness of the ATA diskes.
> 
> Thanks in advance for any advices!

I have both an external IDE-SCSI RAID (the previous generation of 
<http://www.synetic.net/Synetic-Products/SyneRAID-Units/SyneRAID-800S.htm>) 
and 2 (soon to be 3) boxes using 3ware RAID cards and internal IDE drives.  
Both have worked well, including surviving drive failures with no 
subsequent downtime.  Between the 2, the 3ware's win hands down when it 
comes to speed.  These are bonnie++ numbers from my 2TB server with 2 
3ware 7500-8 cards in hardware RAID5 mode combined in a software RAID0 
stripe:

Version 1.02c       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
fluffy          16G 24041  99 125828  41 77667  37 25443  99 350311  90 244.3  4
                    ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16  2145  23 +++++ +++  1947  21  1580  18 +++++ +++  1384  16
fluffy,16G,24041,99,125828,41,77667,37,25443,99,350311,90,244.3,4,16,2145,23,+++++,+++,1947,21,1580,18,+++++,+++,1384,16

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University


