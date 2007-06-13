From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: raid5: coding style cleanup / refactor
Date: Wed, 13 Jun 2007 11:53:22 -0700
Message-ID: <e9c3a7c20706131153l289490f2t60db3b5c251a362a@mail.gmail.com>
References: <20070612142532.b45ee9bf.akpm@linux-foundation.org>
	 <0C7297FA1D2D244A9C7F6959C0BF1E5201FDE2CB@azsmsx413.amr.corp.intel.com>
	 <e9c3a7c20706121509x43dda6f6uc3b4d70a01c0c891@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20706121509x43dda6f6uc3b4d70a01c0c891@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> In other words, it seemed like a good idea at the time, but I am open
> to suggestions.
>

I went ahead and added the cleanup patch to the front of the
git-md-accel.patch series.  A few more whitespace cleanups, but no
major changes from what I posted earlier.  The new rebased series is
still passing my tests and Neil's tests in mdadm.

--
Dan
