From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Sat, 31 Jul 2004 09:11:46 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0407310908360.12414@chaos.egr.duke.edu>
References: <b476569a04072920533b757574@mail.gmail.com>
 <200407300815.18296.mrwatts@fast24.co.uk> <cedoda$qn4$1@sea.gmane.org>
 <200407301717.36583.mrwatts@fast24.co.uk> <20040730234706.M12321@contactbda.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040730234706.M12321@contactbda.com>
To: Jim Buttafuoco <jim@contactbda.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 30 Jul 2004 at 7:53pm, Jim Buttafuoco wrote

> I second Marks comment on NOT recommending the 3ware cards to anyone.  
> 
> I have a dual XEON 3.2 Ghz system 12 G of ram with a 3ware 8506-8 in it (8 250 G drives).  The hard raid performance 
> was very bad.  with the load avg going over 40.  I then switched over to JBOD and software raid.  The IO wait times 
> are really high and the performance sucks.  Very hard to explain to my boss where the $20k went. The system is a 
> database server (postgres).  I tried both kernel 2.4 and 2.6 with the same problem.  I am now in the process of 
> testing the adaptec raid controller.  

3wares *can* work, and work well.  I've got two 7500-8s on a dual Xeon 
board (Supermicro), each with 8 180GB WD drives (7200 RPM) and running 
hardware RAID5.  Then I do a software RAID0 strips across the two arrays.  
Performance is quite good:

[jlb@buckbeak jlb]$ bonnie++ -s 8192
Version 1.02c       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
buckbeak         8G 25283  96 131142  39 83869  32 28038  99 342849  68 444.1   1
                    ------Sequential Create------ --------Random Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read--- -Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP
                 16  2644  21 +++++ +++  2227  17  2548  20 +++++ +++  2118  21
buckbeak,8G,25283,96,131142,39,83869,32,28038,99,342849,68,444.1,1,16,2644,21,+++++,+++,2227,17,2548,20,+++++,+++,2118,21

That's with a 2.4 kernel and XFS.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
