From: Jordan Russell <jr-list-2010@quo.to>
Subject: Re: Data-check brings system to a standstill
Date: Mon, 21 Jun 2010 23:06:35 -0500
Message-ID: <4C2036CB.7090505@quo.to>
References: <4C0FCFCD.4070201@quo.to> <4C19015B.3020807@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C19015B.3020807@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/16/2010 11:52 AM, Bill Davidsen wrote:
> Alternatively, you can try setting your io scheduler to 
> deadline,

Wow - huge difference! No "hung task" warnings, no processes stuck in
"D" state; the system remains completely responsive throughout the
entire check.

I don't see why, though, processes are blocking for 2+ minutes on the
simplest of I/O operations when the default CFQ scheduler is used. Isn't
CFQ supposed to distribute I/O bandwidth in a "completely fair" manner?
Do md checks bypass the fairness algorithm?

-- 
Jordan Russell
