From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH md 0 of 4] Introduction
Date: Tue, 8 Mar 2005 13:49:10 +0100
Message-ID: <6jj0g2-c27.ln1@news.it.uc3m.es>
References: <20050308165021.3745.patches@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@cse.unsw.edu.au> wrote:
> The second two fix bugs that were introduced by the recent=20
> bitmap-based-intent-logging patches and so are not relevant

Neil - can you describe for me (us all?) what is meant by
intent=ADlogging here.

Well, I can guess - I suppose the driver marks the bitmap before a writ=
e
(or group of writes) and unmarks it when they have completed
successfully.  Is that it?

If so, how does it manage to mark what it is _going_ to do (without
psychic powers) on the disk bitmap?  Unmarking is easy - that needs a
queue of things due to be unmarked in the bitmap, and a point in time a=
t
which they are all unmarked at once on disk.

Then resync would only deal with the marked blocks.

Peter

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
