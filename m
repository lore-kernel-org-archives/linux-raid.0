From: Luca Berra <bluca@comedia.it>
Subject: Re: MD RAID1 performance very different from non-RAID partition
Date: Tue, 18 Sep 2007 15:44:38 +0200
Message-ID: <20070918134438.GA1522@percy.comedia.it>
References: <46EB6D67.1000802@quo.to> <20070915070914.GA21515@teal.hq.k1024.org> <46EC2043.5010006@quo.to> <878x765kmy.fsf@informatik.uni-tuebingen.de> <46EEA413.8090706@quo.to>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <46EEA413.8090706@quo.to>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Sep 17, 2007 at 10:58:11AM -0500, Jordan Russell wrote:
>Goswin von Brederlow wrote:
>> Jordan Russell <jr-list-2007@quo.to> writes:
>>> It's an ext3 partition, so I guess that doesn't apply?
>>>
>>> I tried remounting /dev/sda2 with the "barrier=0" option (which I assume
>>> disables barriers, looking at the source), though, just to see if it
>>> would make any difference, but it didn't; the database build still took
>>> 31 minutes.
>> 
>> Compare the read ahead settings.
>
>I'm not sure what you mean. There's a per-mount read ahead setting?
>

per device

compare
blockdev --getra /dev/sda2
and 
blockdev --getra /dev/md0

L.
-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
