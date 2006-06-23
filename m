From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Large single raid and XFS or two small ones and EXT3?
Date: Fri, 23 Jun 2006 14:14:02 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0606231409180.21817@lion.drogon.net>
References: <449AEB7C.6040108@cjx.com> <op.tblclqd3cigqcu@apollo13>
 <fd8d0180606230226w10b1982ay2916805d9aa0e3bb@mail.gmail.com> <449BE381.6070000@cjx.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <449BE381.6070000@cjx.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Allen <chris@cjx.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 23 Jun 2006, Chris Allen wrote:

> Strange that whatever the filesystem you get equal numbers of people
> saying that
> they have never lost a single byte to those who have had horrible
> corruption and
> would never touch it again. We stopped using XFS about a year ago because we
> were getting kernel stack space panics under heavy load over NFS. It
> looks like
> the time has come to give it another try.

I had a bad experience with XFS a year or so ago, and after getting told
to RTFM from the XFS users list, after I'd already RTFMd, I gave up on it.
(and them)

However, I've just decided to give it a go again (for the single reason
that it's faster at deleting large swathes of files than ext3, which this
server might have to do from time to time), and so-far so good.

Looking back, what I think I really was having problems with at the time
was 2 issues; one was that I was using LVM too, and it really wasn't
production ready, and the other was that the default kernel stack size was
4KB at the time - which was what was causing me problems under heavy NFS
load...

I'm trying it now on a 3.5TB RAID-6 server now with a relatively light NFS
(and Samba)  load, but will be rolling it out on an identical server soon
which is expected to have a relatively high load, so heres hoping...

Gordon
