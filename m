From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [PATCH 000 of 5] md: Introduction
Date: Thu, 19 Jan 2006 17:17:30 -0500
Message-ID: <43D00FFA.1040401@cfl.rr.com>
References: <26A66BC731DAB741837AF6B2E29C1017D47EA0@xmb-hkg-413.apac.cisco.com> <Pine.LNX.4.61.0601181427090.19392@yvahk01.tjqt.qr> <17358.52476.290687.858954@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17358.52476.290687.858954@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, "Lincoln Dale (ltd)" <ltd@cisco.com>, Michael Tokarev <mjt@tls.msk.ru>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Steinar H. Gunderson" <sgunderson@bigfoot.com>
List-Id: linux-raid.ids

I'm currently of the opinion that dm needs a raid5 and raid6 module 
added, then the user land lvm tools fixed to use them, and then you 
could use dm instead of md.  The benefit being that dm pushes things 
like volume autodetection and management out of the kernel to user space 
where it belongs.  But that's just my opinion...


I'm using dm at home because I have a sata hardware fakeraid raid-0 
between two WD 10,000 rpm raptors, and the dmraid utility correctly 
recognizes that and configures device mapper to use it. 


Neil Brown wrote:
> Which bits?
> Why?
>
> My current opinion is that you should:
>
>  Use md for raid1, raid5, raid6 - anything with redundancy.
>  Use dm for multipath, crypto, linear, LVM, snapshot
>  Use either for raid0 (I don't think dm has particular advantages
>      for md or md over dm).
>
> These can be mixed together quite effectively:
>   You can have dm/lvm over md/raid1 over dm/multipath
> with no problems.
>
> If there is functionality missing from any of these recommended
> components, then make a noise about it, preferably but not necessarily
> with code, and it will quite possibly be fixed.
