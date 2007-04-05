From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: raid6 rebuild
Date: Wed, 4 Apr 2007 20:22:00 -0700
Message-ID: <e9c3a7c20704042022p6088bdcdl97740d2a95818caf@mail.gmail.com>
References: <20070404194638.GB3712@xi.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070404194638.GB3712@xi.wantstofly.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: mingo@redhat.com, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/4/07, Lennert Buytenhek <buytenh@wantstofly.org> wrote:
> (please CC on replies, not subscribed to linux-raid@)
>
> Hi!
>
> While my RAID6 array was rebuilding after one disk had failed (which
> I replaced), a second disk failed[*], and this caused the rebuild
> process to start over from the beginning.
>
> Why would the rebuild need to start over from the beginning in this
> case?  Why couldn't it just continue from where it was?
>
I believe it is because raid5 and raid6 share the same error handler
which sets MD_RECOVERY_ERR after losing any disk.  It should probably
not set this flag in 1-disk lost raid6 case, but I might be
overlooking something else.

>
> thanks,
> Lennert
>

Dan
