From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH v2 1/1] mdadm.8: add note information for raid0 growing
 operation
Date: Mon, 24 Feb 2020 16:03:39 -0500
Message-ID: <0ad0fd3a-b8bc-a47f-de8a-b991248d2e0b@trained-monkey.org>
References: <20200224113409.11137-1-pvorel@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200224113409.11137-1-pvorel@suse.cz>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Petr Vorel <pvorel@suse.cz>, linux-raid@vger.kernel.org
Cc: Coly Li <colyli@suse.de>, NeilBrown <neilb@suse.de>, Paul Menzel <pmenzel@molgen.mpg.de>, Wols Lists <antlists@youngman.org.uk>, Nix <nix@esperi.org.uk>
List-Id: linux-raid.ids

On 2/24/20 6:34 AM, Petr Vorel wrote:
> From: Coly Li <colyli@suse.de>
> 
> When growing a raid0 device, if the new component disk size is not
> big enough, the grow operation may fail due to lack of backup space.
> 
> The minimum backup space should be larger than:
>  LCM(old, new) * chunk-size * 2
> 
> where LCM() is the least common multiple of the old and new count of
> component disks, and "* 2" comes from the fact that mdadm refuses to
> use more than half of a spare device for backup space.
> 
> There are users reporting such failure when they grew a raid0 array
> with small component disk. Neil Brown points out this is not a bug
> and how the failure comes. This patch adds note information into
> mdadm(8) man page in the Notes part of GROW MODE section to explain
> the minimum size requirement of new component disk size or external
> backup size.
> 
> Reviewed-by: Petr Vorel <pvorel@suse.cz>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Jes Sorensen <jsorensen@fb.com>
> Cc: Paul Menzel <pmenzel@molgen.mpg.de>
> Cc: Wols Lists <antlists@youngman.org.uk>
> Cc: Nix <nix@esperi.org.uk>
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
> Hi,
> 
> Coly haven't sent v2, but it's already prepared in openSUSE package [1],
> therefore sending it on his behalf.
> 
> Kind regards,
> Petr

Applied!

Thanks,
Jes
