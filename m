From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Q: How does raid1 sync if superblocks are dirty?
Date: Tue, 17 Sep 2002 09:35:35 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15750.27335.284105.794045@notabene.cse.unsw.edu.au>
References: <9CFB9DA5261CD611A29B00508B7890486543B8@ex-deu-munich02.force.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Potthoff, Kay on Monday September 16
To: "Potthoff, Kay" <Kay.Potthoff@fci.com>
Cc: "Linux RAID Mailing List (E-mail)" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday September 16, Kay.Potthoff@fci.com wrote:
> Hi,
> 
> I have oberserved a little bit obscure behavior of my RAID setup if my
> system 
> comes up after a reset. I have setup a mirror and if I start the RAID after
> a 
> reset MD detects that the superblocks on the disks are not clean and starts
> a 
> resync.
> 
> If I check the output MD tells me that both disks of the mirror are
> operational;
> the same if I look at the output of /proc/mdstat: both disks are operational
> 
> "... [2/2] [UU] ...". But a resync is still in progress.
> 
> My question is: In which direction the resync is done; resp. what is the
> sync algorithm in that case?

The raid1 driver arbitrarily chooses one drive and copies all data
from it onto all other drives (normally there is only one other).
While this is happening, all read requests are served off the chosen
drive.

The driver currently chooses the first drive as it's arbitrary choice,
and this is not likely to change.

NeilBrown
