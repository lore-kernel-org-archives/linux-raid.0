From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 10:00:20 +0100
Message-ID: <4umsa2-c9q.ln1@news.it.uc3m.es>
References: <l1nna2-e9i.ln1@news.it.uc3m.es> <20050104024108.GK99565@caffreys.strugglers.net> <895qa2-0qa.ln1@news.it.uc3m.es> <200501042002.32292.maarten@ultratux.net> <j6dra2-9vs.ln1@news.it.uc3m.es> <41DB127F.3090303@wasp.net.au> <qukra2-s1j.ln1@news.it.uc3m.es> <41DB7EB7.4090404@wasp.net.au>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brad Campbell <brad@wasp.net.au> wrote:
> If a bit has flipped on a parity stripe and thus the parity is inconsistent. When I pop out a disk 
> and put it back in, the array is going to be written from parity data that is not quite right. (The 
> problem I believe you were talking about where you have two identical disks and one is inconsistent, 
> which one do you read from? is similar). And thus the reconstructed array is going to have different 
> contents to the array before I failed the disk.
> 
> Therefore it should show the error. No?

It will not detect it as an error, if that is what you mean.

Peter

