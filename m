From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [PATCH md 1 of 2] Fix multipath assembly bug
Date: Thu, 10 Feb 2005 13:47:04 +0300
Message-ID: <420B3BA8.2050907@tls.msk.ru>
References: <20050210091909.1612.patches@notabene> <E1Cz0ER-0000QW-TP@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <E1Cz0ER-0000QW-TP@notabene.cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
> In md, there are "level" number and "personality" numbers.
> LEVEL_MULTIPATH is the level number for multipath.
> MULTIPATH is the personality number for multipath.

BTW, why the two in the first place?  Isn't it nice to
eliminate one of them?

/mjt
