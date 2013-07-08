From: Milan Broz <gmazyland@gmail.com>
Subject: Re: some general questions on RAID
Date: Mon, 08 Jul 2013 07:25:53 +0200
Message-ID: <51DA4D61.2090708@gmail.com>
References: <1372962602.8716.56.camel@heisenberg.scientia.net> <51D5F22C.70007@turmel.org> <51D9A7CF.6000700@gmail.com> <20130708145316.4486d0dc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130708145316.4486d0dc@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Phil Turmel <philip@turmel.org>, Christoph Anton Mitterer <calestyo@scientia.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/08/2013 06:53 AM, NeilBrown wrote:
> On Sun, 07 Jul 2013 19:39:27 +0200 Milan Broz <gmazyland@gmail.com> wrote:
> 
> 
>> So if you have multiple IOs submitted in parallel from *different* CPUs,
>> they are processed in parallel.
>>
>> If you have MD over dmcrypt, this can cause problem that MD sumbits all IOs
>> with the same cpu context and dmcrypt cannot run it in parallel.
> 
> For RAID1 and RAID10 this isn't true any more.
> 
> Commit f54a9d0e59c4bea3db733921ca9147612a6f292c
> in 3.6 changed this for RAID1 and a similar commit did for RAID10.
> RAID4/5/6 still submit from a single thread as you say.

Ah, sorry, missed that change, thanks Neil!

So then it should perform much better.
(But IIRC most reports about dmcrypt performance was either over
high-speed SSD without AES-NI or over RAID5 - case like huge ftp archive
where they need redundancy & offline data security.
But here current design should be help...)

Milan

