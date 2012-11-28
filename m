From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Checksumming RAID?
Date: Wed, 28 Nov 2012 12:16:52 -0700
Message-ID: <7CDEA2A5-3B4A-444B-806E-E0A6CC9DD43E@colorremedies.com>
References: <28168570.25.1354125110341.JavaMail.root@zimbra>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <28168570.25.1354125110341.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Nov 28, 2012, at 10:51 AM, Roy Sigurd Karlsbakk <roy@karlsbakk.net> =
wrote:
>=20
> Google had a study some years ago, which at that point showed desktop=
 drives and enterprise drives had about the same error rate. That may b=
e slightly outdated now, but still=85

The only Google drive study I'm aware of is this one:
http://static.googleusercontent.com/external_content/untrusted_dlcp/res=
earch.google.com/en/us/archive/disk_failures.pdf

That study is about drive failures, not SDC. They aren't looking at cor=
ruption, but rather SMART errors relating to disk failure. And the disk=
s are consumer grade, none were enterprise.

The main finding of the study is the correlation (or lack thereof) of S=
MART prediction of drive failure (the health status of the drive) to re=
ality. It turns out SMART is not so great at doing this if you only tru=
st the health status. You can get better prediction of drive failure by=
 taking specific attributes into account, but even this isn't completel=
y reliable. New attributes are needed to better predict drive failures =
is the take away.


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
