From: christophe.varoqui@free.fr
Subject: Re: [dm-devel] [ANNOUNCE] multipath-tools-0.1.6
Date: Tue, 27 Apr 2004 14:37:10 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1083069430.408e53f639536@imp4-q.free.fr>
References: <1082930099.3158.13.camel@zezette> <20040426081842.GN8379@nimzo> <1083059878.408e2ea6eab69@imp1-q.free.fr> <20040427100930.GA24944@nimzo>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040427100930.GA24944@nimzo>
To: thornber@redhat.com
Cc: linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, linux-hotplug-devel@lists.sourceforge.net
List-Id: linux-raid.ids

Selon thornber@redhat.com:

> > Any insight on where to put the log of the mirror target when mapping over
> a
> > MD-created raid1 ?
> 
> MD effectively uses a log with a single region in it.  So we only need
> 3 sectors (2 for the header 1 for the bitset) for the log, is there
> any space in the MD metadata where this could be placed ?
> 
Nope : the sb is 4096 bytes long, and is full of holes. The biggest one is 128
bytes long, at the tail. We could lower the maximum number of device in a raid
from 27 to 21 to free 3 sectors, but it won't be appreciated and would leave us
with the most fundamental problem : logging in the MD superblock would corrupt
the checksum ... :(
