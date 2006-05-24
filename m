From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: 4 disks in raid 5: 33MB/s read performance?
Date: Wed, 24 May 2006 16:11:15 -0400
Message-ID: <4474BDE3.7030905@tmr.com>
References: <Pine.LNX.4.44.0605221231560.20391-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0605221231560.20391-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: Dexter Filmore <Dexter.Filmore@gmx.de>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Mark Hahn wrote:

>>I just dd'ed a 700MB iso to /dev/null, dd returned 33MB/s.
>>Isn't that a little slow?
>>    
>>
>
>what bs parameter did you give to dd?  it should be at least 3*chunk
>(probably 3*64k if you used defaults.)
>

I would expect readahead to make this unproductive. Mind you, I didn't 
say it is, but I can't see why not. There was a problem with data going 
through stripe cache when it didn't need to, but I thought that was fixed.

Neil? Am I an optimist?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

