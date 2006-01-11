From: Andreas Haumer <andreas@xss.co.at>
Subject: Re: mdadm-2.2 SEGFAULT: mdadm --assemble --scan
Date: Wed, 11 Jan 2006 14:51:56 +0100
Message-ID: <43C50D7C.30106@xss.co.at>
References: <20051222205809.GC492@skl-net.de> <43B6A0F9.8040100@xss.co.at> <43C182D7.5030105@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43C182D7.5030105@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Andre Noll <maan@systemlinux.org>, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi!

Bill Davidsen schrieb:
> Andreas Haumer wrote:
> 

- ------------------------------------------------------------------------
>>
Index: mdadm/Assemble.c
===================================================================
RCS file: /home/cvs/repository/distribution/Utilities/mdadm/Assemble.c,v
retrieving revision 1.1.1.7
diff -u -r1.1.1.7 Assemble.c
- --- mdadm/Assemble.c    5 Dec 2005 05:56:20 -0000    1.1.1.7
+++ mdadm/Assemble.c    31 Dec 2005 15:01:34 -0000
@@ -219,7 +219,7 @@
        }
        if (dfd >= 0) close(dfd);
>>
- -        if (ident->uuid_set && (!update && strcmp(update, "uuid")!=
0) &&
+        if (ident->uuid_set && (update && strcmp(update, "uuid")!= 0) &&
            (!super || same_uuid(info.uuid, ident->uuid,
tst->ss->swapuuid)==0)) {
            if ((inargv && verbose >= 0) || verbose > 0)
                fprintf(stderr, Name ": %s has wrong uuid.\n",

>>
> Is that right now? Because && evaluates to zero or one left to right,
> the parens and the "!=0" are not needed, and I assume they're in for a
> reason (other than to make the code hard to understand). A comment
> before that if would make the intention clear, I originally though the
> "(!update" was intended to be "!(update" which would explain the parens,
> but that seems wrong.

I made this modification out of the following reasoning:

It does not make sense to check if update is NULL and
then use it in a strcmp(). It only makes sense to check
if update is _not_ NULL and then do the strcmp()

(a similar code fragment can be found in the same sourcefile
several lines below)

This cures the segfault, but I can not really say if the
whole construct is logically correct (you are right, it
looks suspicious...)
That should be answered by Neil ;-)

- - andreas

- --
Andreas Haumer                     | mailto:andreas@xss.co.at
*x Software + Systeme              | http://www.xss.co.at/
Karmarschgasse 51/2/20             | Tel: +43-1-6060114-0
A-1100 Vienna, Austria             | Fax: +43-1-6060114-71
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFDxQ16xJmyeGcXPhERAs2fAJ44Pta06tMd6yI5HqXuRvYkKbWHSACfcPjD
y+b0ddT/ezuqf+rHurm2+Wo=
=SkuC
-----END PGP SIGNATURE-----
