From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: MD software RAID1 vs suspend-to-disk
Date: Mon, 02 Mar 2009 00:42:13 +0000
Message-ID: <49AB2B65.6070102@anonymous.org.uk>
References: <87d4d17hgh.fsf@rimspace.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d4d17hgh.fsf@rimspace.net>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Pittman <daniel@rimspace.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/03/2009 08:52, Daniel Pittman wrote:
> I have a random desktop machine here, running Debian/sid with a 2.6.26
> Debian kernel.  It has a two disk software RAID1, and apparently passes
> through a suspend/resume cycle correctly, but...

I'm not sure if this is the same suspend/resume - there are after all 
several Googleable reasons why one might suspend or resume various 
things - but it might be worth a look at NeilB's recent post of a patch 
to "hopefully enable suspend/resume of md devices": 
http://marc.info/?l=linux-raid&m=123440845819870&w=2

Cheers,

John.

