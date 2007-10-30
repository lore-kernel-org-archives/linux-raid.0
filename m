From: Neil Brown <neilb@suse.de>
Subject: Re: Bad drive discovered during raid5 reshape
Date: Tue, 30 Oct 2007 22:43:38 +1100
Message-ID: <18215.6378.912706.274201@notabene.brown>
References: <47258776.9020601@sisna.com>
	<18214.53051.652280.492087@notabene.brown>
	<472712E5.10806@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from David Greaves on Tuesday October 30
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Kyle Stuart <kstuart@sisna.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday October 30, david@dgreaves.com wrote:
> Neil Brown wrote:
> > On Monday October 29, kstuart@sisna.com wrote:
> >> Hi,
> >> I bought two new hard drives to expand my raid array today and
> >> unfortunately one of them appears to be bad. The problem didn't arise
> 
> > Looks like you are in real trouble.  Both the drives seem bad in some
> > way.  If it was just sdc that was failing it would have picked up
> > after the "-Af", but when it tried, sdb gave errors.
> 
> Humble enquiry.... :)
> 
> I'm not sure that's right?
> He *removed* sdb and sdc when the failure occurred so sdc would indeed be non-fresh.

I'm not sure what point you are making here.
In any case, remove two drives from a raid5 is always a bad thing.
Part of the array was striped over 8 drives by this time.  With only
six still in the array, some data will be missing.

> 
> The key question I think is: will md continue to grow an array even if it enters
> degraded mode during the grow?
> ie grow from a 6 drive array to a 7-of-8 degraded array?
> 
> Technically I guess it should be able to.

Yes, md can grow to a degraded array.  If you get a single failure I
would expect it to abort the growth process, then restart where it
left off (after checking that that made sense).

> 
> In which case should he be able to re-add /dev/sdc and allow md to retry the
> grow? (possibly losing some data due to the sdc staleness)

He only needs one of the two drives in there.  I got the impression
that both sdc and sdb had reported errors.  If not, and sdc really
seems OK, then "--assemble --force" listing all drives except sdb
should make it all work again.

NeilBrown
