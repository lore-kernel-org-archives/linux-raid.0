From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Safest way to renumber RAID-5 devices
Date: Sat, 28 Jun 2003 18:27:06 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16125.20826.76778.935888@gargle.gargle.HOWL>
References: <3EFD4BBF.1020405@attbi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ian Pilcher on Saturday June 28
To: Ian Pilcher <pilchman@attbi.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday June 28, pilchman@attbi.com wrote:
> Hi all!
> 
> I have several RAID-5 devices that I would like to renumber
> (incrementing each minor number by 1).
> 
> Is it possible to do this without re-creating them?  I'd like to avoid
> unnecessary re-syncs as well as the possibility of screwing up.
> 

mdadm -A --update=superminor /dev/mdNEWNUMBER  /dev/sd...

should work with mdadm 1.2.0.

Obviously you have to stop the array first as "mdadm -A" starts a
stopped array.

Check the manpage to make sure I haven't mispelled somthing.

NeilBrown
