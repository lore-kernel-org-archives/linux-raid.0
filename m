From: David Greaves <david@dgreaves.com>
Subject: Re: howto and faq
Date: Mon, 12 May 2008 09:46:01 +0100
Message-ID: <482803C9.6080202@dgreaves.com>
References: <20080207164249.GA7116@rap.rap.dk>	<47AECC59.1020808@dgreaves.com>	<20080210111404.GA4823@rap.rap.dk>	<47AF4094.3040702@dgreaves.com>	<20080511103243.GA1128@rap.rap.dk>	<48272B4F.6090001@tmr.com>	<48275486.1000607@dgreaves.com> <18471.34255.88287.478361@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18471.34255.88287.478361@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Bill Davidsen <davidsen@tmr.com>, =?ISO-8859-1?Q?Keld_J=F8rn_Simo?= =?ISO-8859-1?Q?nsen?= <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Sunday May 11, david@dgreaves.com wrote:
>> Err, Neil....
>=20
> What exactly did you see when you checking in git?

Oops, my mistake - my nroff reading skills are clearly lacking :)

In my head I was planning on replacing the unthought.net link and when =
I saw it
 was still there I didn't look further to see the extra URL - thanks fo=
r that :)

I wonder if it's time to deprecate the http://unthought.net/Software-RA=
ID.HOWTO/
reference though? Jakob agreed to the inclusion of all the material in =
the wiki
so we're not losing anything (and we are on a webwide URL cleaning exer=
cise at
the moment.)

So, you may feel that:

=46or further information on mdadm usage, MD and the various levels of
RAID, see:
  http://linux-raid.osdl.org/
(based upon Jakob =D8stergaard's Software-RAID.HOWTO)

is now appropriate... if which case, patch below.

David

---

Author: David Greaves <david@dgreaves.com>
Date:   Mon May 12 09:40:39 2008 +0100

    Remove outdated HOWTO link and credit Jakob's contribution.

    Signed-off-by: David Greaves <david@dgreaves.com>

diff --git a/mdadm.8 b/mdadm.8
index d3cecb8..cd3028d 100644
--- a/mdadm.8
+++ b/mdadm.8
@@ -2105,17 +2105,15 @@ package, and does not use the
 configuration file at all.

 .SH SEE ALSO
-For further information on MD and the various levels of
+For further information on mdadm usage, MD and the various levels of
 RAID, see:

 .IP
-.UR  http://unthought.net/Software-RAID.HOWTO/
-http://unthought.net/Software\-RAID.HOWTO/
-.UE
-.IP
 .UR http://linux-raid.osdl.org/
 http://linux\-raid.osdl.org/
 .UE
+.PP
+(based upon Jakob \(/Ostergaard's Software\-RAID.HOWTO)
 .\".PP
 .\"for new releases of the RAID driver check out:
 .\"


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
