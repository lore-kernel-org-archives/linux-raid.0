From: AndyLiebman@aol.com
Subject: Software RAID-0 striping over Hardware RAID-5
Date: Fri, 17 Sep 2004 18:03:27 EDT
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <7e.58df669c.2e7cb92f@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everyone, 

I have a Xeon machine (3.06 Ghz single processor, 2 GB RAM, SuperMicro 
motherboard) with two 3ware 9500S-8 cards. I'm getting good performance with 3ware's 
Hardware RAID-5 (I have reasons why I don't want to use Software RAID-5 on 
this machine). 

My question is, what kind of problems, if any, might I run into if I use 
Linux Software RAID to stripe the two RAID-5's together into a single RAID-0? The 
reason I'm thinking about doing this is to squeeze more performance out of the 
storage system for working with huge video files. 

(BTW, this is what Apple does with its XSeve RAID in order to work with high 
definition video. The XServe has two 7-drive RAID-5 arrays, each connected to 
a fiber channel port. The data from both arrays goes into a single dual 
channel fiber channel card on a G5 workstation, which then uses software RAID-0 to 
stripe the two RAIDS together. )

With the 2.6 kernel (versions 2.6.6 and above), should I expect any trouble 
if a drive goes down on ONE of the RAID-5s and I have to replace the disk and 
rebuild? Will the much lower performance on one of the RAID 5s during rebuild 
cause problems for the RAID-0? 

I guess it would be like making a RAID-0 with two drives of equal size, but 
very mismatched in terms of speed (i.e., a 4200 rpm drive and a 7200 rpm 
drive). 

Words of wisdom would be appreciated. 

Regards, 
Andy Liebman
