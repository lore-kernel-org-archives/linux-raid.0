From: Marc MERLIN <marc@merlins.org>
Subject: Re: mismatch sector in range, kernel 4.13
Date: Sat, 9 Sep 2017 11:37:01 -0700
Message-ID: <20170909183701.75e7f6a36gac3rsc@merlins.org>
References: <20170909174230.fs5a5yhf66mucnlq@merlins.org>
 <e48c2cae-dd3a-f854-0030-8e2892fa183d@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e48c2cae-dd3a-f854-0030-8e2892fa183d@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Sep 09, 2017 at 07:26:51PM +0100, Anthony Youngman wrote:
> But with raid 5 you can only solve for a missing/corrupt block IF you can
> tell the system which one is messed up. Btrfs is telling you that the data
> is fine, so you know it's the parity, and raid 5 can fix that for you.

Thanks for confirming my understanding. I just wasn't 100% sure if md
now had extra checksums that would not allow you to reconstruct corrupt
data but would tell you which block was corrupted (i.e. not like parity
where you can actually rebuild, but enough to say "yes, this one doesn't
add up").

Anyway, I'm going to start a repair, thanks.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
