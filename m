From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: SATA performace
Date: Tue, 03 Jan 2006 10:50:42 -0800
Message-ID: <1136314242.10745.4.camel@seki.nac.uci.edu>
References: <20060103083637.87333.qmail@web54614.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060103083637.87333.qmail@web54614.mail.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andargor The Wise <andargor@yahoo.com>
Cc: Paul Aviles <paul.aviles@palei.com>, linux-raid@vger.kernel.org, strombrg@dcs.nac.uci.edu
List-Id: linux-raid.ids


Supposedly current versions of EVMS and LVM sit overtop of the same
"device mapper" kernel component...  Given this, I have to wonder if the
situation hasn't changed since last evaluated.

On Tue, 2006-01-03 at 00:36 -0800, Andargor The Wise wrote:
> --- Paul Aviles <paul.aviles@palei.com> wrote:
> 
> > Are SATA drives similar in performance than IDE
> > drives? I have tested 
> > Barracudas 7200.0 (500Gb) and WD too on the same
> > type of servers (more than 
> > 1 unit) and what I am getting is painfully slow in
> > terms of read/writes. 
> > Anyone out there with similar experience or this is
> > just my isolated 
> > results?
> > 
> > Thanks
> > 
> > Paul Aviles 
> > 
> 
> Don't know about IDE, but I did some SATA tests on
> RAID-5, if it can give you an indication:
> 
> http://www.andargor.com/raid5.html
> 
> BTW, EVMS will cut your performance about 50% (the
> tests were run with straight MD, no EVMS). I don't
> know about LVM, but that might add some overhead as
> well...
> 
> Andargor
> 
> 
> 
> 	
> 		
> __________________________________ 
> Yahoo! for Good - Make a difference this year. 
> http://brand.yahoo.com/cybergivingweek2005/
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

