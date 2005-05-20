From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: Bug report: mdadm -E oddity
Date: Fri, 20 May 2005 16:05:11 -0400
Message-ID: <428E42F7.40208@steeleye.com>
References: <1115999051.3974.14.camel@compaq-rhel4.xsintricity.com> <1116004267.3974.35.camel@compaq-rhel4.xsintricity.com> <17029.12773.197506.463977@cse.unsw.edu.au> <1116077316.13780.52.camel@compaq-rhel4.xsintricity.com> <17037.35615.456231.737766@cse.unsw.edu.au> <1116592212.23785.75.camel@compaq-rhel4.xsintricity.com> <428E0A92.3060108@steeleye.com> <1116611115.23785.89.camel@compaq-rhel4.xsintricity.com> <d5n1m2-rb5.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d5n1m2-rb5.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer wrote:

>    b) rewriting is not necessarily idempotent, when half of it consists
>       of using a parity to construct what you should write.

That's right. The rewrite is not idempotent. Having lost part, or all, 
of either D1 or P at the time of the crash, you no longer have any 
accurate way of reconstructing D2.

And that's assuming you can even do a rewrite. By default, only metadata 
is journalled (in ext3), so for plain old data writes, you're just plain 
out of luck...

--
Paul
