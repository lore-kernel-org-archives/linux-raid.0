From: Jon Lewis <jlewis@lewis.org>
Subject: Re: what is the best multi-SATA-controller-on-a-single-board out
 there?
Date: Tue, 3 Aug 2004 13:45:46 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0408031341170.7852@web1.mmaero.com>
References: <20040730234706.M12321@contactbda.com>
 <Pine.LNX.4.44.0407311045460.4528-100000@uplift.swm.pp.se>
 <20040801150258.M30882@contactbda.com> <1091382829.11770.14.camel@tinny.home.foo>
 <410E15EB.7030407@buttersideup.com> <Pine.LNX.4.58.0408021700230.7852@web1.mmaero.com>
 <410F52ED.9070403@buttersideup.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <410F52ED.9070403@buttersideup.com>
To: Tim Small <tim@buttersideup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 3 Aug 2004, Tim Small wrote:

> I'm using kernel.org 2.6.8rc2 (also used 2.6.5rc3), with libata on
> Debian/Sarge (not that the distribution should matter, this is all
> kernel side stuff) - both on Xeons, and Opterons, all filesystems are

It matters to the extent that some of the distros like to use heavily
patched kernels...so one distro's 2.4.x kernel may be quite different from
another's.  So unless you build custom kernels from the kernel.org
sources, kernel verion _and_ distro is more meaningful.

It seems (from Maxtor's powermax util) that I do have at least one
defective drive...so hopefully that's all the problem was.  I'm building
an array now with the remaining 5 drives that passed the powermax tests.

----------------------------------------------------------------------
 Jon Lewis                   |  I route
 Senior Network Engineer     |  therefore you are
 Atlantic Net                |
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
