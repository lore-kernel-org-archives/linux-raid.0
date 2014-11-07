From: "P. Gautschi" <linuxlist@gautschi.net>
Subject: Re: Raid5 drive fail during grow and no backup
Date: Fri, 07 Nov 2014 17:06:19 +0100
Message-ID: <545CEDFB.6060806@gautschi.net>
References: <loom.20141031T141939-473@post.gmane.org> <5455A35C.2060000@turmel.org> <loom.20141103T151703-83@post.gmane.org> <5458FC2A.1050308@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5458FC2A.1050308@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Vince <stuff@hagenhuegel.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 > This is a problem you haven't solved yet, I think. The raid array should have fixed this bad sector for you without kicking the drive out. The scenario is common with "green" drives and/or consumer-grade drives in general.
 > ...
 > Then you can set up your array to properly correct bad sectors, and set your system to look for bad sectors on
 > a regular basis.

What is the behavior of mdadm when a disk reports a read error?
- reconstruct the data, deliver it to the fs and otherwise ignore it?
- set the disk to fail?
- reconstruct the data, rewrite the failed data and continue with any action?
- rewrite the failed data and reread it (bypassing the cache on the HD)?

Do read operation always read the parity too in order to detect problems early
before a sector on a other disks fails?

Can the behavior be configured in any way? I found no documentation regarding this.

Patrick
