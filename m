From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: suns raid-z / zfs
Date: Sun, 17 Feb 2008 17:04:03 +0100
Message-ID: <20080217160403.GA15710@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

any opinions on suns zfs/raid-z?
It seems like a good way to avoid the performance problems of raid-5
/raid-6

But does it stripe? One could think that rewriting stripes
other places would damage the striping effects.

Or is the performance only meant to be good for random read/write?

Can the code be lifted to Linux? I understand that it is already in
freebsd. Does Suns licence prevent this?

And could something like this be built into existing file systems like
ext3 and xfs? They could have a multipartition layer in their code, and
then the heuristics to optimize block access could also apply to stripe
access.

best regards
keld
