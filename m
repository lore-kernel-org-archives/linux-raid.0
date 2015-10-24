From: =?utf-8?Q?Rainer_F=C3=BCgenstein?= <rfu@oudeis.org>
Subject: performance issue (was: Re: kernel: BUG: soft lockup - CPU#1 stuck for 60s!)
Date: Sat, 24 Oct 2015 18:15:41 +0200
Message-ID: <43246687.20151024181541@oudeis.org>
References: <1092031595.20151015153830@oudeis.org> <87si5bvcj4.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87si5bvcj4.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <nfbrown@novell.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hi,

> I strongly recommend adding a write-intend bitmap
>   mdadm --grow /dev/md0 --bitmap=internal

I  did  as suggested, but now it feels like performance has dropped to
about 1/4th of what it used to be before. since this system is already
pretty slow by design, this is quite frustrating.

no soft-lockups so far, fortunately.

may  a  new  kernel speed things up again? or can --bitmap=internal be
undone?
(need some time to prepare the upgrade to a new OS release)

tnx & cu

-- 
Best regards,
 Rainer                            mailto:rfu@oudeis.org

