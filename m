From: =?utf-8?Q?Rainer_F=C3=BCgenstein?= <rfu@oudeis.org>
Subject: Re: kernel: BUG: soft lockup - CPU#1 stuck for 60s! [md0_raid5:1614]
Date: Fri, 16 Oct 2015 21:31:03 +0200
Message-ID: <465170352.20151016213103@oudeis.org>
References: <1092031595.20151015153830@oudeis.org> <87si5bvcj4.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87si5bvcj4.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <nfbrown@novell.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Neil,

Friday, October 16, 2015, 3:15:59 AM, you wrote:

> I strongly recommend adding a write-intend bitmap
>   mdadm --grow /dev/md0 --bitmap=internal
> that will speed up the resync enormously.

thanks  for  the  hint,  will  do so as soon as the current resync has
finished.

> This is a rather ancient kernel.
> The "el" suffix probably suggests Redhat?

sorry, forgot to mention: it's Centos5.11


-- 
Best regards,
 Rainer                            mailto:rfu@oudeis.org

