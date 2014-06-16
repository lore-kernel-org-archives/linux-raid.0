From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: raid5.c::grow_stripes() kmem_cache_create() race
Date: Mon, 16 Jun 2014 20:25:08 +0300
Message-ID: <CAGRgLy54f3f-3QLQy_kQ8xbA8mkcAe1OPrhUVtir8Sb_-DOtMQ@mail.gmail.com>
References: <CAGRgLy5Nz7aVRsqhco1eUB0hTvnYgupaUuGv=wA7ttWg+mdBmQ@mail.gmail.com>
	<20140612173744.03dd7a70@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140612173744.03dd7a70@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, vdavydov@parallels.com, cl@linux.com
List-Id: linux-raid.ids

Hi Neil,
apparently this problem has been fixed only very recently,  by commit:
421af24 slub: do not drop slab_mutex for sysfs_slab_add

So I guess you won't be interested in fixing it in older kernels. As
Vladimir suggested, raid5 can create unmergeable caches, by providing
a dummy ctor to kmem_cache_create(). But I guess, it's not what we
want, is it?

Thanks,
Alex.

On Thu, Jun 12, 2014 at 10:37 AM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 11 Jun 2014 19:00:42 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
> wrote:
>
>> Hi Neil,
>> in your master branch, you have a code like:
>>
>> static int grow_stripes(struct r5conf *conf, int num)
>> {
>>     struct kmem_cache *sc;
>>     int devs = max(conf->raid_disks, conf->previous_raid_disks);
>>     int hash;
>>
>>     if (conf->mddev->gendisk)
>>         sprintf(conf->cache_name[0],
>>             "raid%d-%s", conf->level, mdname(conf->mddev));
>>     else
>>         sprintf(conf->cache_name[0],
>>             "raid%d-%p", conf->level, conf->mddev);
>>     sprintf(conf->cache_name[1], "%s-alt", conf->cache_name[0]);
>>
>>     conf->active_name = 0;
>>     sc = kmem_cache_create(conf->cache_name[conf->active_name],
>>                    sizeof(struct stripe_head)+(devs-1)*sizeof(struct r5dev),
>>                    0, 0, NULL);
>>
>> In our case what happened was:
>> - we were assembling two MDs in parallel: md4 and md5
>> - each one tried to create its own kmem_cache: raid5-md4 and raid5-md5
>> (each one had valid conf->mmdev->gendisk)
>>
>> In our kernel SLUB is configured. So the code went to
>> slub.c::__kmem_cache_create(). It called sysfs_slab_add(), which
>> eventually tried to do:
>>
>> if (unmergeable) {
>>     // not here
>> } else {
>>     // we went here
>>     name = create_unique_id(s);
>> }
>>
>> For both threads calling this, it created the same unique id:
>> "t-0001832". And then sysfs freaked out and complained[1]. So md5 was
>> unlucky and failed to initialize, and md4 got lucky and came up.
>> Later, we retried md5 assembly and it worked alright.
>>
>> In this case, both MDs have the same number of disks. That's why
>> kernel tried to have a single cache. Problem is that
>> __kmem_cache_create unlocks slab_mutex, so that's why the race becomes
>> possible.
>>
>> I realize that this is not MD-specific, but rather slab-specific
>> issue, but do you have any idea how to fix that?:(
>
> no, sorry.
>
> As the slub developers.
>
> NeilBrown
