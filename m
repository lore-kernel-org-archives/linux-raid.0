From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: Md cache?
Date: Thu, 03 Jun 2004 13:03:45 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <871xkxz6jy.fsf@enki.rimspace.net>
References: <8125762.1086227309322.JavaMail.root@wamui05.slb.atl.earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3 Jun 2004, Brian Pontius wrote:
> Is anyone aware of a way to cause the md devices to use some system
> memory as a write cache? (maybe through mdadm?). I have looked
> everywhere and cannot seem to find anything about such a feature.

Linux uses system memory to cache writes; adding a second layer of
caching is really quite unlikely to add anything except a second point
of failure, unless your system memory is battery backed...

   Daniel
-- 
Gratitude is one of the least articulate of the emotions, 
especially when it is deep.
        -- Felix Frankfurter

