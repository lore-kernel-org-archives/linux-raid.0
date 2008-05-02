From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH] md: fix raid5 'repair' operations
Date: Fri, 2 May 2008 11:36:03 -0700
Message-ID: <e9c3a7c20805021136k51cc0ef8la940002454340de4@mail.gmail.com>
References: <20080502031513.13090.2973.stgit@dwillia2-linux.ch.intel.com>
	 <20080502162447.13832.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080502162447.13832.qmail@science.horizon.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 2, 2008 at 9:24 AM, George Spelvin <linux@horizon.com> wrote:
> Just to confirm, after 2 hours repair + 2 hours check, it seems to have
>  worked.  And the e2fsck didn't complain.
>
>  So if you think it's good, please submit for 2.6.25.2.

Thanks for reporting this and confirming the fix,
Dan
