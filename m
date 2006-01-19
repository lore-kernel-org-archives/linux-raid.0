From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Thu, 19 Jan 2006 18:26:43 -0500
Message-ID: <43D02033.4070008@cfl.rr.com>
References: <26A66BC731DAB741837AF6B2E29C1017D47EA0@xmb-hkg-413.apac.cisco.com> <Pine.LNX.4.61.0601181427090.19392@yvahk01.tjqt.qr> <17358.52476.290687.858954@cse.unsw.edu.au> <43D00FFA.1040401@cfl.rr.com> <17360.5011.975665.371008@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17360.5011.975665.371008@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, "Lincoln Dale (ltd)" <ltd@cisco.com>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

Neil Brown wrote:
> 
> The in-kernel autodetection in md is purely legacy support as far as I
> am concerned.  md does volume detection in user space via 'mdadm'.
> 
> What other "things like" were you thinking of.
> 

Oh, I suppose that's true.  Well, another thing is your new mods to 
support on the fly reshaping, which dm could do from user space.  Then 
of course, there's multipath and snapshots and other lvm things which 
you need dm for, so why use both when one will do?  That's my take on it.


