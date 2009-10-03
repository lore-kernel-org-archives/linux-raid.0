From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 0/3] md fixes for 2.6.32-rc
Date: Sat, 03 Oct 2009 08:54:03 -0700
Message-ID: <4AC7739B.9040209@intel.com>
References: <20091002011747.24095.70355.stgit@dwillia2-linux.ch.intel.com> <19141.32211.742547.19481@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19141.32211.742547.19481@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday October 1, dan.j.williams@intel.com wrote:
>> Hi Neil,
>>
>> A few fixes:
>> 1/ The multicore option is not ready for prime time
> 
> But it is already marked experimental...
> So do we really need to revert?  or is the current code broken beyond
> repair?

On second thought perhaps it is salvageable.  I'll take a look at moving 
the parallelism down from handle_stripe() to raid_run_ops().

--
Dan
