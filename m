From: Sandro Dentella <sandro@e-den.it>
Subject: Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard
Date: Thu, 30 Dec 2004 18:53:19 +0100
Message-ID: <20041230175319.GA2448@bluff>
References: <m3is6k4oeu.fsf@reason.gnu-hamburg> <m38y7fn4ay.fsf@reason.gnu-hamburg> <v3rda2-hjn.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <v3rda2-hjn.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

> Yes, well, don't put the journal on the raid partition. Put it
> elsewhere (anyway, journalling and raid do not mix, as write ordering
> is not - deliberately - preserved in raid, as far as I can tell).

???, do you mean it? which filesystem would you use for a 2TB RAID5 array? I
always used reiserfs for raid1/raid5 arrays...

sandro
*:-)


-- 
Sandro Dentella  *:-)
e-mail: sandro@e-den.it 
http://www.tksql.org                    TkSQL Home page - My GPL work
