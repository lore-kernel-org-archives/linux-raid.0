From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Tue, 22 Mar 2005 11:02:16 +0100
Message-ID: <8275h2-sn4.ln1@news.it.uc3m.es>
References: <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <423B2F7C.3030907@steeleye.com> <qehtg2-6c1.ln1@news.it.uc3m.es> <423EF12A.4030207@steeleye.com> <20050321185606.GA27541@percy.comedia.it> <423F2780.5000601@steeleye.com> <20050322093525.GL7040@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra <bluca@comedia.it> wrote:
> If we want to do data-replication, access to the data-replicated device
> should be controlled by the data replication process (*), md does not
> guarantee this.

Well, if one writes to the md device, then md does guarantee this - but
I find it hard to parse the statement. Can you elaborate a little in
order to reduce my possible confusion?


> (*) i.e. my requirements could be that having a replicated transaction
> is more important that completing the transaction itself, so i might
> want to return a disk error in case replica fails.

Oh - I see. "We did half off all the replications possible". That's an
interesting idea and it is trivial to modify md to return error if not
all the replications succeeded. The bitmap knows right now. No reason
not to call end_io(...,0) instead of end_io(...,1) if you want it that
way.

> or to the contrary i might want data availability above all else, maybe
> data does not change much.
> or something in between, data availability above replication, but
> data validity over availability. this is probably the most common
> scenario, and the more difficult to implement correctly.
> 
> In any case it must be possible to control exactly which steps should be
> automatically done in case of failure. and in case of rollback, with the
> sane default would be "die rather than modify any data, in case of
> doubt".

Well, if you want to be more exact about it, I am sure your wishes can
be accomodated. It's not a bad idea to be able to tailor the policy.

Peter

