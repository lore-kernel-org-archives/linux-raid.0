From: Andargor The Wise <andargor@yahoo.com>
Subject: Re: SATA performace
Date: Tue, 3 Jan 2006 00:36:37 -0800 (PST)
Message-ID: <20060103083637.87333.qmail@web54614.mail.yahoo.com>
References: <000d01c61017$ea630d10$3224050a@avilespaxp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000d01c61017$ea630d10$3224050a@avilespaxp>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Aviles <paul.aviles@palei.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- Paul Aviles <paul.aviles@palei.com> wrote:

> Are SATA drives similar in performance than IDE
> drives? I have tested 
> Barracudas 7200.0 (500Gb) and WD too on the same
> type of servers (more than 
> 1 unit) and what I am getting is painfully slow in
> terms of read/writes. 
> Anyone out there with similar experience or this is
> just my isolated 
> results?
> 
> Thanks
> 
> Paul Aviles 
> 

Don't know about IDE, but I did some SATA tests on
RAID-5, if it can give you an indication:

http://www.andargor.com/raid5.html

BTW, EVMS will cut your performance about 50% (the
tests were run with straight MD, no EVMS). I don't
know about LVM, but that might add some overhead as
well...

Andargor



	
		
__________________________________ 
Yahoo! for Good - Make a difference this year. 
http://brand.yahoo.com/cybergivingweek2005/
