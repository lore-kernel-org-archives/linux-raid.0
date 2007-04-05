From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: raid6 rebuild
Date: Thu, 5 Apr 2007 09:59:10 -0700
Message-ID: <e9c3a7c20704050959t7a1866b3j8e3bcc64a893854c@mail.gmail.com>
References: <20070404194638.GB3712@xi.wantstofly.org>
	 <e9c3a7c20704042022p6088bdcdl97740d2a95818caf@mail.gmail.com>
	 <20070405055030.GA6978@xi.wantstofly.org> <4614FF86.3020007@tmr.com>
	 <20070405140626.GA8726@xi.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070405140626.GA8726@xi.wantstofly.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Bill Davidsen <davidsen@tmr.com>, mingo@redhat.com, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/5/07, Lennert Buytenhek <buytenh@wantstofly.org> wrote:
> On Thu, Apr 05, 2007 at 09:54:14AM -0400, Bill Davidsen wrote:
>
> > I confess, I would feel safer with my data if the rebuild started
> > over, I would like to be sure that when it (finally) finishes the
> > data are valid.
>
> With disk #3 about to die, I'd have felt safer if it first finished
> rebuilding the replacement disk for failed disk #1 (that rebuild had
> almost completed at that point), safeguarding the array against a
> third disk failure.
>
I agree, the current arrangement seems to throw away a significant
amount of work.  Yes, you will need to resync when re-adding the
second disk, but in the meantime might as well try to get a redundant
mode at all costs.

> Yeah, I know, you're not supposed to lose three disks within one day.
>
>
> > If you replaced the 2nd drive, then a full rebuild would be required
> > in any case, to get ALL drives valid.
>
> You could finish the last little bit of the resync of the replacement
> for failed disk #1 (by looking at P+Q), and then re-sync the replacement
> for failed disk #2 (by looking only at P..)
> -

--
Dan
