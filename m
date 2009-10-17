From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Disappointing RAID10 Performance
Date: Sat, 17 Oct 2009 18:20:24 +0200
Message-ID: <4AD9EEC8.9000701@wpkg.org>
References: <364346.70897.qm@web38808.mail.mud.yahoo.com> <4AD8BBC3.4030600@wpkg.org> <4AD9ECE4.3090202@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AD9ECE4.3090202@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Asdo wrote:
> Tomasz Chmielewski wrote:
>> If you start using your drives for two "dd if=bigfile[12] 
>> of=/dev/null" at the same time, you will notice the difference.
> 
> OT: Does this dd line really work? I did see it elsewhere already but 
> doesn't appear to work for me: seems to see only the last if=. 

I don't think it does work.

You see it everywhere because it's faster to write, and everyone gets 
the idea what's this all about.


-- 
Tomasz Chmielewski
http://wpkg.org
