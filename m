From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: [PATCH] ASYNC_TX: fix the bug in async_tx_run_dependencies
Date: Thu, 4 Sep 2008 16:24:04 -0700
Message-ID: <e9c3a7c20809041624o24af57fsbe58507a44e6e2ef@mail.gmail.com>
References: <1220478231-8725-1-git-send-email-yanok@emcraft.com>
	 <20080904141945.f5c4c3eb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080904141945.f5c4c3eb.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Ilya Yanok <yanok@emcraft.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, wd@denx.de, yur@emcraft.com
List-Id: linux-raid.ids

On Thu, Sep 4, 2008 at 2:19 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu,  4 Sep 2008 01:43:51 +0400
> Ilya Yanok <yanok@emcraft.com> wrote:
>
>> From: Yuri Tikhonov <yur@emcraft.com>
>>
>> Should clear the next pointer of the TX if we are sure that the
>> next TX (say NXT) will be submitted to the channel too. Overwise,
>> we break the chain of descriptors, because we lose the information
>> about the next descriptor to run. So next time, when invoke
>> async_tx_run_dependencies() with TX, it's TX->next will be NULL, and
>> NXT will be never submitted.
>>
>> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
>
> This patch should include your signed-off-by: as well.  Because you
> were on the delivery path, as described in
> Documentation/SubmittingPatches, section 12.
>

Yes, Ilya once I have your signed-off-by I will push this to Linus and
-stable.  As far as impact for in-tree drivers: iop13xx by is immune,
iop3xx can hit this, and it looks like the orion5x implementation is
immune since copy and xor are available on the same channel.

--
Dan
