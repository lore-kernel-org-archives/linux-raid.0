From: Brad Campbell <brad@wasp.net.au>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
 crashing repeatedly and hard)
Date: Wed, 05 Jan 2005 13:43:34 +0400
Message-ID: <41DBB6C6.2040301@wasp.net.au>
References: <l1nna2-e9i.ln1@news.it.uc3m.es> <20050104024108.GK99565@caffreys.strugglers.net> <895qa2-0qa.ln1@news.it.uc3m.es> <200501042002.32292.maarten@ultratux.net> <j6dra2-9vs.ln1@news.it.uc3m.es> <41DB127F.3090303@wasp.net.au> <qukra2-s1j.ln1@news.it.uc3m.es> <41DB7EB7.4090404@wasp.net.au> <4umsa2-c9q.ln1@news.it.uc3m.es> <41DBB012.5040308@wasp.net.au> <ljosa2-lg.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ljosa2-lg.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sorry, sent this privately by mistake.

Peter T. Breuer wrote:

> If you do an md5sum on file contents and compare with a previous md5sum
> run, then it will be detected provided that the error occurs in a file,
> but assuming that your disk is 50% full, that is only 50% likely.
> 
> I.e. "it depends on your test".

brad@srv:~$ df -h | grep md0
/dev/md0              2.1T  2.1T  9.2G 100% /raid

I'd say likely :p)

Regards,
Brad

