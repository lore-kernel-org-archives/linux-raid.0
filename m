From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Mon, 21 Mar 2005 14:58:56 -0500
Message-ID: <423F2780.5000601@steeleye.com>
References: <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <423B2F7C.3030907@steeleye.com> <qehtg2-6c1.ln1@news.it.uc3m.es> <423EF12A.4030207@steeleye.com> <20050321185606.GA27541@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050321185606.GA27541@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra wrote:
> On Mon, Mar 21, 2005 at 11:07:06AM -0500, Paul Clements wrote:
> 
>> All I'm saying is that in a split-brain scenario, typical cluster 
>> frameworks will make two (or more) systems active at the same time. This 
> 
> I sincerely hope not.

Perhaps my choice of wording was not the best? I probably should have 
said, "there is no foolproof way to guarantee that two systems are not 
active." Software fails, human beings make mistakes, and surely even 
STONITH devices can be misconfigured or can fail (or cannot be used for 
one reason or another).

At any rate, this is all irrelevant given the second part of that email 
reply that I gave. You still have to do the bitmap combining, regardless 
of whether two systems were active at the same time or not.

--
Paul
