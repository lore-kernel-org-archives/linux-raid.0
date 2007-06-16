From: "Dan Merillat" <dan.merillat@gmail.com>
Subject: Re: limits on raid
Date: Sat, 16 Jun 2007 00:40:17 -0400
Message-ID: <a56dfcf00706152140s36d01ff6sb9a6bb716b8afe65@mail.gmail.com>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
	 <18034.479.256870.600360@notabene.brown>
	 <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
	 <18034.3676.477575.490448@notabene.brown>
	 <20070616020320.GB2002@animx.eu.org>
	 <18035.23867.576212.859440@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18035.23867.576212.859440@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Wakko Warner <wakko@animx.eu.org>, david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> For raid5 on an array with more than 3 drive, if you attempt to write
> a single block, it will:
>
>  - read the current value of the block, and the parity block.
>  - "subtract" the old value of the block from the parity, and "add"
>    the new value.
>  - write out the new data and the new parity.
>
> If the parity was wrong before, it will still be wrong.  If you then
> lose a drive, you lose your data.

Wow, that really needs to be put somewhere in 120 point red blinking
text.  A lot of us are used to uninitialized disks calculating the
parity-on-first-write, but if linux MD is forgoeing that
'dangerous-no-resync' sounds really REALLY bad.  How about at least a
'Warning: unlike other systems this WILL cause corruption if you
forego reconstruction' on mkraid?
