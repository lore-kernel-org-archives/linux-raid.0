From: =?UTF-8?Q?Patrik_Dahlstr=C3=B6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Mon, 24 Apr 2017 14:13:24 +0200
Message-ID: <CAHKno4A12N6UGGtJQJRkY0aPbFBBf0Rek91th9Cnx6XWJGouWg@mail.gmail.com>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <807de641-043c-41a0-cffe-e28710503aba@fnarfbargle.com> <20170423144835.GB12093@metamorpher.de>
 <f353b7fc-a63a-5503-5cda-6a62698f69ae@powerlamerz.org> <20170423154240.GA3494@metamorpher.de>
 <718f75d1-b74f-f788-783a-6ffbdff275a8@powerlamerz.org> <63d6d0f5-d9b1-1218-b98e-48f9cf21a8bc@fnarfbargle.com>
 <CAHKno4AZukKvOEkVXPYMtnu1nypXLi95HaiFw+WNhAKP4KoLkg@mail.gmail.com> <20170424110455.GA4949@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170424110455.GA4949@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2017-04-24 13:04 GMT+02:00, Andreas Klauer <Andreas.Klauer@metamorpher.de>:
> On Mon, Apr 24, 2017 at 09:34:04AM +0200, Patrik Dahlstr=C3=B6m wrote:
>> I've let a program compare both raid sets (5 and 6 disk) overnight. So
>> far it has gone from 128 MB to 14 TB without finding common data. Does
>> that tell us anything?
>
> Are both RAID sets created correctly?
>
> On the 6 disk one, `file -s /dev/mdX` should say ext filesystem.
>
> If that's not there it's certainly incorrect. (The reverse isn't true
> though.)
I'm afraid it doesn't say that. I can get the exact command I used
when I get home. I do know that both raids contains only zeros for
many MB before any data appears.

> That's the general outline of the idea.
> The problem in your case is of course, your data is not that easy to
> verify.
My raid contains many large files (8-12 GB each). If I can get
reference data, I should be able to locate where on the disks the file
is split up. Would that help? I imagine file system fragmentation
could become an issue.
>
> ( You can't even easily verify your disk order, offsets, et cetera.
>   These are things you have to figure out by yourself,
>   not sure how else to help you. Best of luck. )
From old kernel log, we know that the disk order was /dev/sd[abdcef],
given that the drives were always discovered in that order. Could the
offsets be verified with data from reference files as discussed above?
>
> Regards
> Andreas Klauer
>
Best regards
Patrik Dahlstr=C3=B6m
