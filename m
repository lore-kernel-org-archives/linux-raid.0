From: Norman Schmidt <schmidt@naa.net>
Subject: Re: libata badness
Date: Tue, 05 Oct 2004 07:27:28 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <416230C0.3060509@naa.net>
References: <Pine.LNX.4.60-041.0410040656001.2350@unix48.andrew.cmu.edu> <16737.54003.419130.575839@cse.unsw.edu.au> <Pine.LNX.4.60-041.0410042301510.22333@unix47.andrew.cmu.edu> <416227E1.8020306@wasp.net.au>
Reply-To: schmidt@naa.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <416227E1.8020306@wasp.net.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brad Campbell schrieb:

> For future reference, I have had errors show up after 24-36 hours of 
> memtest86. I usually find that if it passes 48 hours of testing then 
> things are looking pretty reliable. A couple of hours is usually too 
> small a sample to rely on.
> 
> Brad

I can confirm that finding. What I usually do in addition to that is to
start enough burnmmx/burnp6 processes to make the system swap, run
bonnie at the same time ant let the machine chew on this for two days.
Ich none of the processes stops, it can go into production.

However, I now had problems with a faulty power supply (capacitors) the
second time - symptoms was erratic behaviour, the software raid fell
apart quite often (because some of the disks sometimes went down) and so
on. One learns all the time.

Bye Norman.

-- 
Norman Schmidt          Institut fuer Physikal. u. Theoret. Chemie
Dipl.-Chem. Univ.       Friedrich-Alexander-Universitaet
schmidt@naa.net         Erlangen-Nuernberg
                         IT-Systembetreuer Physikalische Chemie


