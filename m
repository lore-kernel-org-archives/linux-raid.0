From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: consistency detect
Date: Tue, 12 Oct 2004 10:13:31 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16747.8619.449429.397300@cse.unsw.edu.au>
References: <1097465522.3111.24.camel@localhost.localdomain>
	<16747.5613.417433.425637@cse.unsw.edu.au>
	<1097539511.3103.78.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ming Zhang on Monday October 11
To: mingz@ele.uri.edu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday October 11, mingz@ele.uri.edu wrote:
> :) thanks a lot. so now i know what policy raid1 use. so raid1 will
> randomly choose first drive and sync among all drives. so here comes to
> another question. after a power loss and reboot, raid1 knows that there
> are something wrong and potentially out of sync between two drives. will
> it try to check and make sure two drives are in sync or it just leave
> two drives there with potential unmatched blocks.
> 
> for example, before reboot, a write to location A happen in progress.
> then after reboot. raid1 has no idea on previous write information. it
> just knows something might happened and two drives are possible to be
> out of sync. will it check whole drive to do a resync?
> 

Yes.  It copies all of these first drive onto all of the other drives.

NeilBrown
