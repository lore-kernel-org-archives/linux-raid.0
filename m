From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [mdadm PATCH] Move mdadm_env.sh out of /usr/lib/systemd
Date: Tue, 10 Oct 2017 16:45:38 -0400
Message-ID: <452c5ca6-3726-8ea8-f542-f6c5d6fd1063@gmail.com>
References: <87poa215s2.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87poa215s2.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/05/2017 02:13 AM, NeilBrown wrote:
> 
> The systemd developers like to keep control of the
> lib/systemd namespace, and haven't approved of the use
> of lib/systemd/scripts.  So we should stop using it.
> 
> Move the mdadm_env.sh script, optionally sourced by
> mdmonitor.service, to a new directory /usr/lib/mdadm.
> 
> Signed-off-by: NeilBrown <neilb@suse.com>

Applied!

Thanks,
Jes

