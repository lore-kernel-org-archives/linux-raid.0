From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Why does one get mismatches?
Date: Fri, 26 Feb 2010 23:21:39 +0100
Message-ID: <20100226222139.GA2936@lazy.lzy>
References: <4B7B0D45.7040801@tmr.com>
 <6db64f7872286165ac1fd3436e9d6476@localhost>
 <20100218100547.7aecdc34@notabene.brown>
 <20100219151809.GB4995@lazy.lzy>
 <20100220090208.06c1130f@notabene.brown>
 <4B853D99.1040902@tmr.com>
 <20100225083748.42f024aa@notabene.brown>
 <4B8833BA.4010503@tmr.com>
 <20100227080938.6540f041@notabene.brown>
 <4B8847FF.8080609@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B8847FF.8080609@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Steven Haigh <netwiz@crc.id.au>, Bryan Mesich <bryan.mesich@ndsu.edu>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> The question is why this happens with raid-1 and doesn't seem to
> with raid-[56]. And I don't see mismatches on my raid-10, although
> I'm pretty sure that neither mmap or O_DIRECT is used on those
> arrays.

I believe Neil mentioned that RAID-5/6 always
makes a copy, while only RAID-1/10 uses the same
page without copying.

I get mismatches on RAID-10, but not on the one
that has LVM on it, only on the one(s) where the
filesystem (ext3) is directly on the RAID volume.

bye,

-- 

piergiorgio
