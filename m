From: Jordan Russell <jr-list-2007@quo.to>
Subject: Re: MD RAID1 performance very different from non-RAID partition
Date: Wed, 19 Sep 2007 00:28:47 -0500
Message-ID: <46F0B38F.8070901@quo.to>
References: <46EB6D67.1000802@quo.to> <20070915070914.GA21515@teal.hq.k1024.org> <46EC2043.5010006@quo.to> <878x765kmy.fsf@informatik.uni-tuebingen.de> <46EEA413.8090706@quo.to> <20070918134438.GA1522@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070918134438.GA1522@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra wrote:
> On Mon, Sep 17, 2007 at 10:58:11AM -0500, Jordan Russell wrote:
>> Goswin von Brederlow wrote:
>>> Compare the read ahead settings.
>> I'm not sure what you mean. There's a per-mount read ahead setting?
>>
> 
> per device
> 
> compare
> blockdev --getra /dev/sda2
> and 
> blockdev --getra /dev/md0

Ah.

256 on /dev/sda2 with md0 stopped
256 on /dev/sda2 with md0 active
256 on /dev/md0 with md0 active

-- 
Jordan Russell
