From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [mdadm PATCH 2/4] systemd/mdadm-last-resort: use
 ConditionPathExists instead of Conflicts
Date: Thu, 20 Apr 2017 12:57:56 -0400
Message-ID: <ddc3b873-914f-6129-a6f8-2918621fa6bb@gmail.com>
References: <149265560315.31004.3851231165281498425.stgit@noble>
 <149265600571.31004.1241857541944212398.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <149265600571.31004.1241857541944212398.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/19/2017 10:40 PM, NeilBrown wrote:
> Commit cec72c071bbe ("systemd/mdadm-last-resort: add Conflicts to .service file.")
>
> added a 'Conflicts' directive to the mdadm-last-resort@.service file in
> the hope that this would make sure the service didn't run after the device
> was active, even if the timer managed to get started, which is possible in
> race conditions.
>
> This seemed to work is testing, but it isn't clear why, and it is known
> to cause problems.
> If systemd happens to know that the mentioned device is a dependency of a
> mount point, the Conflicts can unmount that mountpoint, which is certainly
> not wanted.
>
> So remove the "Conflicts" and instead use
>  ConditionPathExists=!/sys/devices/virtual/block/%i/md/sync_action
>
> The "sync_action" file exists for any array which requires last-resort
> handling, and only appears when the array is activated.  So it is safe
> to rely on it to determine if the last-resort is really needed.
>
> Fixes: cec72c071bbe ("systemd/mdadm-last-resort: add Conflicts to .service file.")
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  systemd/mdadm-last-resort@.service |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Ohhh obscure systemd conditionals, my favorite thing in the whole World.....

Applied!

Thanks,
Jes


