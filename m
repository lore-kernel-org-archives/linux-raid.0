From: "JaniD++" <djani22@dynamicweb.hu>
Subject: Re: RAID0 performance question
Date: Wed, 23 Nov 2005 11:48:10 +0100
Message-ID: <013901c5f01b$6aae7ad0$a700a8c0@dcccs>
References: <437E2CB6.2030903@xss.co.at> <200512022253.17282.a1426z@gawab.com> <00fd01c60367$d8d8f5d0$0400a8c0@dcccs> <200512191416.10665.a1426z@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
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

Now i trying the NBD + RAID0 without the middle layer raid1.
I wondering, the speed is much more better!

If i use dd in the raid0 and the raid1 layer is active, the traffic is
350-400Mbit/s
If i use dd in the raid0 and the raid1 layer is inactive, the traffic is
512-620Mbit/s!
If i use parallel dd on all NBD devices, the traffic is 650-720Mbit/s.

(on my system's current minimal load)

I found it very interesting!
The kernel never reports timing information about raids in
/sys/block/mdX/stat files!

I cannot understand...

Cheers,
Janos

