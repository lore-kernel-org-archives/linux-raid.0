From: Andreas-Sokov <andre.s@j8.com.ru>
Subject: Re[4]: mdadm 2.6.4 : How i can check out current status of reshaping ?
Date: Sat, 9 Feb 2008 07:40:37 +0300
Message-ID: <16910175728.20080209074037@j8.com.ru>
References: <79188012.20080204070802@j8.com.ru>
 <18343.38465.112723.66522@notabene.brown> <58351009.20080205121332@j8.com.ru>
 <18344.13816.921912.885730@notabene.brown>
Reply-To: Andreas-Sokov <andre.s@j8.com.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1251
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18344.13816.921912.885730@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, Neil.

YOU WROTE : 5 =F4=E5=E2=F0=E0=EB=FF 2008 =E3., 13:10:00:
> On Tuesday February 5, andre.s@j8.com.ru wrote:
>> Feb  5 11:56:12 raid01 kernel: BUG: unable to handle kernel paging r=
equest at virtual address 001cd901

> This looks like some sort of memory corruption.

=2E...

> Possible you have bad memory, or a bad CPU, or you are overclocking
> the CPU, or it is getting hot, or something.


> But you clearly have a hardware error.

> NeilBrown

At this moment i have checked my server. As you wrote earlier Somethere=
 is hidden
prblem or problems. We try find in waht is it and did not find. Try cha=
nge other
memory modules - result was same (kernel panic, one way or another).

SO, then we move RAID-HDDs into another computer reshape have passed fi=
ne!
And now there continue reshape 5->7 drives normaly.

Thank you very much !

--=20
Best regards,
Andreas-Sokov

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
