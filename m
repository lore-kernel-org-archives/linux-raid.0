From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: RAID0 performance question
Date: Tue, 22 Nov 2005 02:14:31 +0100
Message-ID: <00ce01c5ef02$2192f7a0$a700a8c0@dcccs>
References: <437E2CB6.2030903@xss.co.at> <200512022253.17282.a1426z@gawab.com> <00fd01c60367$d8d8f5d0$0400a8c0@dcccs> <200512191416.10665.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Al Boldi <a1426z@gawab.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message ----- 
From: "Al Boldi" <a1426z@gawab.com>
To: "JaniD++" <djani22@dynamicweb.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Monday, December 19, 2005 12:16 PM
Subject: Re: RAID0 performance question


> JaniD++ wrote:
> > For me, the performance bottleneck is cleanly about RAID0 layer used
> > exactly as "concentrator" to join the 4x2TB to 1x8TB.
>
> Did you try running RAID0 over nbd directly and found it to be faster?

At this time i cannot test it, because the system is loaded, and the result
will fase.
Anyway i will probe this....

>
> IIRC, stacking raid modules does need a considerable amount of tuning, and
> even then it does not scale linearly.
>
> Maybe NeilBrown can help?

Maybe, but it looks like Neil is not interested. :-(

And the more probles is, i plan to modify the entire system structure, and
will not be spare drives to testing soon... :-/

Cheers,
Janos



