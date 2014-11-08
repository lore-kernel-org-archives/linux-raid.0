From: Phil Turmel <philip@turmel.org>
Subject: Re: Raid5 drive fail during grow and no backup
Date: Fri, 07 Nov 2014 22:36:26 -0500
Message-ID: <545D8FBA.9090701@turmel.org>
References: <loom.20141031T141939-473@post.gmane.org> <5455A35C.2060000@turmel.org> <loom.20141103T151703-83@post.gmane.org> <5458FC2A.1050308@turmel.org> <545CEDFB.6060806@gautschi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <545CEDFB.6060806@gautschi.net>
Sender: linux-raid-owner@vger.kernel.org
To: "P. Gautschi" <linuxlist@gautschi.net>
Cc: Vince <stuff@hagenhuegel.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/07/2014 11:06 AM, P. Gautschi wrote:
>  > This is a problem you haven't solved yet, I think. The raid array
> should have fixed this bad sector for you without kicking the drive out.
> The scenario is common with "green" drives and/or consumer-grade drives
> in general.
>  > ...
>  > Then you can set up your array to properly correct bad sectors, and
> set your system to look for bad sectors on
>  > a regular basis.
>
> What is the behavior of mdadm when a disk reports a read error?
> - reconstruct the data, deliver it to the fs and otherwise ignore it?
> - set the disk to fail?
> - reconstruct the data, rewrite the failed data and continue with any
> action?
> - rewrite the failed data and reread it (bypassing the cache on the HD)?

Option 3.  Reconstruct and rewrite.

However, if the device with the bad sector is trying to recover longer 
than the linux low level driver's timeout, bad things^TM happen. 
Specifically, the driver resets the SATA (or SCSI) connection and 
attempts to reconnect.  During this brief time, it will not accept 
further I/O, so the write back of the reconstructed data fails.  Then 
the device has experienced a *write* error, so MD fails the drive.  This 
is the out-of-the-box behavior of consumer-grade drives in raid arrays.

> Do read operation always read the parity too in order to detect problems
> early
> before a sector on a other disks fails?

No.

> Can the behavior be configured in any way? I found no documentation
> regarding this.

The administrator must schedule "check" scrubs of the array to look for 
bad sectors, or wait for them to be found naturally.  Such scrubs will 
also find inconsistent parity and report it.  A "repair" scrub can then 
fix the broken parity.

I understand that some distros include a cron job for this purpose. 
I've always rolled my own.

Phil
