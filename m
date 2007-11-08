From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: telling mdadm to use spare drive.
Date: Thu, 8 Nov 2007 21:28:04 +0100
Message-ID: <20071108212804.771c39ac@absurd>
References: <20071104170502.6db7fcb1@absurd>
	<87bqa6jtxc.fsf@informatik.uni-tuebingen.de>
	<20071107182602.61162e00@absurd>
	<47320E4F.3070308@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47320E4F.3070308@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Richard Scobie said:     (by the date of Thu, 08 Nov 2007 08:13:19 +1300)

> What kernel and RAID level is this?
> 
> If it's RAID 1, I seem to recall there was a relatively recently fixed 
> bug for this.

debian etch, stock install
Linux 2.6.18-5-k7 #1 SMP i686 GNU/Linux

The problem was with was RAID 5.

But also I have RAID 1 there, and after --add the drives
automatically resynced.

-- 
Janek Kozicki                                                         |
