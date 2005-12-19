From: Al Boldi <a1426z@gawab.com>
Subject: Re: RAID0 performance question
Date: Mon, 19 Dec 2005 14:16:10 +0300
Message-ID: <200512191416.10665.a1426z@gawab.com>
References: <437E2CB6.2030903@xss.co.at> <200512022253.17282.a1426z@gawab.com> <00fd01c60367$d8d8f5d0$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <00fd01c60367$d8d8f5d0$0400a8c0@dcccs>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

JaniD++ wrote:
> For me, the performance bottleneck is cleanly about RAID0 layer used
> exactly as "concentrator" to join the 4x2TB to 1x8TB.

Did you try running RAID0 over nbd directly and found it to be faster?

IIRC, stacking raid modules does need a considerable amount of tuning, and 
even then it does not scale linearly.

Maybe NeilBrown can help?

--
Al

