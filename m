From: Asdo <asdo@shiftmail.org>
Subject: Re: Disappointing RAID10 Performance
Date: Sat, 17 Oct 2009 18:12:20 +0200
Message-ID: <4AD9ECE4.3090202@shiftmail.org>
References: <364346.70897.qm@web38808.mail.mud.yahoo.com>
 <4AD8BBC3.4030600@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4AD8BBC3.4030600@wpkg.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Tomasz Chmielewski wrote:
> If you start using your drives for two "dd if=bigfile[12] 
> of=/dev/null" at the same time, you will notice the difference.

OT: Does this dd line really work? I did see it elsewhere already but 
doesn't appear to work for me: seems to see only the last if=. I don't 
think multiple input or output files are supported.
For this kind of tests I was doing a for loop with background dd comands 
( trailing & ) IIRC
This would be a good dd feature to simplify linux-raid performance 
testing though.
