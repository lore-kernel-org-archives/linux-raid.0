From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: software for making initrd's with raid support
Date: Thu, 13 Mar 2008 00:56:41 +0100
Message-ID: <20080312235641.GA7109@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

I have been looking at making my system working with raid, and booting
from raid. I succeded, but I had to hack a number of things, including
making a new initrd by hand.

I used mkinitrd, but it did not treat sw raid, only in the md sense.
this is a redhat/mandriva/pclinuxos(keldix thing, I wonder if it also
used in the dbian/ubuntu world.

So what do you use for generating initrd? And does it work out of the
box?

Are there any installers that have support for raid1/raid10?

BTW, I updated the howto on preventing against failure caused
by a single bad disk, and I think it now kind of reflects
something that works.

best regards
Keld
