From: Jes Sorensen <jsorensen@fb.com>
Subject: Re: [mdadm PATCH 1/1] Fix a build error
Date: Sun, 1 Oct 2017 18:08:11 -0400
Message-ID: <ad315f6f-22a2-c2f1-0c13-954d3e18e24e@fb.com>
References: <1505879308-6077-1-git-send-email-xni@redhat.com>
 <ef3ae89b-89d4-84cf-ae19-ebb9de0aa79e@fb.com>
 <67315e6f-1298-7199-7dee-4f2c72b5abc0@redhat.com>
 <7458ed3a-f510-f192-b07f-c61291ffd07d@fb.com>
 <230ed8ca-196e-9d10-a76a-5aded076f430@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <230ed8ca-196e-9d10-a76a-5aded076f430@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: ncroxon@redhat.com, pmenzel@molgen.mpg.de, antlists@youngman.org.uk
List-Id: linux-raid.ids

On 09/30/2017 10:12 AM, Xiao Ni wrote:
> 
> 
> On 09/30/2017 09:08 PM, Jes Sorensen wrote:
>> On 09/29/2017 09:19 PM, Xiao Ni wrote:
>>> Do you have a better solution?
>>
>> I looked at the other functions and they all carry rdev as a dev_t so 
>> I made it the same in Manage_subdevs(). We may have to clean up some 
>> more functions to take the right input argument, but it looks like the 
>> correct solution to me.
> 
> Do you mean some changes like this:
> 
> diff --git a/Manage.c b/Manage.c
> index 871d342..21536f5 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -1367,7 +1367,7 @@ int Manage_subdevs(char *devname, int fd,
>          }
> 
>          for (dv = devlist; dv; dv = dv->next) {
> -               unsigned long rdev = 0; /* device to add/remove etc */
> +               dev_t rdev = 0; /* device to add/remove etc */
>                  int rv;
>                  int mj,mn;
> 
> diff --git a/sysfs.c b/sysfs.c
> index 78d2b52..dc44e38 100644
> --- a/sysfs.c
> +++ b/sysfs.c
> @@ -78,7 +78,7 @@ int sysfs_open(char *devnm, char *devname, char *attr)
>          return fd;
>   }
> 
> -void sysfs_init_dev(struct mdinfo *mdi, unsigned long devid)
> +void sysfs_init_dev(struct mdinfo *mdi, dev_t devid)
>   {
>          snprintf(mdi->sys_name,
>                   sizeof(mdi->sys_name), "dev-%s", devid2kname(devid));
> 
> 
> We carry rdev as a dev_t and then clean up other functions. If it's ok,
> I'll send a new patch.
> 
> Best Regards
> Xiao

Yes,

But check latest git first, I already pushed in some of the changes.

Cheers,
Jes

