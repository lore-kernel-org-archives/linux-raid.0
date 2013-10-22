From: David Brown <david.brown@hesbynett.no>
Subject: Re: Linux MD? Or an H710p?
Date: Tue, 22 Oct 2013 09:24:57 +0200
Message-ID: <52662849.1080003@hesbynett.no>
References: <526328AE.2020908@gmail.com> <21093.14265.261728.755087@quad.stoffel.home> <5265C89A.4000908@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5265C89A.4000908@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Bergman <sbergman27@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/10/13 02:36, Steve Bergman wrote:

<snip>

> But hey, this is going to be a very nice opportunity for observing XFS's
> savvy with parallel i/o.

You mentioned using a 6-drive RAID10 in your first email, with XFS on
top of that.  Stan is the expert here, but my understanding is that you
should go for three 2-drive RAID1 pairs, and then use an md linear
"raid" for these pairs and put XFS on top of that in order to get the
full benefits of XFS parallelism.

mvh.,

David

