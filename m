From: David Greaves <david@dgreaves.com>
Subject: Re: limits on raid
Date: Sat, 16 Jun 2007 14:38:36 +0100
Message-ID: <4673E7DC.80508@dgreaves.com>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm> <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org> <18035.23867.576212.859440@notabene.brown> <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm>
Sender: linux-raid-owner@vger.kernel.org
To: david@lang.hm
Cc: Neil Brown <neilb@suse.de>, Wakko Warner <wakko@animx.eu.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

david@lang.hm wrote:
> On Sat, 16 Jun 2007, Neil Brown wrote:
> 
> I want to test several configurations, from a 45 disk raid6 to a 45 disk 
> raid0. at 2-3 days per test (or longer, depending on the tests) this 
> becomes a very slow process.
Are you suggesting the code that is written to enhance data integrity is 
optimised (or even touched) to support this kind of test scenario?
Seriously? :)

> also, when a rebuild is slow enough (and has enough of a performance 
> impact) it's not uncommon to want to operate in degraded mode just long 
> enought oget to a maintinance window and then recreate the array and 
> reload from backup.

so would mdadm --remove the rebuilding disk help?

David

