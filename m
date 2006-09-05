From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: checking md device parity (forced resync) - is it necessary?
Date: Tue, 05 Sep 2006 14:00:03 +0200
Message-ID: <44FD66C3.6040609@wpkg.org>
References: <44FD3C65.8040000@wpkg.org> <17661.19907.140798.943518@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17661.19907.140798.943518@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:

(...)

>> Which starts a resync of drives. As one can imagine, resync of 800 GB on 
>> a rather slow device (600 MHz ARM) can take 12 hours or so...
>>
> 
> I believe that was intended to be once a month, not once a day.
> Slight error in crontab.
> 
>> So my question is: is this "daily forced resync" necessary?
> 
> Daily is probably excessive, certainly on an array that size.
> 
> Monthly is good.  Weekly might be justified on cheap (i.e. unreliable)
> drives and very critical data.
> 
> With RAID, sleeping bad blocks can be bad.  If you hit one while
> recovering a failed drive, you have to put the piece back together by
> hand.
> A regular check can wake up those sleeping bad blocks.

Thanks a lot for clarification.


>> When can one need to run a "daily forced resync", and in which 
>> circumstances?
> 
> As I said, I think the 'daily' is an error.  What exactly do you have
> in crontab??

Indeed, the crontab entry is wrong:

# by default, run at 01:06 on the first Sunday of each month.
6 1 1-7 * 7 root [ -x /usr/share/mdadm/checkarray ] && 
/usr/share/mdadm/checkarray --cron --all --quiet


However, it will run at 01:06, on 1st-7th day of each month, and on 
Sundays (Debian etch).


-- 
Tomasz Chmielewski
http://wpkg.org
