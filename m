From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: some non critical problems... (1. mdadm segfault ->
 write-mostly, 2. smart?)
Date: Mon, 6 Sep 2010 14:17:14 +0200
Message-ID: <20100906141714.32a5dba4@atak.bl.pg.gda.pl>
References: <20100906141324.1a19fa4d@atak.bl.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100906141324.1a19fa4d@atak.bl.pg.gda.pl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janek Kozicki said:     (by the date of Mon, 6 Sep 2010 14:13:24 +0200)

> Sep  1 18:23:33 atak kernel: [   19.506889] mdadm[3703]: segfault at 134 ip 00007f903caefd9a sp 00007fff45025010 error 4 in libc.so.6[7f903caaa000+158000]
> Sep  1 18:23:33 atak kernel: [   19.507677] mdadm[3706]: segfault at 134 ip 00007f5779212d9a sp 00007fff81748740 error 4 in libc.so.6[7f57791cd000+158000]
> Sep  1 18:23:33 atak kernel: [   19.527658] mdadm[3705]: segfault at 134 ip 00007f5779212d9a sp 00007fff81748740 error 4 in libc.so.6[7f57791cd000+158000]

I should have all the debug information installed and System.map file
too. So if you need some file to identify what is 00007f903caefd9a,
please tell. Personally I don't know how to find what is
00007f903caefd9a. Just tell me what to do, if you feel like
investigating this further.

-- 
Janek Kozicki                               http://janek.kozicki.pl/  |
