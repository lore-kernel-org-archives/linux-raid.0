From: "Georg C. F. Greve" <greve@fsfeurope.org>
Subject: Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard
Date: Thu, 30 Dec 2004 17:23:17 +0100
Message-ID: <m38y7fn4ay.fsf@reason.gnu-hamburg>
References: <m3is6k4oeu.fsf@reason.gnu-hamburg>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="20041230172317+0100-64656733-12391328-91779438";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <m3is6k4oeu.fsf@reason.gnu-hamburg> (Georg C. F. Greve's message
	of "Thu, 30 Dec 2004 01:31:37 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: dm-crypt@saout.de
List-Id: linux-raid.ids

--20041230172317+0100-64656733-12391328-91779438

[ update ]

Okay, tried to find out what is causing the kernel to crash and so I
replaced the dm-crypt part by cryptoloop: same effect.

Then I tried ext3 on top of LVM2 RAID5 with no encryption and it still
crashes. Not sure what is causing the problem exactly, but it does not
seem that dm-crypt is to blame anymore.

The message I saw on the remote console when it crashed with pure ext3
on raid5 was:

 Assertion failure in journal_start() at fs/jbd/transaction.c:271: "handle->h_transaction->t_journal == journal"


Hope this helps -- filed the bug as #3968 on buzilla.kernel.org, more
info at 

  http://bugzilla.kernel.org/show_bug.cgi?id=3968

Help appreciated, let me know if you have an idea.

Regards,
Georg

-- 
Georg C. F. Greve                                       <greve@gnu.org>
Free Software Foundation Europe	                 (http://fsfeurope.org)
Brave GNU World	                           (http://brave-gnu-world.org)

--20041230172317+0100-64656733-12391328-91779438
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.3.92 (GNU/Linux)

iD8DBQBB1Ct1bvivwoZXSsoRAlQiAJ9f/xFoljpzG041ttBDZcKxEPAPgwCaAmkI
ny2HKC15P8D2NPFyOKINYGY=
=dqK1
-----END PGP SIGNATURE-----
--20041230172317+0100-64656733-12391328-91779438--
