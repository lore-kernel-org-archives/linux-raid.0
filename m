From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: ANNOUNCE: mdadm 4.0 - A tool for managing md Soft RAID under
 Linux
Date: Wed, 11 Jan 2017 11:59:46 -0500
Message-ID: <b2808c47-5180-818d-87d9-ab28f699234e@gmail.com>
References: <1cd97490-e650-d98b-466a-095292dc5b98@gmail.com>
 <58751E90.5090306@gmail.com> <20170111165241.yavdwc57v6yodx7g@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170111165241.yavdwc57v6yodx7g@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Bruce Dubbs <bruce.dubbs@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Brown, Neil" <neilb@suse.com>
List-Id: linux-raid.ids

On 01/11/17 11:52, Shaohua Li wrote:
> On Tue, Jan 10, 2017 at 11:49:04AM -0600, Bruce Dubbs wrote:
>> Jes Sorensen wrote:
>>> I am pleased to announce the availability of
>>>     mdadm version 4.0
>>>
>>> It is available at the usual places:
>>>     http://www.kernel.org/pub/linux/utils/raid/mdadm/
>>> and via git at
>>>     git://git.kernel.org/pub/scm/utils/mdadm/mdadm.git
>>>     http://git.kernel.org/cgit/utils/mdadm/
>>>
>>> The update in major version number primarily indicates this is a
>>> release by it's new maintainer. In addition it contains a large number
>>> of fixes in particular for IMSM RAID and clustered RAID support.  In
>>> addition this release includes support for IMSM 4k sector drives,
>>> failfast and better documentation for journaled RAID.
>>
>> Thank you for the new release.  Unfortunately I get 9 failures running the
>> test suite:
>>
>> tests/00raid1...          FAILED
>> tests/07autoassemble...   FAILED
>> tests/07changelevels...   FAILED
>> tests/07revert-grow...    FAILED
>> tests/07revert-inplace... FAILED
>> tests/07testreshape5...   FAILED
>> tests/10ddf-fail-twice... FAILED
>> tests/20raid5journal...   FAILED
>> tests/10ddf-incremental-wrong-order...  FAILED
> 
> Yep, several tests usually fail. It appears some checks aren't always good.  At
> least the 'check' function for reshape/resync isn't reliable in my test, I saw
> 07changelevelintr fails frequently.

That is my experience as well - some of them are affected by the kernel
version too. We probably need to look into making them more reliable.

I am also not sure how reliable the DDF tests are on systems without DDF
support.

Cheers,
Jes
