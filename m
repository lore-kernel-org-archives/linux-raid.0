From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: Re: Which raid card to buy for SargeD
Date: Fri, 9 Apr 2004 23:52:39 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040409215239.GJ3257@chihiro.cern.ch>
References: <Pine.LNX.4.44.0403311442520.31572-100000@coffee.psychology.mcmaster.ca> <406B27E4.1000106@sauce.co.nz> <20040401090731.GI6923@chihiro.cern.ch> <406F936C.2090605@sauce.co.nz> <20040409111626.GC3257@chihiro.cern.ch> <Pine.LNX.4.58.0404090905540.21639@treant.hhmi.umbc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0404090905540.21639@treant.hhmi.umbc.edu>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

* Yu Chen (chen@hhmi.umbc.edu) [20040409 09:07]:

> Sorry, this might be a silly question, since I am new to RAID,
> how do I do those tests, I would like to check out our RAID.

Grab iozone=B9 and run a throughput test:
iozone -Mce -t1 -i0 -i1 -s128g -r256k -f /path/to/raid/IOZONE

Peter

=B9 http://www.iozone.org/

--=20
    .+'''+.         .+'''+.         .+'''+.         .+'''+.         .+'=
'
 Kelemen P=E9ter     /       \       /       \     Peter.Kelemen@cern.c=
h
=2E+'         `+...+'         `+...+'         `+...+'         `+...+'
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
