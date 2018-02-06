From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [md PATCH 2/2] md: only allow remove_and_add_spares when no
 sync_thread running.
Date: Tue, 6 Feb 2018 15:50:30 +0100
Message-ID: <f851bbe8-7f69-8c5f-1fe2-17abdf251b60@intel.com>
References: <151760990726.5944.15903931975424856346.stgit@noble>
 <151760997028.5944.10292479373004611829.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <151760997028.5944.10292479373004611829.stgit@noble>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, yuyufen <yuyufen@huawei.com>, colyli@suse.de
List-Id: linux-raid.ids

On 02/02/2018 11:19 PM, NeilBrown wrote:
> The locking protocols in md assume that a device will
> never be removed from an array during resync/recovery/reshape.
> When that isn't happening, rcu or reconfig_mutex is needed
> to protect an rdev pointer while taking a refcount.  When
> it is happening, that protection isn't needed.
> 
> Unfortunately there are cases were remove_and_add_spares() is
> called when recovery might be happening: is state_store(),
> slot_store() and hot_remove_disk().
> In each case, this is just an optimization, to try to expedite
> removal from the personality so the device can be removed from
> the array.  If resync etc is happening, we just have to wait
> for md_check_recover to find a suitable time to call
> remove_and_add_spares().
> 
> This optimization and not essential so it doesn't
> matter if it fails.
> So change remove_and_add_spares() to abort early if
> resync/recovery/reshape is happening, unless it is called
> from md_check_recovery() as part of a newly started recovery.
> The parameter "this" is only NULL when called from
> md_check_recovery() so when it is NULL, there is no need to abort.
> 
> As this can result in a NULL dereference, the fix is suitable
> for -stable.
> 
> cc: yuyufen <yuyufen@huawei.com>
> Cc: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> Fixes: 8430e7e0af9a ("md: disconnect device from personality before trying to remove it.")
> Cc: stable@ver.kernel.org (v4.8+)
> Signed-off-by: NeilBrown <neilb@suse.com>

I can confirm that this patch fixes a NULL pointer dereference issue for me.

Tested-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
