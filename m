From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [PATCH] monitor: Make sure that last_checkpoint is set to 0 after sync
Date: Thu, 16 Jun 2016 13:55:25 -0400
Message-ID: <wrfjlh25ow6q.fsf@redhat.com>
References: <146606834045.17835.18148510717600494913.stgit@gklab-154-222.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <146606834045.17835.18148510717600494913.stgit@gklab-154-222.intel.com>
	(Pawel Baldysiak's message of "Thu, 16 Jun 2016 11:12:20 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Pawel Baldysiak <pawel.baldysiak@intel.com>
Cc: linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com, aleksey.obitotskiy@intel.com, tomasz.majchrzak@intel.com
List-Id: linux-raid.ids

Pawel Baldysiak <pawel.baldysiak@intel.com> writes:
> In a case of successful completion of a resync (in the last step)
> - read_and_act sometimes still reads sync_action as "resync"
> but sync_completed already is set to component_size.
> When this race occurs, sync operation is
> marked as finished, but last_checkpoint is
> overwritten with sync_completed. It will cause next
> sync operation (ie. reshape) to be reported as complete immediately
> after start - mdmon will write successful completion of the reshape
> to metadata. This patch sets last_checkpoint to 0 once the sync
> is completed to stop it happening.
>
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  monitor.c |    3 +++
>  1 file changed, 3 insertions(+)

Applied!

Thanks,
Jes
