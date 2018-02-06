From: Marc MERLIN <marc@merlins.org>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Tue, 6 Feb 2018 11:36:25 -0800
Message-ID: <20180206193625.GD9565@merlins.org>
References: <20180206181416.amo6geclrvc6ylrf@merlins.org> <c8be73cb-7dce-0b37-c498-19bf350a6c91@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c8be73cb-7dce-0b37-c498-19bf350a6c91@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 06, 2018 at 07:59:32PM +0100, Reindl Harald wrote:
> but 18125K/sec is a joke given that you should run a scrub every week
 
I know it's bad. Right now it's a bit slower than normal because I'm also
copying data to the drives.

> did you try to play around with sysctl.conf?

Yes, I set it to 300,000, but obviously it won't make the hardware go faster
than it can.

I totally understand the performance is crap, but it's a backup array that I
only bring up and power on once a week and scrub once a month, so it's ok
enough for the use in question.

For now, it's more about me learning how to manually force a block remap,
not because I absolutely have to, but because it's always good to know and
learn low level tools and how things work.

I have used hdrecover in the past which reads all the blocks low level and
re-reads a bad block many times to force a successful read and auto remap,
but sadly it doesn't take a block offset, so it would only work if I let it
run on the whole drive, which would be slow.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
