From: Andras Korn <korn@raidlist.elan.rulez.org>
Subject: Re: write-behind has no measurable effect?
Date: Wed, 16 Feb 2011 13:00:56 +0100
Message-ID: <20110216120056.GD13135@hellgate.intra.guy>
References: <20110214213817.GG836@hellgate.intra.guy>
 <20110215095042.51ef7e0a@notabene.brown>
 <20110214225754.GK19990@hellgate.intra.guy>
 <20110215104109.06b12b33@notabene.brown>
 <20110215010052.GA13135@hellgate.intra.guy>
 <4D59D4A5.9050106@anonymous.org.uk>
 <20110215021900.GB13135@hellgate.intra.guy>
 <AANLkTikFSOePZJXknAt=Tx6+FpdJ4tiSNwpuwuPC3RY=@mail.gmail.com>
 <AANLkTinAV4jJc8ueZ1mjRPpDnA_eWhUDcL8uz-0Ufifk@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinAV4jJc8ueZ1mjRPpDnA_eWhUDcL8uz-0Ufifk@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 15, 2011 at 06:10:17AM -0300, Roberto Spadim wrote:

> andras could you make some benchmarks to raid1 with round robin read balance?
> at this site:
> www.spadim.com.br/raid1/

For the record: we did some benchmarks and while the patch shows promise and
seems to cause no problems, it resulted in no measurable performance
increase for a RAID1 array composed of an SSD and two 7200rpm HDDs.

Andras

-- 
                     Andras Korn <korn at elan.rulez.org>
                 If it ain't broken, play with it until it is.
