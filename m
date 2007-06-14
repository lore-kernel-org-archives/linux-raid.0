From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid5: coding style cleanup / refactor
Date: Thu, 14 Jun 2007 17:08:46 -0400
Message-ID: <4671AE5E.4090602@tmr.com>
References: <20070612142532.b45ee9bf.akpm@linux-foundation.org>	 <0C7297FA1D2D244A9C7F6959C0BF1E5201FDE2CB@azsmsx413.amr.corp.intel.com>	 <e9c3a7c20706121509x43dda6f6uc3b4d70a01c0c891@mail.gmail.com> <e9c3a7c20706131153l289490f2t60db3b5c251a362a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20706131153l289490f2t60db3b5c251a362a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dan Williams wrote:
>> In other words, it seemed like a good idea at the time, but I am open
>> to suggestions.
>>
>
> I went ahead and added the cleanup patch to the front of the
> git-md-accel.patch series.  A few more whitespace cleanups, but no
> major changes from what I posted earlier.  The new rebased series is
> still passing my tests and Neil's tests in mdadm. 
When you are ready for wider testing, if you have a patch against a 
released kernel it makes testing easy, characteristics are pretty well 
known already.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

