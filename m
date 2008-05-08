From: Neil Brown <neilb@suse.de>
Subject: Re: Autostarting arrays with V1 metadata
Date: Thu, 8 May 2008 13:05:44 +1000
Message-ID: <18466.28168.343215.443749@notabene.brown>
References: <4821EEFB.1040501@bluecherry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ben Winslow on Wednesday May 7
Sender: linux-raid-owner@vger.kernel.org
To: Ben Winslow <rain@bluecherry.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday May 7, rain@bluecherry.net wrote:
> I've noticed that (as of 2.6.25, at least) the kernel doesn't autostart 
> arrays with V1 metadata.  In autostart_arrays(), md_import_device() is 
> called for 0.90 arrays only, and there's currently no sort of 
> autodetection of the superblock position for V1 metadata.
> 
> Is this simply a matter of the code being unwritten, or are there other 
> reasons that V1 arrays aren't autostarted (such as the SB format being 
> unfinished)?  My only real motivation to use V1 metadata is the unhashed 
> homehost field, which I'll give up if the SB format hasn't stabilized yet.

V1.x metadata (deliberately) doesn't contain sufficient information to
allow in-kernel autodetect.  In particular it doesn't store the 'minor
number' information so the kernel wouldn't know which md device to
use.

However it is quite possible to assemble V1.x arrays using mdadm in an
initrd.  This is the preferred method.

Ofcourse, if the array doesn't hold the root filesystem, you can just
assemble it as part of the regular boot scripts.

NeilBrown
