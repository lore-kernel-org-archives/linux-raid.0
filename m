From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Bug#658701: mdadm: should send email if mismatches are reported
 by a check
Date: Thu, 12 Apr 2012 23:28:45 +0400
Message-ID: <4F872CED.7050809@msgid.tls.msk.ru>
References: <20120205123450.21371.88843.reportbug@xev> <4F2E90AD.3020405@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F2E90AD.3020405@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: 658701@bugs.debian.org, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil, re http://bugs.debian.org/658701 , how do you think,
is it okay if mdadm --monitor will send email in case check
found mismatches, the same way it sends email about other
more critical errors?

I think Russell has a good point here, but there's one more
source of mismatches we have in kernel - some "sporadic"
mismatches in raid1 and raid10, especially when these are
used as swap space...

In Debian we've several bugreports already requesting more
attention to mismatch_cnt, see:

 http://bugs.debian.org/658701 (this one)
 http://bugs.debian.org/599821
 http://bugs.debian.org/588516

Thank you!

/mjt
