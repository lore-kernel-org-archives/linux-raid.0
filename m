From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 19:16:26 +0100
Message-ID: <qgnta2-mqm.ln1@news.it.uc3m.es>
References: <200501051707.j05H7m926213@www.watkins-home.com> <41DC234B.4090806@dgreaves.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves <david@dgreaves.com> wrote:
> Haven't you seen the special 'make_undetectable_error(float p)' function?

 dd if=/dev/urandom of=/dev/hda1 bs=512 count=1 skip=$RANDOM

Peter

