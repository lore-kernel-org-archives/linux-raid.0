From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: 3ware escalade vs software raid, from a different jeff
Date: Tue, 24 Feb 2004 09:16:18 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0402240908530.25541@chaos.egr.duke.edu>
References: <Law11-F34H1dsDb7xBN000117b3@hotmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Law11-F34H1dsDb7xBN000117b3@hotmail.com>
To: Jeff Gray <jeffgray@hotmail.com>
Cc: Holger.Kiehl@dwd.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 23 Feb 2004 at 5:23pm, Jeff Gray wrote

> I am curious as to which filesystem you are using on that server. I've asked 
> questions on other
> mailing lists before regarding journaling filesystems but it's always 
> interesting to see how people
> are using them in real-life scenarios. Currently I'm trying to choose 
> between Reiser and XFS.

It very much depends on your workload and typical file size.  I use XFS on 
my big 3ware based servers (2 2TB servers, and 1 1TB), and generally am 
*very* pleased with it.  It's very popular on the linux-ide-arrays list as 
well.

XFS usually is very fast.  Where it falls down (at least, I think it's the 
culprit) is when you have *lots* of very small files.  One directory on 
one of my servers is ~450 GB big and has ~3.4M files in ~29K 
subdirectories (avg file size 140Kb).  Operations on that directory are 
noticeably slow.  For that sort of workload, I'd think Reiser would 
be better.

And lots of folks just stick with ext3.  The best answer, of course, is to 
test with something that as closely as possible resembles your expected 
workload.

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
