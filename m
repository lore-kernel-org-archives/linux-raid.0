From: danci@agenda.si
Subject: SAF-TE - status lights ctrl tool?
Date: Tue, 25 May 2004 15:02:52 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0405251458170.16269@desktop.agenda.si>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The thing is I have a remote server with HotSwap SAF-TE enclosure and 
Linux SW RAID-1 (2.2 kernel).

One of the disks has gone bad and it needs to be replaced. I can get
somebody local to do that but I need to make it very clear to them which
of the disks is bad and may be pulled out.

SAF-TE enclosure has status LEDs for such purpose and HW RAID controllers
use them to mark failed drives...

Does anyone know if it is possible to activate/deactive this LEDs from 
within Linux and how?

 Thanks, D.
