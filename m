From: David Greaves <david@dgreaves.com>
Subject: Re: questions about softraid limitations
Date: Sun, 18 May 2008 10:11:55 +0100
Message-ID: <482FF2DB.9060604@dgreaves.com>
References: <002801c8b55a$60e4a360$0404a8c0@dcccs> <482AC2BB.5010602@dgreaves.com> <01be01c8b61a$6e616260$9300a8c0@dcccs> <482D479F.3040809@dgreaves.com> <022401c8b739$5262ba80$9300a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <022401c8b739$5262ba80$9300a8c0@dcccs>
Sender: linux-raid-owner@vger.kernel.org
To: Janos Haar <janos.haar@netcenter.hu>
Cc: linux-raid@vger.kernel.org, David Lethe <david@santools.com>
List-Id: linux-raid.ids

Janos Haar wrote:
> At this time, i working in my data recovery company, and some times need
Ah - I missed this too.

> to recover the broken hw raid arrays too.
> (with md arrays, we have no problem at all. :-) )
Nice quote for "the benefits of software raid" somewhere :)

> In your rows, we talking about 2 cases:
> 
> a, disk hw problem (only bad sectors, the completely failed disk is in
> 'b' case)
> Yes, the ddrescue is the best way, to do the recovery, but:
> The ddrescue is too agressive with default -e 0 setting!
> This can be easily fail down the drive! (dependig the reason of the bad
> sectors)
OK, worth knowing - what would you suggest?

> And with the images, we have another problem!
> The 0x00 holes.
> The hw or md have no deal about where we need recover from parity and
> where we have real zero blocks....
> Overall this is why data recovery companys learning and developing more
> and more.... :-)

Hmm - I wonder if things like ddrescue could work with the md bitmaps to improve
this situation?
Is this related to David Lethe's recent request?

> I need no help at this time, i just want to share my ideas, to helping
> upgrading/developing md, and helping for people....
OK - ta.

David
