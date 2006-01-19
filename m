From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Fri, 20 Jan 2006 09:32:51 +1100
Message-ID: <17360.5011.975665.371008@cse.unsw.edu.au>
References: <26A66BC731DAB741837AF6B2E29C1017D47EA0@xmb-hkg-413.apac.cisco.com>
	<Pine.LNX.4.61.0601181427090.19392@yvahk01.tjqt.qr>
	<17358.52476.290687.858954@cse.unsw.edu.au>
	<43D00FFA.1040401@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Phillip Susi on Thursday January 19
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, "Lincoln Dale (ltd)" <ltd@cisco.com>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

On Thursday January 19, psusi@cfl.rr.com wrote:
> I'm currently of the opinion that dm needs a raid5 and raid6 module 
> added, then the user land lvm tools fixed to use them, and then you 
> could use dm instead of md.  The benefit being that dm pushes things 
> like volume autodetection and management out of the kernel to user space 
> where it belongs.  But that's just my opinion...

The in-kernel autodetection in md is purely legacy support as far as I
am concerned.  md does volume detection in user space via 'mdadm'.

What other "things like" were you thinking of.

NeilBrown
