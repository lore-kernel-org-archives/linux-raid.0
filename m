From: Dan Noe <dpn@isomerica.net>
Subject: Moving disks
Date: Tue, 29 Apr 2003 21:17:05 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030430011705.GA32223@isomerica.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm not on the mailing list, so please send any replies to my email as well.

I have a machine which experienced a motherboard failure (leaky capacitors :<
).  In short, I need to access the data off the array with the disks in
different positions (hdc and hdd instead of the previous hde and hdg).  To
make matter worse, the person who removed the drives from the old machine
did not label them, thusly eliminating any way of knowing which disk was
number 1.

These disks have the persistant raid superblocks, and a cursory glance at
the comments in md.c seems to indicate that md will autorun the devices on
boot magically without intervention.  However, I would like to be absolutely
sure this is true.  Anything special I need to consider?

Thanks so much in advance for anyone who can help

Dan
