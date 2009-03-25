From: Neil Brown <neilb@suse.de>
Subject: Re: Re-size RAID-10
Date: Thu, 26 Mar 2009 09:14:22 +1100
Message-ID: <18890.44223.469.924083@notabene.brown>
References: <49CAA763.3050405@amfes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Daniel L. Miller on Wednesday March 25
Sender: linux-raid-owner@vger.kernel.org
To: "Daniel L. Miller" <dmiller@amfes.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday March 25, dmiller@amfes.com wrote:
> I think I asked this once before, if so I apologize for the redundancy - 
> but then again maybe something's changed...
> 
> I've got a RAID-10 array with four drives.  It's nearing capacity, and I 
> need to explore expansion options.  Can I simply add a pair of new 
> drives?  Or do I have to archive the information first and rebuild the 
> array from scratch?

It is not currently possible to resize a raid-10.

NeilBrown

