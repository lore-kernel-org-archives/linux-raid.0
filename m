From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: AW: recover short-time-power-failure of raid 5?
Date: Mon, 25 Nov 2002 21:15:44 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15841.63568.187721.514489@notabene.cse.unsw.edu.au>
References: <4D618F6493CE064A844A5D496733D6670314F3@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Martin Bene on Monday November 25
To: Martin Bene <martin.bene@icomedias.com>
Cc: krause@mogli-soft.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday November 25, martin.bene@icomedias.com wrote:
> PS: not sure what happens if you're using a journaling fs on the raid - I
> think fsck replays the journal before checking, so trying out different
> combinations of disk doesn't look like a viable option in that case?

With ext3, "fsck -n" doesn't replay the journal, but will report
errors that would be fixed by replaying the journal.  You would have
to ask yourself 'do these look like major errors, or just minor things
that the journal replay would fix'.

NeilBrown
