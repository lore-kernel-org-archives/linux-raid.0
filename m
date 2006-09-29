From: Oliver Paulus <oliver@code-project.org>
Subject: Re: raid superblock checksum problem
Date: Fri, 29 Sep 2006 14:52:07 +0200
Message-ID: <20060929145207.l5nck3b0c144sg4k@raudies.homeip.net>
References: <20060927082251.z2se9ux33pc0o40k@raudies.homeip.net>
	<CD68F2EC-E92B-4731-9695-A19C5E165A44@develooper.com>
	<20060927083720.2hgoo44bnwtss4g4@raudies.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060927083720.2hgoo44bnwtss4g4@raudies.homeip.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have found this mailing list entry with the same problem I currently have:
http://www.mail-archive.com/linux-raid@vger.kernel.org/msg05835.html

I have made some tests on 4 different mainboards and 2 different SIL 
3512 cards:

3 mainboards have the VIA KT133 chipset. On each of these mainboards I get the
checksum problem with both cards if I want to use a softraid.

1 mainboard with a SIS chipset works fine with both cards.

It seems that the combination VIA mainboard chipset (KT 133) + SIL 3512 
+ Linux
softraid does not work.

Regards
Oliver Paulus

