From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Tue, 4 Jan 2005 15:07:54 +0100
Message-ID: <qikqa2-4m2.ln1@news.it.uc3m.es>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <l1nna2-e9i.ln1@news.it.uc3m.es> <200501031846.42950.maarten@ultratux.net> <200501032052.21459.maarten@ultratux.net> <a9noa2-o12.ln1@news.it.uc3m.es> <fh0pa2-kvp.ln1@news.it.uc3m.es> <16857.55609.534526.297577@cse.unsw.edu.au> <jh4pa2-pi.ln1@news.it.uc3m.es> <16857.64086.362458.177296@cse.unsw.edu.au> <ms4qa2-0qa.ln1@news.it.uc3m.es> <41DAA243.3060202@dgreaves.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves <david@dgreaves.com> wrote:
> Peter T. Breuer wrote:
> 
> >Then I guess you have helped clarify to yourself what type of errors
> >falls in which class! Apparently errors caused by drive failure fall in
> >the class of "indetectible error" for you!
> >
> >But in any case, you are wrong, because it is quite possible for an
> >error to spontaneously arise on a disk which WOULD be detected by fsck.
> >What does fsck detect normally if it is not that! 
> >
> It checks the filesystem metadata - not the data held in the filesystem.

So you should deduce that your test (if fsck be it) won't detect errors
in the files data, but only errors in the filesystem metadata.

So? Is there some problem here?

(yes, and one could add a md5sum per block to a fs, but I don't know a
fs that does).

Peter

