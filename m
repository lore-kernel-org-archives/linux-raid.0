From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: Is (non-failed) disk replace possible without loosing
 redundancy ?
Date: Fri, 12 Apr 2013 08:10:50 -0700
Message-ID: <qokl3axtjn.ln2@goaway.wombat.san-francisco.ca.us>
References: <F5FBA8C0111F5C458B9E1BC24A3F4BDD01F43AAFA5@exchange2.ad.tlogica.com>
 <5166D3C5.5000407@websitemanagers.com.au>
 <runj3axnnb.ln2@goaway.wombat.san-francisco.ca.us>
 <20130412160124.3439ad7d@natsu> <20130412202130.631011d7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2013-04-12, NeilBrown <neilb@suse.de> wrote:
>
> On Fri, 12 Apr 2013 16:01:24 +0600 Roman Mamedov <rm@romanrm.ru> wrote:
>
>> On Thu, 11 Apr 2013 14:52:59 -0700
>> Keith Keller <kkeller@wombat.san-francisco.ca.us> wrote:
>> > Is there any way to accomplish the same sort of
>> > thing in a RAID5 or 6?
>> There is the "want_replacement" mechanism. It exists, it works perfectly,=
>  but
>> from this thread it looks like no one knows about it. Actually I am not s=
> ure
>> where it is documented, try searching the mail list archives.

Actually, I had seen want_replacement before, but had only skimmed
messages about it.  I apologize for not realizing what it was--I should
have remembered that feature and followed up on it first.

> Checkout the devel mdadm from git://neil.brown.name/mdadm/
>
>  make man
>  less mdadm.man
>
> and search for "--replace"
>
> Requires linux-3.3 or later.

This is probably one reason why want_replacement didn't stick in my
head; I'm not quite ready for 3.3.  But perhaps this will encourage me
to try to move up more quickly.

Thanks all!

--keith

-- 
kkeller@wombat.san-francisco.ca.us


