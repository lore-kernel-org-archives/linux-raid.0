From: Jes Sorensen <jes.sorensen@gmail.com>
Subject: Re: [PATCH v2] Monitor: containers don't have the same sysfs
 properties as arrays
Date: Wed, 16 Aug 2017 06:34:44 -0400
Message-ID: <544652f0-97d4-d228-7832-cd0268727433@gmail.com>
References: <1501161728-580-1-git-send-email-mariusz.tkaczyk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1501161728-580-1-git-send-email-mariusz.tkaczyk@intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/27/2017 09:22 AM, Mariusz Tkaczyk wrote:
> GET_MISMATCH option doesn't exist for containers so sysfs_read fails if
> this information is requested. Set options according to the device using
> information from /proc/mdstat.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> ---
>   Monitor.c | 45 +++++++++++++++++++++++++++------------------
>   1 file changed, 27 insertions(+), 18 deletions(-)

Hi Mariusz,

Sorry for the late response, I am just back from PTO.

I know you will hate me for this, but I have one more nit:

> diff --git a/Monitor.c b/Monitor.c
> index 48c451c..de470bd 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -465,6 +465,8 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
>   	int last_disk;
>   	int new_array = 0;
>   	int retval;
> +	int is_container;
> +	unsigned long array_only_flags = 0;
>   
>   	if (test)
>   		alert("TestMessage", dev, NULL, ainfo);
[snip]
> +	if (!mse) {
> +		/* duplicated array in statelist
> +		 * or re-created after reading mdstat
> +		 */
> +		st->err++;
> +		goto out;
> +	}
> +
> +	is_container = mse->level == NULL;

I really find this last line super obfuscating - I had to go back and 
read it again to realize it wasn't just trying to set is_container and 
mse->level both to NULL.

Would you mind using an if statement there instead?

Thanks,
Jes


