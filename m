From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH] secure write for RAID1
Date: Mon, 25 Apr 2005 14:33:28 +0200
Message-ID: <20050425123328.GP32085@marowsky-bree.de>
References: <1toqj2-sjd.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1toqj2-sjd.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-04-23T22:48:01, "Peter T. Breuer" <ptb@lab.it.uc3m.es> wrote:

> This patch (completely untested of course - what, me?) makes RAID1 wr=
ite
> to all components of a raid-1 array, else return error to the write
> attempt, when one component cannot be written.

Would it make sense to generalize and introduce a "write quorum" for
arrays with more than 2 mirrors - ie, must be committed to at least n
disks?

This would also apply to RAID6, actually. One could say that it needs t=
o
be committed to N-1 disks; as RAID6 could cope with N-2 failures,
redundancy would still be preserved.


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
