From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: monitoring multipath arrays plus inconsistent /proc/mdstat?
Date: Thu, 21 Oct 2004 18:51:19 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041021165119.GU3911@marowsky-bree.de>
References: <4177E0D1.7090001@bms.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4177E0D1.7090001@bms.com>
To: Anu Matthew <anu.matthew@bms.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2004-10-21T12:16:17, Anu Matthew <anu.matthew@bms.com> wrote:

> Whom to trust here? How do we monitor multipath arrays effectively?

On 2.6, use multipath-tools, which are seeing active development.
multipath storage is being moved to the Device-Mapper in 2.6.


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX AG - A Novell company

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
