From: Luca Berra <bluca@comedia.it>
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Tue, 22 Mar 2005 10:35:25 +0100
Message-ID: <20050322093525.GL7040@percy.comedia.it>
References: <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <423B2F7C.3030907@steeleye.com> <qehtg2-6c1.ln1@news.it.uc3m.es> <423EF12A.4030207@steeleye.com> <20050321185606.GA27541@percy.comedia.it> <423F2780.5000601@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <423F2780.5000601@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 21, 2005 at 02:58:56PM -0500, Paul Clements wrote:
>Luca Berra wrote:
>>On Mon, Mar 21, 2005 at 11:07:06AM -0500, Paul Clements wrote:
>>
>>>All I'm saying is that in a split-brain scenario, typical cluster 
>>>frameworks will make two (or more) systems active at the same time. This 
>>
>>I sincerely hope not.
>
>Perhaps my choice of wording was not the best? I probably should have 
>said, "there is no foolproof way to guarantee that two systems are not 
>active." Software fails, human beings make mistakes, and surely even 
>STONITH devices can be misconfigured or can fail (or cannot be used for 
>one reason or another).
well, careful use of an arbitrator node, possibly in a different
location, helps avoiding split-brains, and stonith is a requirement

>At any rate, this is all irrelevant given the second part of that email 
>reply that I gave. You still have to do the bitmap combining, regardless 
>of whether two systems were active at the same time or not.

I still maintain that doing data-replication with md over nbd is a
painful and not very useful exercise.
If we want to do data-replication, access to the data-replicated device
should be controlled by the data replication process (*), md does not
guarantee this.
(*) i.e. my requirements could be that having a replicated transaction
is more important that completing the transaction itself, so i might
want to return a disk error in case replica fails.
or to the contrary i might want data availability above all else, maybe
data does not change much.
or something in between, data availability above replication, but
data validity over availability. this is probably the most common
scenario, and the more difficult to implement correctly.

In any case it must be possible to control exactly which steps should be
automatically done in case of failure. and in case of rollback, with the
sane default would be "die rather than modify any data, in case of
doubt".

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
