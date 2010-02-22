From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Why does one get mismatches?
Date: Mon, 22 Feb 2010 14:44:22 +0100
Message-ID: <20100222134422.GA3559@lazy.lzy>
References: <20100218100547.7aecdc34@notabene.brown>
 <20100219151809.GB4995@lazy.lzy>
 <20100220090208.06c1130f@notabene.brown>
 <4B7F2013.4070905@shiftmail.org>
 <87k4u8zg3t.fsf@frosties.localdomain>
 <4B7FC3A7.10104@shiftmail.org>
 <87iq9qu9j5.fsf@frosties.localdomain>
 <8754A21825504719B463AD9809E54349@m5>
 <20100221194400.GA2570@lazy.lzy>
 <4B828029.3020604@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B828029.3020604@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Guy Watkins <linux-raid@watkins-home.com>, 'Goswin von Brederlow' <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again,

forgot one thing...

I've some PCs where those mismatches shows up, sometimes
more, sometime less, sometimes nothing.

All these PCs have the filesystem (ext3) directly on
the RAID drive.

I've one more PC, where there is a LVM layer inbetween.

In this PC, which has also different HW (the others are
all identical), I never saw mismatches.
I can imagine the LVM takes care of handling properly
the memory buffers.

Can anyone confirm this?

Thanks,

bye,

-- 

piergiorgio
