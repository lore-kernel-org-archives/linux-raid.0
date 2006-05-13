From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Removing a RAID 1 setting without loosing data
Date: Sat, 13 May 2006 16:16:38 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0605131612030.19433@lion.drogon.net>
References: <1147531525.6198.8.camel@nachus.raulgomez.net>
 <Pine.LNX.4.56.0605131548450.19433@lion.drogon.net>
 <1147532647.6198.16.camel@nachus.raulgomez.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1147532647.6198.16.camel@nachus.raulgomez.net>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Ra=FAl_G=F3mez?= Cabrera <raulgomezc@acm.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 13 May 2006, Ra=FAl G=F3mez Cabrera wrote:

> Hi Gordon, thanks for your quick response.
>
> Well my client does not want to spend more money on this particular
> server, I think maybe that is because they are planning to replace it=
=2E..

Ask your client just how valuable their email data is...

How badly broken is the drive? If it's just a bad sector then you may b=
e
able to resurect it - which will provide a degree of redundancy again
util such time as the server can be replaced.

If you use mdadm to remove all the md? partitions, (mdadm --remove
/dev/md? /dev/sdb?) then you can run something like

  badblocks -w -s -c 128 /dev/sdb?

etc. for every partition that was in the md? arrays. This will write to
every sector and will force a sector re-allocate on bad sectors, if the
drive supports it. You can then mdadm --add them back into the array.

(Running a badblocks in standard read mode on the live partitions is
always prudent at this point though just in-case you find another band
sector there!)

Gordon

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
