From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: How SW-RAID detects new disks
Date: Mon, 20 May 2002 16:29:29 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15592.38857.541709.455531@notabene.cse.unsw.edu.au>
References: <3CE7E5CE.5070702@galileo.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Rabeeh Khoury on Sunday May 19
To: Rabeeh Khoury <rabeeh@galileo.co.il>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday May 19, rabeeh@galileo.co.il wrote:
> Hi list,
> 
> I have a question if Linux SW RAID stack can detect the presence of a 
> new disk (say new SCSI disk attached to the system in runtime) 
> automatically ?

No, it cannot.  You would need some user-space tool to detect new
disks and decide what to do with them.  Adding them to a raid might be
one option.

NeilBrown
