From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: [PATCH 1/2] md bitmap bug fixes
Date: Sat, 19 Mar 2005 13:05:43 -0500
Message-ID: <200503191805.j2JI5mT25426@www.watkins-home.com>
References: <20050319175417.GU18819@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
In-Reply-To: <20050319175417.GU18819@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: 'Lars Marowsky-Bree' <lmb@suse.de>, "'Peter T. Breuer'" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Oh!  I never read it like you just said.  I have been reading it like c=
opy
in both directions based on both bitmaps!  What you said below, seems
reasonable.

Guy

-----Original Message-----
=46rom: Lars Marowsky-Bree [mailto:lmb@suse.de]=20
Sent: Saturday, March 19, 2005 12:54 PM
To: Guy; 'Peter T. Breuer'; linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/2] md bitmap bug fixes

On 2005-03-19T12:44:14, Guy <bugzilla@watkins-home.com> wrote:

> In the case of a split brain, I think one must be 100% voided, and a =
full
> re-sync must be done.

Exactly. And that's where the bitmaps come into play; you can look at
what is modified on each side, merge those sets, and copy all affected
blocks from one side to the other; afterwards, you'll have a consistent
block device again.


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
