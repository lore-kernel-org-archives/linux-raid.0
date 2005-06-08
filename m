From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: active/active vs active/passive?
Date: Tue, 07 Jun 2005 17:09:56 -0700
Message-ID: <1118189397.15459.108.camel@seki.nac.uci.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: strombrg@dcs.nac.uci.edu
List-Id: linux-raid.ids


The lecturer at the recent NG storage talk at Usenix in Anaheim,
indicated that it was best to avoid "active/active" and get
"active/passive" instead.

Does anyone:

1) Know what these things mean?

2) Know why active/passive might be preferred over active/active?

If I had to guess, I'd say that active/active means that n servers are
all watching n-1 others to decide when they should jump to life, while
in active/passive perhaps 1 server is primary, and the passive nodes
only monitor that 1 server.  Maybe?  Just a totally wild guess based on
next to nothing.  :)

Thanks!


