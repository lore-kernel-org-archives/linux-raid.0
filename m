From: Nagilum <nagilum@nagilum.org>
Subject: Re: Any hope for a 27 disk RAID6+1HS array with four disks
 reporting "No md superblock detected"?
Date: Tue, 10 Feb 2009 17:58:33 +0100
Message-ID: <20090210175833.15261jw8a7awdu80@cakebox.home>
References: <1233775657.10151.5.camel@localhost.localdomain>
 <18827.51024.270348.20624@notabene.brown>
 <1233952325.9786.20.camel@localhost.localdomain>
 <5b35884ec706518d378265e6b95ace53.squirrel@neil.brown.name>
 <1233956838.9786.37.camel@localhost.localdomain>
 <a12770d97b01cc418aaff84bdd9e9349.squirrel@neil.brown.name>
 <1234190898.10428.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-2;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1234190898.10428.7.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: tjb@unh.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Message from tjb@unh.edu ---------
     Date: Mon, 09 Feb 2009 09:48:18 -0500
     From: "Thomas J. Baker" <tjb@unh.edu>
Reply-To: tjb@unh.edu
  Subject: Re: Any hope for a 27 disk RAID6+1HS array with four disks  
reporting "No md superblock detected"?
       To: NeilBrown <neilb@suse.de>
       Cc: linux-raid@vger.kernel.org

> OK, specifying 27 devices worked and I successfully mounted the RAID and
> looked around. Thanks again for the guidance! I guess things look OK
> (there are directories and files!)
>
> I was wondering if I should fsck it before adding the other two disks
> back in or after? Any other words of experience?
----- End message from tjb@unh.edu -----

All fsck commands should have a 'dry-run' or 'no-modify' mode in which  
they just check without attempting to change anything. This should be  
your first mode of operation.
If everything checks out you can add your spares and regain your redundancy.
Kind regards,
Alex.


========================================================================
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
========================================================================


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..
