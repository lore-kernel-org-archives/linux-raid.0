From: Daniel Boggs <BecauseImAwesome@Live.com>
Subject: Re: Searching, but not finding...
Date: Mon, 10 May 2010 15:49:20 -0700
Message-ID: <AANLkTikUVXZXHmBzzn3WtqEYID8Si0nw7T_wjz5D32Xm@mail.gmail.com>
References: <AANLkTik7Ekdhv5qGMzyMu0Q5XhKq7JbaxZFLX6SKl5Zu@mail.gmail.com>
	 <AANLkTinwZPdZw_kUEaV4wHRAI4n0hstu970_lyU04jt_@mail.gmail.com>
	 <20100511065417.204d585e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100511065417.204d585e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Question:

If I use:

>>> echo repair > /sys/block/mdX/md/sync_action

to start a check action, then stop it with

>>> echo idle > /sys/block/mdX/md/sync_action

and later start it up again. =A0Will it start again from the
"beginning", or is it able to pick up where it left off?

Essentially if I find the repair/sync action causes too much of a
performance hit, could I have it run only during hours that I know the
array will not be in use and still have the array checked in its
entirety, or is the only way to accomplish that to let the action run
from start to finish?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
