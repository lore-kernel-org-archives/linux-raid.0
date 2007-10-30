From: David Greaves <david@dgreaves.com>
Subject: Re: Bad drive discovered during raid5 reshape
Date: Tue, 30 Oct 2007 12:35:42 +0000
Message-ID: <4727251E.5030705@dgreaves.com>
References: <47258776.9020601@sisna.com>	<18214.53051.652280.492087@notabene.brown>	<472712E5.10806@dgreaves.com> <18215.6378.912706.274201@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18215.6378.912706.274201@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, Kyle Stuart <kstuart@sisna.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday October 30, david@dgreaves.com wrote:
>> The key question I think is: will md continue to grow an array even if it enters
>> degraded mode during the grow?
>> ie grow from a 6 drive array to a 7-of-8 degraded array?
> 
> Yes, md can grow to a degraded array.  If you get a single failure I
> would expect it to abort the growth process, then restart where it
> left off (after checking that that made sense).

I read that he aborted it, then removed both drives before giving md a chance to
restart.

He said:
After several minutes dmesg indicated that mdadm gave up and
the grow process stopped. After googling around I tried the solutions
that seemed most likely to work, including removing the new drives with
mdadm --remove --force /dev/md1 /dev/sd[bc]1 and rebooting

and *then* he: "ran mdadm -Af /dev/md1."

>> In which case should he be able to re-add /dev/sdc and allow md to retry the
>> grow? (possibly losing some data due to the sdc staleness)
> 
> He only needs one of the two drives in there.  I got the impression
> that both sdc and sdb had reported errors.  If not, and sdc really
> seems OK, then "--assemble --force" listing all drives except sdb
> should make it all work again.

Kyle - I think you need to clarify this as it may not be too bad. Apologies if I
misread something and sdc is bad too :)

It may be an idea to let us (Neil) know what you've done and if you've done any
writes to any devices before trying this assemble.

David

