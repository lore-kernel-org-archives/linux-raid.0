From: Michal Soltys <nozo@ziu.info>
Subject: Re: Backups w/ rsync
Date: Mon, 01 Oct 2007 06:45:09 +0200
Message-ID: <47007B55.1060404@ziu.info>
References: <20070928145718.7320C24769@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070928145718.7320C24769@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Wolfgang Denk wrote:
> Dear Bill,
> 
> in message <46FD1442.70707@tmr.com> you wrote:
>>
>> Be aware that rsync is useful for making a *copy* of your files, which 
>> isn't always the best backup. If the goal is to preserve data and be 
>> able to recover in time of disaster, it's probably not optimal, while if 
>> you need frequent access to old or deleted files it's fine.
> 
> If you want to do real backups you should use real tools, like bacula
> etc.
> 

I wouldn't agree here. All depends on how you organize yuor things, write
scripts, and so on. It isn't any less "real" solution than amanda or bacula.
It's much more DIY solution though, so not everyone will be inclined to use it.

ps.
Sorry for offtopic. Last in this subject from me.

