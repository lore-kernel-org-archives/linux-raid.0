From: David Greaves <david@dgreaves.com>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
 crashing repeatedly and hard)
Date: Tue, 04 Jan 2005 14:43:09 +0000
Message-ID: <41DAAB7D.2030400@dgreaves.com>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <l1nna2-e9i.ln1@news.it.uc3m.es> <200501031846.42950.maarten@ultratux.net> <200501032052.21459.maarten@ultratux.net> <a9noa2-o12.ln1@news.it.uc3m.es> <fh0pa2-kvp.ln1@news.it.uc3m.es> <16857.55609.534526.297577@cse.unsw.edu.au> <jh4pa2-pi.ln1@news.it.uc3m.es> <16857.64086.362458.177296@cse.unsw.edu.au> <ms4qa2-0qa.ln1@news.it.uc3m.es> <41DAA243.3060202@dgreaves.com> <qikqa2-4m2.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <qikqa2-4m2.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter,

Can I make a serious attempt to sum up your argument as:

Disks suffer from random *detectable* corruption events on (or after) 
write (eg media or transient cache being hit by a cosmic ray, cpu 
fluctuations during write, e/m or thermal variations).

Disks suffer from random *undetectable* corruption events on (or after) 
write (eg media or transient cache being hit by a cosmic ray, cpu 
fluctuations during write, e/m or thermal variations)

Raid disks have more 'corruption-susceptible' data capacity per useable 
data capacity and so the probability of a corruption event is higher. 
Since a detectable error is detected it can be retried and dealt with.

This leaves the fact that essentially, raid disks are less reliable than 
non-raid disks wrt undetectable corruption events.

However, we need to carry out risk analysis to decide if the increase in 
susceptibility to certain kinds of corruption (cosmic rays) is 
acceptable given the reduction in susceptibility to other kinds (bearing 
or head failure).

David

tentative definitions:
detectable = noticed by normal OS I/O. ie CRC sector failure etc
undetectable = noticed by special analysis (fsck, md5sum verification etc)


