From: <me@heyjay.com>
Subject: Re: Deleting an raid device
Date: Tue, 25 May 2004 20:21:40 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <009201c442c0$df19caa0$6705a8c0@a30>
References: <002501c44257$7135dd80$6705a8c0@a30> <Pine.LNX.4.58.0405252115280.6990@praktifix.dwd.de>
Reply-To: <me@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yes they are

Jay
----- Original Message ----- 
From: "Holger Kiehl" <Holger.Kiehl@dwd.de>
To: <me@heyjay.com>
Cc: <linux-raid@vger.kernel.org>
Sent: Tuesday, May 25, 2004 4:17 PM
Subject: Re: Deleting an raid device


> On Tue, 25 May 2004 me@heyjay.com wrote:
> 
> > Hi,
> > 
> > What are the proper steps for deleting all remnants of a previous raid
> > install?
> > 
> > I've done:
> > mdadm --stop /dev/md0
> > mdadm --zero-superblock /dev/md0
> > 
> > But I still see it getting stopped on shutdown.
> > 
> Are the partitions system id still fd (raid autodetect)?
> 
> Holger
> 
> 
