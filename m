From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Scsi adapters and software raid...
Date: Thu, 19 Feb 2004 23:27:57 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40358CCD.2020702@pobox.com>
References: <Pine.GSO.4.33.0402191508420.28488-100000@sweetums.bluetronic.net> <1077228261.30431.5.camel@south.rosestar.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1077228261.30431.5.camel@south.rosestar.lan>
To: Bob Hillegas <bobhillegas@houston.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bob Hillegas wrote:
> It's been interesting reading these comments about adapters to avoid. 
> 
> My question is... what SCSI adapter works WELL with software raid
> (mdadm) and doesn't get in the way?


For parallel SCSI?

IMO Adaptec is really the only big vendor in the game anymore.  I think 
QLogic dumped their parallel SCSI hardware (correct me if I'm wrong), 
even though they still support their parallel SCSI driver.

Personally, though, I would skip SCSI and go straight to Serial ATA :)

	Jeff



