From: Gordon Henderson <gordon@drogon.net>
Subject: /proc/partitions
Date: Mon, 20 Dec 2004 10:50:01 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0412201046050.4389@lion.drogon.net>
References: <200411210433.iAL4XIN19967@www.watkins-home.com>
 <Pine.LNX.4.61.0411220909180.5652@treant.hhmi.umbc.edu>  <41A281AD.8050404@verizon.net>
  <41A301DA.4010303@robinbowes.com> <1101213077.2244.6.camel@south.rosestar.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1101213077.2244.6.camel@south.rosestar.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Is there any plans to make the entries in /proc/partitions return anything
sensible for the md devices?

(Or is it just something that intrinsically hard to do in the drivers?)

If not, is there any other way to get some stats on reading & writing each
md device?

I'm intersted in graphing (mrtg) disk reads & writes per second for some
file & web servers I'm running.

Cheers,

Gordon

Ps. I'm still in the dark days of 2.4.27 if this now works in 2.6.x it
might be the push required to make me switch...
