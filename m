From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Mon, 21 Mar 2005 16:19:37 -0500
Message-ID: <423F3A69.5090502@steeleye.com>
References: <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <423B2F7C.3030907@steeleye.com> <qehtg2-6c1.ln1@news.it.uc3m.es> <423EF12A.4030207@steeleye.com> <20050321185606.GA27541@percy.comedia.it> <423F2780.5000601@steeleye.com> <qbo3h2-kjo.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <qbo3h2-kjo.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer wrote:
> Paul Clements <paul.clements@steeleye.com> wrote:
> 
>>At any rate, this is all irrelevant given the second part of that email 
>>reply that I gave. You still have to do the bitmap combining, regardless 
>>of whether two systems were active at the same time or not.

> But why don't we already know from the _single_ bitmap on the array
> node ("the node with the array") what to rewrite in total? All writes
> must go through the array. We know how many didn't go to both
> components. Thus we know how many to rewrite from the survivor to the
> component that we lost contact with.

I don't think we're talking about the same thing. I'm talking about this:

1) you have an array set up on system A:

     system A
     [raid1]
     /     \
[disk]    [nbd] --> system B

2) you're writing, say, block 10 to the raid1 when A crashes (block 10 
is dirty in the bitmap, and you don't know whether it got written to the 
disk on A or B, neither, or both)

3) something (i.e., your cluster framework) notices that A is gone and 
brings up a new raid1, with an empty bitmap, on system B:

     system B
     [raid1]
     /     \
[disk]    missing (eventually will connect back to system A)

4) some things get written to the raid1 on system B (i.e., the bitmap is 
dirty)

5) system A comes back and we now want to get the two systems back in sync

In this scenario, there are two bitmaps that must be consulted in order 
to sync the proper blocks back to system A. Without bitmaps (or the 
ability to combine the bitmaps), you must do a full resync from B to A.

--
Paul


