From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: Re: Stacked array data recovery
Date: Mon, 02 Jul 2012 12:12:35 +0200
Message-ID: <1341223955.3407.6.camel@hoferr-desktop.hofer.rummelring>
References: <js083q$kdu$1@dough.gmane.org> <js1vuk$9k8$2@dough.gmane.org>
	  <4FE5B213.5010503@hardwarefreak.com> <js70ce$fgv$1@dough.gmane.org>
	  <4FE72053.4040101@hardwarefreak.com> <4FE7E044.6040506@hardwarefreak.com>
	  <js9emr$761$1@dough.gmane.org> <4FE91619.4020709@hardwarefreak.com>
	 <1340699839.3241.29.camel@hoferr-desktop.hofer.rummelring>
	 <4FEA1A4F.9090605@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FEA1A4F.9090605@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Die, 2012-06-26 at 15:23 -0500, Stan Hoeppner wrote:

> Regardless, unless the dd commands hung in some way, they should not
> show up in top right now.  So it's probably safe to assume they completed.
> 
> So at this point you can try creating the RAID5 array again.  If the dd
> command did what we wanted, /dev/sdk should have remapped the bad
> sector, and you shouldn't get the error kicking that drive.  If you
> still do, you may need to replace the drive.

I have successfully run dd for all the four drives.

But because I couldn't create the raid I ran smartctl again for all of
them. It seems that sdk has to be replaced. Here are the outputs:

sdj:
http://pastebin.com/raw.php?i=V60FJ4wC

sdk:
http://pastebin.com/raw.php?i=cgfq3202
There are some pre-fail and one FAILING_NOW messages.

sdl:
http://pastebin.com/raw.php?i=tipjbpxu

sdm:
http://pastebin.com/raw.php?i=sZnrCJ5Q

Is this the right moment to bring sdk back to my dealer?


Best regards
Ramon

