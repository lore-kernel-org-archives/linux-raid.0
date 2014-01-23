From: Ian Kumlien <ian.kumlien@gmail.com>
Subject: Re: [BUG] at drivers/md/raid5.c:291! kernel 3.13-rc8
Date: Thu, 23 Jan 2014 01:00:46 +0100
Message-ID: <1390435246.587.18.camel@localhost>
References: <1390168823.587.1.camel@localhost>
	 <20140120113851.3b476ed8@notabene.brown> <1390178957.587.9.camel@localhost>
	 <20140120143748.33bb52d2@notabene.brown>
	 <1390242438.587.16.camel@localhost>
	 <20140122115208.6a2b3909@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140122115208.6a2b3909@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On ons, 2014-01-22 at 11:52 +1100, NeilBrown wrote:
> On Mon, 20 Jan 2014 19:27:18 +0100 Ian Kumlien <ian.kumlien@gmail.com> wrote:
> > I have been unable to trip this up, so this was it!
> > 
> > Tested-by: Ian Kumlien <ian.kumlien@gmail.com>
> > 
> > I hope this hits stable ASAP ;)
> 
> I've push it out into my for-next branch.
> I'll probably send a pull request to Linus tomorrow.
> It has some chance of getting into a -stable branch next week (though I'm not
> really sure of the schedule).

Good, I bet I'm not the only one that will hit this...

> Thanks again for testing and reporting!

No problem, and thank you! ;)

> NeilBrown
