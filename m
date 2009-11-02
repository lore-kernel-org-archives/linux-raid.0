From: Neil Brown <neilb@suse.de>
Subject: Re: small mdadm issue under debian
Date: Mon, 2 Nov 2009 13:03:09 +1100
Message-ID: <19182.15837.879963.989788@notabene.brown>
References: <200910290124.59090.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Thomas Fjellstrom on Thursday October 29
Sender: linux-raid-owner@vger.kernel.org
To: tfjellstrom@shaw.ca
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday October 29, tfjellstrom@shaw.ca wrote:
> I've been trying to get mdadm to auto assemble my raid array for a while 
> now, and as I'm trying to test which kernels give me back some performance 
> (testing 2.6.26 right now), I find that with this kernel, its happily auto 
> assembling my 1.1 versioned metadata array. 3.6.30 does not, nor does .31 or 
> .32 for that matter. Same version of mdadm, for some reason, when the
> mdadm-raid init script is run, it fails to assemble the raid array I've 
> specified in mdadm.conf. And again, it automagically works with 2.6.26.
> 
> color me confused.

Me too.

Can you run the "mdadm" command that fails by hand and have it still
fail?
If so, can you run it with "-v" and post the result.
Or maybe edit the script to add -v and see what it says.

NeilBrown 
