From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Can you help me on Linux SW RAID?
Date: Thu, 28 Apr 2005 13:49:22 +0200
Message-ID: <20050428114922.GN21645@marowsky-bree.de>
References: <IFNN5L$54F0619DC10E22BF63406272D5963076@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <IFNN5L$54F0619DC10E22BF63406272D5963076@libero.it>
Sender: linux-raid-owner@vger.kernel.org
To: "miele@inwind.it" <miele@inwind.it>, jakob <jakob@unthought.net>
Cc: linux-raid <linux-raid@vger.kernel.org>, mingo <mingo@chiara.csoma.elte.hu>, bueso <bueso@vives.org>
List-Id: linux-raid.ids

On 2005-04-28T13:41:45, "miele@inwind.it" <miele@inwind.it> wrote:

> Obviously I've plan to use OCFS (Oracle Cluster File System) to share
> data access between nodes...
> ..I've to implement an Oracle 9i RAC.

OCFS2 is fine for that.

> You discourage anyway my use of RAID??

md is NOT CLUSTER-AWARE. It will not work, and it will eat your data.

You have been warned.

Run the RAID level of your choice on the SAN backend, and put OCFS2 on
top.


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
