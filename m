From: Joe Pruett <joey@q7.com>
Subject: large await discrepancies
Date: Mon, 9 Dec 2002 15:50:56 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0212091539330.1479-100000@q7.q7.com>
References: <15860.4971.982540.695313@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15860.4971.982540.695313@notabene.cse.unsw.edu.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i have a system with two identical drives (WDC WD800BB-00CAA0) hooked to
two identical controllers (CMD649 based) in a simple mirror.  randomly,
the system will exhibit very high load averages, almost exclusively from
blocked processes.  running iostat -x at that time will show that the hde
drive will have much large await and svctime values that hda.  i had a
different set of controllers (PDC based) in there before and saw similar 
problems.  i used to be running ext3 on the filesystems, but have dropped 
back to ext2 because of theories of the journal causing periodic 
slowdowns.  i have also tweaked bdflush via:
vm.bdflush = 20 2000 128 0 60 512 60 0 0
based on some info on the web.  each change i make seemed to help, but 
then eventually the problem comes back.

so i have another theory:  should i use dissimilar controllers so that the
device driver code isn't being shared?  i'm just wondering if the 
underlying code could somehow be starving the second disk while servicing 
the first?  or am i maybe just running into plain old bandwidth issues 
(pci or ide)?

the system is just a general isp 'everything' box.  email, web, radius, 
mysql, etc.  it is a dual 1ghz p3 with 1g of ram on some intel server 
board.

any other great ideas?

