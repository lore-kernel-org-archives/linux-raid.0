From: Neil Brown <neilb@suse.de>
Subject: Re: Is my RAID broken?
Date: Mon, 6 Nov 2006 09:22:16 +1100
Message-ID: <17742.25624.469667.437194@cse.unsw.edu.au>
References: <e50d039c0611042329m29046e6fjf56a8f52a82294ad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Robert Hulme on Sunday November 5
Sender: linux-raid-owner@vger.kernel.org
To: Robert Hulme <rob@robhulme.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday November 5, rob@robhulme.com wrote:
> 
> If its resyncing that means it detected an error, right?

Not a disk error.  'resyncing' means that at startup it looked like
the array hadn't been shutdown properly so it is making sure that all
the redundancy in the array is consistent.

So it looks like you machine recently crashed (power failure?) and
it is restarting.

NeilBrown
