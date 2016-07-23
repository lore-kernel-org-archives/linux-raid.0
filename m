From: Bhatia Amit <amitbhatia@rocketmail.com>
Subject: Re: Cannot start array on disk
Date: Sat, 23 Jul 2016 22:21:36 +0000 (UTC)
Message-ID: <578225037.3489302.1469312496573.JavaMail.yahoo@mail.yahoo.com>
References: <1124605843.526681.1468785592654.JavaMail.yahoo.ref@mail.yahoo.com> <1124605843.526681.1468785592654.JavaMail.yahoo@mail.yahoo.com> <73583e52-ca6b-b043-cbae-02c8a122be24@turmel.org> <1436537429.1672198.1468980612541.JavaMail.yahoo@mail.yahoo.com> <1537154003.1687848.1468983169996.JavaMail.yahoo@mail.yahoo.com> <6b958d9f-ec61-3b87-fcd7-ff63c0af32fe@turmel.org> <1334935791.2305089.1469066429563.JavaMail.yahoo@mail.yahoo.com> <48687c4e-792c-7cdc-7374-3020964f1892@turmel.org> <1152956900.3399623.1469246417006.JavaMail.yahoo@mail.yahoo.com> <b151a240-c3a4-3b59-0ba5-b6ac5776a16d@turmel.org>
Reply-To: Bhatia Amit <amitbhatia@rocketmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b151a240-c3a4-3b59-0ba5-b6ac5776a16d@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids




> This one has a write timestamp of Mon Apr 04 16:02:53 EDT 2016.
> 
> So more than half of this volume is old data, possibly part of an empty
> default setup.  The latter part of the disk, but less than half, is more
> recent data.
> 
> I don't have anything more to suggest.  I don't know of any way to get
> just the good data, however much, at the end of the volume without the
> first half of the disk.


Hi Phil


Just to clarify, I am ok getting *all* data out of disk, whether old or new. My key issue is that while r-linux showed me files that it could recover, it did not show me any folder information. So, if getting folder information out requires getting all data out, I am fine with it. What is the way to get this information out for all data? Maybe I am missing something, but is getting data (old/new) out from disk too difficult ?

In an earlier email, you had suggested possibly running fsck on sdc4 partition. Is that something I should be considering?

Thanks,
Amit
