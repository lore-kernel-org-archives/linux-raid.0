From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: soft-lockup in raid5 / 2.6.24
Date: Mon, 14 Apr 2008 21:17:40 -0700
Message-ID: <e9c3a7c20804142117t31441dacsa9bde36c37fcc52c@mail.gmail.com>
References: <alpine.DEB.1.10.0804070806300.7751@twinlark.arctic.org>
	 <e9c3a7c20804071543l6d9df2dbkc86bec6388da3f77@mail.gmail.com>
	 <alpine.DEB.1.10.0804132119250.10006@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0804132119250.10006@twinlark.arctic.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Apr 13, 2008 at 9:23 PM, dean gaudet <dean@arctic.org> wrote:
>  oh it finished, sorry i should have said that :)
>
>  there were just those various soft lockup warnings...
>
>  as a wild stab in the dark -- does the "faulty" test mode support
>  delaying reads or writes for a very long time?  (or is there some other
>  fake block device we can inject long delays with?)
>

DM has an I/O delaying target... but that should not be the problem in
this case.  The 'softlockup' mechanism triggers when we are spending
an inordinate amount of time *running* in a given kernel routine,
while MD is waiting for I/O to come back the md thread is sleeping.  I
looked at the code and found a live lock condition, but if you had
encountered it your array would be degraded and the resync process
would have never completed.

The fact that it is triggering in async_xor_zero_sum makes me wonder
if this could be a false positive i.e. a perfect storm where the
softlockup tick is always happening to fire while we are computing
parity.  Seems improbable though... I would need to understand more
about how softlockup works before making that assertion.

Thanks,
Dan
