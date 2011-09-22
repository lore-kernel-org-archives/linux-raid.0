From: Piotr Legiecki <piotrlg@pum.edu.pl>
Subject: Re: Changed the SATA ports of two disks in RAID10 and raid disappeared
Date: Thu, 22 Sep 2011 15:35:40 +0200
Message-ID: <4E7B39AC.3010107@pum.edu.pl>
References: <4E774458.3070107@pum.edu.pl>	<4E7AD258.2040201@pum.edu.pl> <20110922164006.763ef4c7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110922164006.763ef4c7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown pisze:

 >>> 2. How to change the ports to new ones? In a proper way.
 >> Hm, no answer here... still I don't want to repeat my errors.
 >
 > Find out why the new ports make the devices look slightly smaller and
 > un-break them.

Uh, how could I know that?
One pair (Westerndigital) is already connected to the Adaptec card, and 
the second pair (seagate) to the motherboard. So what could be done to 
make Adaptec friendly to my Seagate pair of disks connected to it?

 >>> The other thing bothers me o bit. Why there is
 >>> mdadm: metadata format 00.90 unknown, ignored. warnig? AFAIR it was
 >>> almost from the beggining of my md arrays on this computer.
 >> Solution?
 >
 > Somewhere in /etc/mdadm.conf you have "00.90" where you really want 
"0.90".
 > More recent versions of mdadm are more forgiving.

Done. Working.

Thanx


P.
