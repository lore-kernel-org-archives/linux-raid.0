From: Jes Sorensen <jes@trained-monkey.org>
Subject: Re: [PATCH v2] Manage, imsm: Write metadata before add
Date: Mon, 27 Apr 2020 10:37:22 -0400
Message-ID: <b674992e-fa21-0d51-9006-5bd620aca96b@trained-monkey.org>
References: <20200417115555.24080-1-mariusz.tkaczyk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200417115555.24080-1-mariusz.tkaczyk@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Tkaczyk Mariusz <mariusz.tkaczyk@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/17/20 7:55 AM, Tkaczyk Mariusz wrote:
> New drive in container always appears as spare. Manager is able to
> handle that, and queues appropriative update to monitor.
> No update from mdadm side has to be processed, just insert the drive and
> ping the mdmon. Metadata has to be written if no mdmon is running (case
> for Raid0 or container without arrays).
> 
> If bare drive is added very early on startup (by custom bare rule),
> there is possiblity that mdmon was not restarted after switch root. Old
> one is not able to handle new drive. New one fails because there is
> drive without metadata in container and metadata cannot be loaded.
> 
> To prevent this, write spare metadata before adding device
> to container. Mdmon will overwrite it (same case as spare migration,
> if drive appears it writes the most recent metadata).
> Metadata has to be written only on new drive before sysfs_add_disk(),
> don't race with mdmon if running.
> 
> Signed-off-by: Tkaczyk Mariusz <mariusz.tkaczyk@intel.com>
> ---
> v2: removed unused variable.
> 
>  Manage.c      |  6 +----
>  super-intel.c | 66 +++++++++++++++++++++++++++++++++------------------
>  2 files changed, 44 insertions(+), 28 deletions(-)

Applied!

Thanks,
Jes
