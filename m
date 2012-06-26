From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Stacked array data recovery
Date: Tue, 26 Jun 2012 15:23:43 -0500
Message-ID: <4FEA1A4F.9090605@hardwarefreak.com>
References: <js083q$kdu$1@dough.gmane.org> <js1vuk$9k8$2@dough.gmane.org>  <4FE5B213.5010503@hardwarefreak.com> <js70ce$fgv$1@dough.gmane.org>  <4FE72053.4040101@hardwarefreak.com> <4FE7E044.6040506@hardwarefreak.com>  <js9emr$761$1@dough.gmane.org> <4FE91619.4020709@hardwarefreak.com> <1340699839.3241.29.camel@hoferr-desktop.hofer.rummelring>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1340699839.3241.29.camel@hoferr-desktop.hofer.rummelring>
Sender: linux-raid-owner@vger.kernel.org
To: Ramon Hofer <ramonhofer@bluewin.ch>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/26/2012 3:37 AM, Ramon Hofer wrote:

> Btw I ran the four dd commands within a screen session if this is of any
> importance?

Can you get to that screen session?  Recall I showed you the output you
should have seen when each dd command completed?  Did you see four such
sets of output in the screen session?

Regardless, unless the dd commands hung in some way, they should not
show up in top right now.  So it's probably safe to assume they completed.

So at this point you can try creating the RAID5 array again.  If the dd
command did what we wanted, /dev/sdk should have remapped the bad
sector, and you shouldn't get the error kicking that drive.  If you
still do, you may need to replace the drive.

-- 
Stan
