From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: telling mdadm to use spare drive.
Date: Wed, 7 Nov 2007 18:26:02 +0100
Message-ID: <20071107182602.61162e00@absurd>
References: <20071104170502.6db7fcb1@absurd>
	<87bqa6jtxc.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87bqa6jtxc.fsf@informatik.uni-tuebingen.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Goswin von Brederlow said:     (by the date of Wed, 07 Nov 2007 10:17:51 +0100)

> Strange. That is exactly how I always do it and it always just worked.
> mdadm should start syncing on any spare as soon as a disk fails or you
> add the spare to a degraded array afaik. No special "start now"
> interaction needed.

Thanks for your confirmation. I cannot explain this behaviour - I
just started using mdadm. If anybody here wants, I can remove the
drive and add this again, to see if I can duplicate this "bug" (?).
If so - then tell me what debug information you do need and I will
give it to you.

Anyway, it seems that this command 

  mdadm --assemble --update=resync /dev/md1 /dev/hda3 /dev/sda3 /dev/hdc3

worked, becasue `mdadm -D /dev/md1` says that array is in
"State : active" (not degraded).

best regards
-- 
Janek Kozicki                                                         |
