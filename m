From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Extendable raid - with soft-raid 5 and new mdadm?
Date: Mon, 1 Nov 2004 12:11:54 +1100
Message-ID: <16773.36186.937623.21914@cse.unsw.edu.au>
References: <41852F32.3000405@stefan-neufeind.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stefan Neufeind on Sunday October 31
Sender: linux-raid-owner@vger.kernel.org
To: Stefan Neufeind <linux-raid@stefan-neufeind.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday October 31, linux-raid@stefan-neufeind.de wrote:
> Hi,
> 
> I was wondering how to set up an extendable raid, just for backup/data 
> storage. It doesn't need to be high-performant - so imho I don't need a 
> hardware-raid.
> 
> To provide a minimum of security I was wondering about using a soft-raid 
> 5 under Linux. However, I need to be able to extend the raid, if backup 
> demand rises. Therefor I plan to use a raid 5 with three or four devices 
> at the moment and need to be able to add more as the requirements grow.
> 
> I saw that in mdadm, version 1.7.0, there was a "grow"-feature 
> introduced. However, at present it just works fine for raid 1 as far as 
> I know. Can somebody tell me, if it will shortly (in the next few month) 
> be possible to extend a soft-raid 5 with mdadm as well? What do you 
> think about data-security? And do I need a plain raid 5 with ext3 on it 
> or should I maybe put an LVM on top of raid 5 to be flexible?
> 

mdadm --grow
is unlikely the be able to add devices to a raid5 array in the near
future. 
There is a program called "raidreconfig" (I think) which can do this
off-line.   This is information only, not a recommendation as I have
never used it or looked at it.

NeilBrown
