From: adfas asd <chimera_god@yahoo.com>
Subject: NAS Remote Side of a Mirror
Date: Mon, 5 Oct 2009 08:37:37 -0700 (PDT)
Message-ID: <905067.19304.qm@web38806.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm looking at setting up my RAID mirrored array so that one side of the mirror is in the HTPC and the other is NASsed in the garage, in case of theft or fire.

I am concerned about the boot process though, as the NASsed side will not be available until the network comes up.  Will the array be able to be patient for that and include that side once it comes up, and run not degraded?

What if I lose my local side of the mirror?  Is failover possible to the NAS side?  (Assuming a separate boot disk with everything except /home, which is on the array)

The only other technology I am aware of which can remote drives at distance is fibrechannel, and that's too expensive, so it seems I'm stuck with GB ethernet.  Are there in fact any other options?

Is it possible to bring up ethernet early in the boot process with initrd.img?

Has anyone actually done any of this?


      
