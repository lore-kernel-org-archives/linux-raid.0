From: Neil Brown <neilb@suse.de>
Subject: Re: Trouble increasing md component size
Date: Tue, 24 Jun 2008 08:53:18 +1000
Message-ID: <18528.10590.221031.75420@notabene.brown>
References: <18526.64462.687289.73717@notabene.brown>
	<20080623111821.GA9948@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Chris Webb on Monday June 23
Sender: linux-raid-owner@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday June 23, chris@arachsys.com wrote:
> Hi Neil. Thanks for your advice on this patch.

And thank you for fixing it up.  It looks good.
I'll try to give is a proper review and do some testing myself in a
few days. 

I'm a bit bothered about the code for leaving space for a bitmap for a
1.0 array.  I'd rather avoid too much of this sort of 'policy' in the
kernel.  We could just leave it out and expect user-space to write a
size that leaves room for a bitmap if that is needed, but maybe that
is going too far the other way.
I thought of just scaling the "space between end of data and start of
metadata" by the same amount that the device is scaled, rounding up to
the next sector.   That feels "right" if it doesn't turn out to be too
clumsy.

Also, you add 4 lines greater than 80 columns :-)  if you run
   ./scripts/checkpatch.pl  name-of-patch-file

it will tell you these things.

NeilBrown
