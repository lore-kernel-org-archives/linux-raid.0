From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Why does one get mismatches?
Date: Fri, 26 Feb 2010 23:01:23 +0100
Message-ID: <20100226220123.GA2843@lazy.lzy>
References: <20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu>
 <4B7B0D45.7040801@tmr.com>
 <6db64f7872286165ac1fd3436e9d6476@localhost>
 <20100218100547.7aecdc34@notabene.brown>
 <20100219151809.GB4995@lazy.lzy>
 <20100220090208.06c1130f@notabene.brown>
 <4B853D99.1040902@tmr.com>
 <20100225083748.42f024aa@notabene.brown>
 <4B8833BA.4010503@tmr.com>
 <20100227080938.6540f041@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100227080938.6540f041@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Bill Davidsen <davidsen@tmr.com>, Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Steven Haigh <netwiz@crc.id.au>, Bryan Mesich <bryan.mesich@ndsu.edu>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> So I think that the only way to address this in the md layer is to copy
> the data and write the copy.  There is already code to copy the data for
> write-behind that could possible be leveraged to do a copy always.

actually, I wanted to ask how the write-behind works,
because I was suspecting it copies the data.

BTW, it is possible to set both drives (of a pair) as
write-mostly and some write-behind?

> Or I could just stop setting mismatch_cnt for raid1 and raid10.  That would
> also fix the problem :-)

Well, the "complaining" problem will be fixed... :-)

bye,

-- 

piergiorgio
