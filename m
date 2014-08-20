From: Chris Knipe <savage@savage.za.org>
Subject: Re: Correct RAID options
Date: Wed, 20 Aug 2014 05:05:36 +0200
Message-ID: <CA+4TWFtj5nKJrG8XkDYXvDTD-CqUOFtQYiyWE1rbONWzNMSyWw@mail.gmail.com>
References: <027801cfbbdc$d33970f0$79ac52d0$@savage.za.org>
	<53F3EA59.6030808@hesbynett.no>
	<CA+4TWFtG0ofkzQH0-k-rjOakasQNvcNZDgit=KknE6TCaKXpgg@mail.gmail.com>
	<E78FE8BDBAD07C43A60163E7D1716EEC0183A6C7C5@PROSIS-W2K8-1.prosis.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E78FE8BDBAD07C43A60163E7D1716EEC0183A6C7C5@PROSIS-W2K8-1.prosis.local>
Sender: linux-raid-owner@vger.kernel.org
To: Craig Curtin <craigc@prosis.com.au>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Aug 20, 2014 at 4:38 AM, Craig Curtin <craigc@prosis.com.au> wrote:

> I assume that your application will handle it OK if the Archive is offline ? I understand you have throughput issues now, but if you lose the RAID5 setup it is going to take a long time to recover really need to rebuild that as RAID6 ASAP - particularly if it is only under light load now.

Correct.  I will however lose data as I would need to delete old data
off the front end servers instead of archiving it in order not run out
of disk space (which will be catastrophic).  It's not an ideal
situation, but it's not a major loss either at this point in time.  Up
to a day or three ago, we deleted anyways.  So yes, I am more than
likely trashing the archive server and rebuilding it (or not using it
at all and rather expanding on the front end servers - against my
better judgement).


> Now that you have clarified what your servers are and how they are performing - I would suggest another option would be an external SATA storage system - for cost you can not go past the Promise equipment. You could whack additional SATA drives in one of these on your front end servers (they have models with different connection options - ESATA, SAS, FC etc etc) and this would give you more space on the front end as well as more spindles to handle the writing etc - it would also give you the ability to mess around with different file systems etc.

I really don't want to be a PITA, but these are leased servers (sorry
if I haven't been clear). We do not even have physical access to the
servers, frankly, they are half way around the world from where I am
:-)  Hardware changes in any way or form is not going to happen.  The
provider is simply not going to play - we've tried before. We've tried
so badly before that it was easier / quicker to cancel a server and
order a new one, instead of having them fix something.  Yes, it's sad,
but that's what is there and that's unfortunately the way it currently
is.

I really do not need a 'blue sky' here.  I know what I am doing is
-insanely- resource intensive and frankly speaking, I am -amazed- at
how well these front end servers are coping up to now.  There are
limits, and sure we are hitting those limits.  The question really is
what can be done to achieve the best performance with what we have?
RAID10/EXT4 isn't working now that we are reading and writing
extensively at the same time - it was more than likely a bad /
uneducated / inexperienced choice.  I understand that, I accept that.

Will XFS give any amount of reasonable increases in performance to
justify a format / reinstall (let's forget about backups and downtime
now), or would the only viable option be the expensive one, and get
more servers (touch wood - the load balancers thankfully are nowhere
near max capacity)?  I don't have the experience or the tools to
properly bench servers simulating our current IO load, so I'm really
hoping that someone more experienced will be able to chip in here with
some definitive answers (if that is even possible).  If what I have
currently is as good as it is going to, reasonably, get then so be it
as well.  If that's the case I have no option but to increase the
amount of front end servers and I can close my eyes and accept that
too.

--
Chris.
