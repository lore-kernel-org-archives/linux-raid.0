From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Fri, 20 Jan 2006 13:06:28 +0100
Message-ID: <20060120120627.GF13429@suse.de>
References: <26A66BC731DAB741837AF6B2E29C1017D47EA0@xmb-hkg-413.apac.cisco.com> <Pine.LNX.4.61.0601181427090.19392@yvahk01.tjqt.qr> <17358.52476.290687.858954@cse.unsw.edu.au> <43D00FFA.1040401@cfl.rr.com> <17360.5011.975665.371008@cse.unsw.edu.au> <43D02033.4070008@cfl.rr.com> <17360.9233.215291.380922@cse.unsw.edu.au> <43D04828.8010107@cfl.rr.com> <20060120105306.GY22163@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060120105306.GY22163@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: Phillip Susi <psusi@cfl.rr.com>, Neil Brown <neilb@suse.de>, Jan Engelhardt <jengelh@linux01.gwdg.de>, "Lincoln Dale (ltd)" <ltd@cisco.com>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

On Fri, Jan 20 2006, Lars Marowsky-Bree wrote:
> Oversimplifying to "dm is better than md" is just stupid.

Indeed. But "generally" md is faster and more efficient in the way it
handles ios, it doesn't do any splitting unless it has to.

-- 
Jens Axboe

