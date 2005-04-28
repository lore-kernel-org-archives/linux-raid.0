From: "J. Ryan Earl" <ryan@dynaconnections.com>
Subject: RE: Can you help me on Linux SW RAID?
Date: Thu, 28 Apr 2005 14:18:28 -0500
Message-ID: <OMEKLMBKKEOEENCKLEIDAEPDCIAA.ryan@dynaconnections.com>
References: <20050428130633.GT21645@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050428130633.GT21645@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>, miele@inwind.it
Cc: jakob <jakob@unthought.net>, linux-raid <linux-raid@vger.kernel.org>, mingo <mingo@chiara.csoma.elte.hu>, bueso <bueso@vives.org>
List-Id: linux-raid.ids

OCFS2 isn't stable yet, I wouldn't suggest its use for production syste=
ms.
=46urthermore, where did the requirement for 2.6 (kernel I assume) come=
 from?
Sounds like he was using RHEL3 anyway...

I'm not familar with the 9i RAC setup, but I installed a 10g RAC that's=
 in
production now.  The only thing I use OCFS for is Cluster Registry, Dis=
k
Voting, and the Oracle Parameter File.  All database nodes have access =
to
the same set of raw LUNs on the SAN managed via ASM (Automated Storage
Management, a 10g feature) for keeping actual data on.  You could just =
put
all your Oracle files/data on OCFS, but that's not the highest performa=
nce
solution.

To have multiple nodes access a non-Oracle data on a clustered filesyst=
em,
go with GFS for sure, ie a normal POSIX complaint filesystem.  OCFSv1 i=
sn't
POSIX complaint and only properly stores Oracle specific files, and tho=
ugh
OCFSv2 is meant to be a generic clustered filesystem, it's not producti=
on
ready like I mentioned before: http://oss.oracle.com/projects/ocfs2/

How you setup the RAID is completely different issue from how you clust=
er
your data among nodes.

-ryan

-----Original Message-----
=46rom: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Lars Marowsky-Bre=
e
Sent: Thursday, April 28, 2005 8:07 AM
To: miele@inwind.it
Cc: jakob; linux-raid; mingo; bueso
Subject: Re: Can you help me on Linux SW RAID?


On 2005-04-28T14:57:29, "miele@inwind.it" <miele@inwind.it> wrote:

> Have you experienced problem using OCFS insetad of OCFS2??

OCFS isn't available on 2.6. On 2.6, you have to use OCFS2.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
