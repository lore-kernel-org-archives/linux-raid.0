From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Can you help me on Linux SW RAID?
Date: Thu, 28 Apr 2005 21:56:10 +0200
Message-ID: <20050428195610.GO21645@marowsky-bree.de>
References: <20050428130633.GT21645@marowsky-bree.de> <OMEKLMBKKEOEENCKLEIDAEPDCIAA.ryan@dynaconnections.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <OMEKLMBKKEOEENCKLEIDAEPDCIAA.ryan@dynaconnections.com>
Sender: linux-raid-owner@vger.kernel.org
To: "J. Ryan Earl" <ryan@dynaconnections.com>, miele@inwind.it
Cc: jakob <jakob@unthought.net>, linux-raid <linux-raid@vger.kernel.org>, mingo <mingo@chiara.csoma.elte.hu>, bueso <bueso@vives.org>
List-Id: linux-raid.ids

On 2005-04-28T14:18:28, "J. Ryan Earl" <ryan@dynaconnections.com> wrote=
:

> OCFS2 isn't stable yet, I wouldn't suggest its use for production sys=
tems.
> Furthermore, where did the requirement for 2.6 (kernel I assume) come=
 from?
> Sounds like he was using RHEL3 anyway...

That wasn't mentioned in the mail I replied to; anyone deploying a new
2.4 based system right now is a bit behind the times in my opinion, I
hope 2.4 goes away soon ;-)

OCFS2 is already included in SLES9 SP2 beta; we'll ship it for
production use with SLES9 SP2 general availability.


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
