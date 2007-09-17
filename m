From: Jordan Russell <jr-list-2007@quo.to>
Subject: Re: MD RAID1 performance very different from non-RAID partition
Date: Mon, 17 Sep 2007 10:58:11 -0500
Message-ID: <46EEA413.8090706@quo.to>
References: <46EB6D67.1000802@quo.to>	<20070915070914.GA21515@teal.hq.k1024.org> <46EC2043.5010006@quo.to> <878x765kmy.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <878x765kmy.fsf@informatik.uni-tuebingen.de>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
> Jordan Russell <jr-list-2007@quo.to> writes:
>> It's an ext3 partition, so I guess that doesn't apply?
>>
>> I tried remounting /dev/sda2 with the "barrier=0" option (which I assume
>> disables barriers, looking at the source), though, just to see if it
>> would make any difference, but it didn't; the database build still took
>> 31 minutes.
> 
> Compare the read ahead settings.

I'm not sure what you mean. There's a per-mount read ahead setting?

-- 
Jordan Russell
