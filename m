From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [mdadm PATCH] systemd: add %I to description of mdadm-last-resort
 services.
Date: Wed, 1 Nov 2017 17:24:55 -0400
Message-ID: <58acbc52-a3ae-b76c-6470-0dcb47fe508b@gmail.com>
References: <87tvyhbh5k.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87tvyhbh5k.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>, Andrei Borzenkov <arvidjaar@gmail.com>
List-Id: linux-raid.ids

On 10/29/2017 08:42 PM, NeilBrown wrote:
> 
> Just like the other template services, include the instance
> name (I%) in the description of
>  mdadm-last-resort@.service
>  mdadm-last-resort@.timer
> 
> so that it is clear from the logs which array is affected.
> 
> Reported-by: Andrei Borzenkov <arvidjaar@gmail.com>
> Link: http://bugzilla.opensuse.org/show_bug.cgi?id=1064915
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  systemd/mdadm-last-resort@.service | 2 +-
>  systemd/mdadm-last-resort@.timer   | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Applied!

Thanks,
Jes


