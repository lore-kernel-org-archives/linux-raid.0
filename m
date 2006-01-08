From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: mdadm-2.2 SEGFAULT: mdadm --assemble --scan
Date: Sun, 08 Jan 2006 16:23:35 -0500
Message-ID: <43C182D7.5030105@tmr.com>
References: <20051222205809.GC492@skl-net.de> <43B6A0F9.8040100@xss.co.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43B6A0F9.8040100@xss.co.at>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Haumer <andreas@xss.co.at>
Cc: Andre Noll <maan@systemlinux.org>, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Andreas Haumer wrote:

>-----BEGIN PGP SIGNED MESSAGE-----
>Hash: SHA1
>
>Hi!
>
>Andre Noll schrieb:
>  
>
>>sorry if this is already known/fixed: Assemble() is called from mdadm.c with
>>the "update" argument equal to NULL:
>>
>>	Assemble(ss, array_list->devname, mdfd, array_list, configfile,
>>		NULL, readonly, runstop, NULL, verbose-quiet, force);
>>
>>But in Assemble.c we have
>>
>>	if (ident->uuid_set && (!update && strcmp(update, "uuid")!= 0) && ...
>>
>>which yields a segfault in glibc's strcmp().
>>
>>    
>>
>I just found the same problem after upgrading to mdadm-2.2
>The logic to test for update not being NULL seems to be
>reversed.
>
>I created a small patch which seems to cure the problem
>(see attached file)
>
>HTH
>
>- - andreas
>
>- --
>Andreas Haumer                     | mailto:andreas@xss.co.at
>*x Software + Systeme              | http://www.xss.co.at/
>Karmarschgasse 51/2/20             | Tel: +43-1-6060114-0
>A-1100 Vienna, Austria             | Fax: +43-1-6060114-71
>-----BEGIN PGP SIGNATURE-----
>Version: GnuPG v1.4.2 (GNU/Linux)
>Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org
>
>iD8DBQFDtqD0xJmyeGcXPhERAsdiAJ0Ve787gscq4VOGtT+9Qp3k62iUEgCgs9pH
>Ekg0gkLEk+99XXHw+1ezdu8=
>=rh66
>-----END PGP SIGNATURE-----
>  
>
>------------------------------------------------------------------------
>
>Index: mdadm/Assemble.c
>===================================================================
>RCS file: /home/cvs/repository/distribution/Utilities/mdadm/Assemble.c,v
>retrieving revision 1.1.1.7
>diff -u -r1.1.1.7 Assemble.c
>--- mdadm/Assemble.c	5 Dec 2005 05:56:20 -0000	1.1.1.7
>+++ mdadm/Assemble.c	31 Dec 2005 15:01:34 -0000
>@@ -219,7 +219,7 @@
> 		}
> 		if (dfd >= 0) close(dfd);
> 
>-		if (ident->uuid_set && (!update && strcmp(update, "uuid")!= 0) &&
>+		if (ident->uuid_set && (update && strcmp(update, "uuid")!= 0) &&
> 		    (!super || same_uuid(info.uuid, ident->uuid, tst->ss->swapuuid)==0)) {
> 			if ((inargv && verbose >= 0) || verbose > 0)
> 				fprintf(stderr, Name ": %s has wrong uuid.\n",
>  
>
Is that right now? Because && evaluates to zero or one left to right, 
the parens and the "!=0" are not needed, and I assume they're in for a 
reason (other than to make the code hard to understand). A comment 
before that if would make the intention clear, I originally though the 
"(!update" was intended to be "!(update" which would explain the parens, 
but that seems wrong.

If it actually works as intended with the patch, perhaps a comment and 
cleanup in 2.3?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

