From: Al Boldi <a1426z@gawab.com>
Subject: Re: [PATCH md 006 of 6] Add write-behind support for md/raid1
Date: Mon, 15 Aug 2005 07:45:53 +0300
Message-ID: <200508150745.53213.a1426z@gawab.com>
References: <20050811171720.10115.patches@notabene> <200508130800.32901.a1426z@gawab.com> <17151.50336.645817.629042@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17151.50336.645817.629042@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Paul Clements <paul.clements@steeleye.com>, Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> As read-latency and write-latency are likely to go together, it
> seems reasonable for WriteMostly and WriteBehind to go together. 
> Do you disagree?

In OOP terms, always try to remove dependencies.
Try to make your implementation as general as possible to facilitate 
code reuse thus increasing scalability!

--
Al

