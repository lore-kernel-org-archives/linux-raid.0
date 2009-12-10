From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm creating raid5 with all spare disks
Date: Fri, 11 Dec 2009 07:10:06 +1100
Message-ID: <20091211071006.56270ebf@notabene.brown>
References: <1D0665FE-138F-480F-9872-48C94CEBC5C2@mac.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1D0665FE-138F-480F-9872-48C94CEBC5C2@mac.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Tehonica <matt.tehonica@mac.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 10 Dec 2009 12:15:09 -0500
Matt Tehonica <matt.tehonica@mac.com> wrote:

> Hi all,
> 
> I was just wondering if anyone else has seen a problem when creating a  
> RAID5 where mdadm will create it and it shows all disks as spares and  
> above it shows all drives as removed. I can't seem to figure this. Any  
> sugestions would be great.

Maybe the raid456 modules isn't getting loaded?

If you show us the exact command, the exact contents of /proc/mdstat,
and any kernel log messages generated at the time it will be a lot easier
to explain what is happening.

NeilBrown
