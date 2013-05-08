From: Tregaron Bayly <tbayly@bluehost.com>
Subject: Specifying a data offset?
Date: Wed, 08 May 2013 14:17:54 -0600
Message-ID: <1368044274.3368.364.camel@148>
Reply-To: tbayly@bluehost.com
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

We have lots of mirrors all over our network and over time this means
arrays created by different versions of mdadm.  In turn this means that
we have all sorts of data offsets, including a 2.3.5 mdadm version that
offset the data 262,144 sectors.  I can't fathom why I need my data to
start 128M from the beginning of the disk, but whatever.

Inevitably an admin decided that doing a --create over the top of an
existing array was a good and necessary thing and when finished we
couldn't find the filesystem.  Bringing it back online was simply a case
of finding the correct offset, locating an mdadm version that would
specify it properly and doing another create.  Through the whole
exercise I found myself wondering why there isn't a command line
argument to specify the data offset if something other than the default
is desired.  I think that implementing the argument and reading the
value in init_super wouldn't be terribly difficult so I must be missing
an obvious reason.  Can someone explain to me why this feature isn't
desirable?

Thanks,

Tregaron

