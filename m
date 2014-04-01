From: Yorik <yoriks13@westnet.com.au>
Subject: Re: RAIS5 Rebuild Help - Possible Data Offset
Date: Tue, 1 Apr 2014 11:49:01 +0800
Message-ID: <CAFth78ybasJD9D+L3_r0zrmrD4Le8oFgXjqAS-sN0ai6C8LKjQ@mail.gmail.com>
References: <CAFth78x1SkCEUmETFt+F+79UpjUbhanNLUbZoWa7Hxi3EzsdMw@mail.gmail.com>
	<20140131102551.GA2425@cthulhu.home.robinhill.me.uk>
	<CAFth78xfsaBLzg9TC=UkEoQiafpg-oVJyoxbYgWyrVHCyAuHew@mail.gmail.com>
	<20140331172953.3f37f6c2@notabene.brown>
	<CAFth78wtf5X0ycUuKCTV3QSvs4Uv8mvvZYH2Vqhwc2WwOqkHfg@mail.gmail.com>
	<20140331181227.69c4e583@notabene.brown>
	<CAFth78xfP7rEVJxWS=aL0zUPGSyDnmrPWcgE=XxjYSuWU4_zvQ@mail.gmail.com>
	<20140331193704.609a7f1f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140331193704.609a7f1f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil

Thanks very much for your help and pointers. This is what I was
thinking a while ago when I was looking at this. Suffered a few very
quick failures in quick succession and probably got too trigger happy
on my rebuilding in between.
I will look deeper and report back if I come up with anything useful.

Thanks again.

Cheers
Derek

On 31 March 2014 16:37, NeilBrown <neilb@suse.de> wrote:
> On Mon, 31 Mar 2014 15:24:07 +0800 Yorik <yoriks13@westnet.com.au> wrote:
>
>> Hi Neil
>>
>> Thanks for your quick reply. :) Output as follows. and yes I agree.
>> sdf is strange, also some devices think the Array has different number
>> of devices Active.. It all got quite muddled up at the time of
>> failure.
>
> So.....
> sdf thinks
>    Raid Devices : 6
> others think
>    Raid Devices : 8
>
> So that's not going to work.
> However if we just ignore sdf, then sdg and sdi thinkg
>
>      Array UUID : a5cb0ced:fee37e80:bb291f1a:c5b2f600
>
> while the rest think:
>
>      Array UUID : e32ad2c6:5f99dd8f:2572c3a8:c485db00
>
> So you have at most 5 device which think they are the same array,
> which isn't enough for an 8-device RAID6.
>
> It looks like you have tried to --create the array several times,
> at
>
>   Creation Time : Tue Feb  4 00:28:54 2014
>   Creation Time : Tue Feb  4 00:33:56 2014
>   Creation Time : Tue Feb  4 00:38:19 2014
>
> to be precise.
>
> Your only real chance is to find out the real geometry of the
> array before all the problem happened, and create it properly...
> It might be worth checking sda sdb and sdc (with out partitions)
> as well as sdd1 sde1 sdf1 sdg1 sdi1 to see if there is anything there.
>
> But if you have backups or some other way to regenerate the data ......
>
> NeilBrown
