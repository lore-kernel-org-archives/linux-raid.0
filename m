From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-6
Date: 12 Nov 2002 11:01:59 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <aqrj77$ttc$1@cesium.transmeta.com>
References: <aqou9k$ou5$1@cesium.transmeta.com> <20021112162205.GB22407@unthought.net> <3DD12CA3.5090105@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <3DD12CA3.5090105@zytor.com>
By author:    "H. Peter Anvin" <hpa@zytor.com>
In newsgroup: linux.dev.raid
> 
> I've tried to figure out how to generalize to using regular 32-bit
> or 64-bit integer registers, but it doesn't seem to work there.
> 

Of course, once I had said that I just had to go and figure it out :)
This is good, because it's inherently the highest performance we can
get out of portable code.

	-hpa

-- 
<hpa@transmeta.com> at work, <hpa@zytor.com> in private!
"Unix gives you enough rope to shoot yourself in the foot."
http://www.zytor.com/~hpa/puzzle.txt	<amsp@zytor.com>
