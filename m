From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Sat, 19 Mar 2005 13:58:21 +0100
Message-ID: <20050319125821.GO18819@marowsky-bree.de>
References: <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <d1f8fr$k8f$1@sea.gmane.org> <e1nrg2-os1.ln1@news.it.uc3m.es> <d1fd9v$7h6$1@sea.gmane.org> <dsftg2-8cr.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-Disposition: inline
In-Reply-To: <dsftg2-8cr.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-03-19T12:43:41, "Peter T. Breuer" <ptb@lab.it.uc3m.es> wrote:

> Well, there is the "right data" from our point of view, and it is wha=
t
> should by on (one/both?) device by now.  One doesn't get to recover t=
hat
> "right data" by copying one disk over another, however efficiently on=
e
> does it.

It's about conflict resolution and recovery after a split-brain and
concurrent service activation has occured.

Read up on that here:
http://www.linux-mag.com/2003-11/availability_01.html (see the blob
about split-brain with drbd).

It all depends on the kind of guarantees you need.

> But neither mirror is necessarily right.  We are already in a bad
> situation.  There is no good way out.  You can merely choose which of
> the two data possibilities you want for each block.  They're not
> necesarily either of them "right", but one of them may be, but which =
one
> we don't know.

It's quite clear that you won't get a consistent state of the system by
mixing blocks from either side; you need to declare one the 'winner',
throwing out the modifications on the other side (probably after having
them saved manually, and then re-entering them later). For some
scenarios, this is acceptable.

> Why should one think that copying all of one disk to the other (moral=
ly)
> gets one data that is more right than copying some of it? Nothing one
> can do at this point will help.

It's not a moral problem. It is about regaining consistency.

Which one of the datasets you choose you could either arbitate via some
automatic mechanisms (drbd-0.8 has a couple) or let a human decide.

The default with drbd-0.7 is that they will detect this situation has
occured and refuse to start replication unless the admin intervenes and
decides which side wins.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
