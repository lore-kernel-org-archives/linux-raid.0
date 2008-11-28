From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [RFC patch 1/1] Track raid5/6 statistics.
Date: Fri, 28 Nov 2008 14:14:42 -0700
Message-ID: <e9c3a7c20811281314g7be33d97x838720b5e49a56e3@mail.gmail.com>
References: <20081126190452.775333692@sun.com>
	 <20081126190854.813151413@sun.com>
	 <e9c3a7c20811261350n57fb3881if443969b27079543@mail.gmail.com>
	 <20081127134503.GC29919@clouds>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081127134503.GC29919@clouds>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Jody McIntyre <scjody@sun.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Thu, Nov 27, 2008 at 6:45 AM, Jody McIntyre <scjody@sun.com> wrote:
> Hi Dan,
>
> On Wed, Nov 26, 2008 at 02:50:18PM -0700, Dan Williams wrote:
>
>> I have done some work in this area too
>
> Got any preliminary patches you can share?
>

A patch for streaming write performance.  The get_priority_stripe [1]
patch was the end result of a discussion and initial investigation of
raid5 write performance [2] started by Raz Ben-Jehuda(caro).  It
helps, but is not a panacea...

--
Dan

[1]: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=8b3e6cdc53b7f29f7026955d6cb6902a49322a15
[2]: http://marc.info/?l=linux-raid&m=117697457216290&w=2
