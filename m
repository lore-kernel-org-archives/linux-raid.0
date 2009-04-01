From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Why do I need 4 disks for a raid6?
Date: Wed, 01 Apr 2009 09:09:57 -0700
Message-ID: <49D391D5.1050509@zytor.com>
References: <87ljr4hsk9.fsf@frosties.localdomain>	<18882.54987.332211.49180@notabene.brown>	<20090323202043.GA3841@compegg.wr.niftyegg.com> <87ljquemy3.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ljquemy3.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Nifty Fedora Mitch <niftyfedora@niftyegg.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
> 
> Actually the definition I read was that raid6 is like raid5 but
> allowing for 2 or more disks to fail without loss. So a 15 disks raid
> with 10 data blocks and 5 parity blocks per stripe would also be raid6.
> 

2 or more *arbitrary* disks.  You can't, say, have two RAID-5s and call
the combination a RAID-6, because they're not all there.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

