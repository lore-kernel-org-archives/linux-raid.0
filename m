From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem
Date: Thu, 3 Feb 2005 17:59:34 +0100
Message-ID: <20050203165934.GU7628@marowsky-bree.de>
References: <200502031145.j13Bj1fl016074@terminus.zytor.com> <420253CD.9010505@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-Disposition: inline
In-Reply-To: <420253CD.9010505@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>, Ruth Ivimey-Cook <Ruth.Ivimey-Cook@ivimey.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2005-02-03T08:39:41, "H. Peter Anvin" <hpa@zytor.com> wrote:

> Yes, right now there is no RAID5->RAID6 conversion tool that I know o=
f.

Hm. One of the checksums is identical, as is the disk layout of the
data, no?

So wouldn't mdadm with the right parameters forcing the right super
block to be written, and then the missing disk to be hot-added "convert=
"
this?

But yes, I'd recommend a backup before doing so ;-)


Mit freundlichen Gr=FC=DFen,
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
