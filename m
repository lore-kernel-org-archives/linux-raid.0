From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: /sys/block/md126 still exists even after stopping the array
Date: Fri, 26 Sep 2014 14:21:04 +0200
Message-ID: <54255A30.9010406@gmail.com>
References: <53A99B76.3020603@gmail.com>	<20140625110348.48ab2d7a@notabene.brown>	<54243ED7.6090904@gmail.com>	<20140926103348.5f5ea568@notabene.brown>	<54253E9F.4070505@gmail.com> <20140926204445.1ec830b9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140926204445.1ec830b9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, sebastian.riemer@profitbricks.com
List-Id: linux-raid.ids

On 09/26/2014 12:44 PM, NeilBrown wrote:
> On Fri, 26 Sep 2014 12:23:27 +0200 Francis Moreau <francis.moro@gmail.com>
> wrote:
> 
>> Hello Neil,
>>
>> On 09/26/2014 02:33 AM, NeilBrown wrote:
>>> On Thu, 25 Sep 2014 18:12:07 +0200 Francis Moreau <francis.moro@gmail.com>
>>> wrote:
>> [...]
>>>> I tried to find out what could have opened the md device by using fuser,
>>>> but fuser reports no users.
>>>
>>> It is probably a transient open/close.
>>>
>>
>> If it's open/close wouldn't the 'close' part make the device disapear ?
> 
> No. It's ... complicated.
> 
>>
>>>>
>>>> I took a look to the udev rules which are the one shipped by mdadm 3.3.2
>>>> but nothing keep the device opened during the remove event.
>>>>
>>>> Could you give me some hints here to debug this ?
>>>
>>> Modify md_open in drivers/md/md.c to add
>>>    printk("Opened by %s\n", current->comm);
>>>
>>> and build a new kernel.  That will tell you the name of the process which
>>> opened the device.
>>>
>>
>> I did that I also added a trace in md_release() but strangely no trace
>> were outputed from there.
> 
> Without seeing your patch I can't guess what it happening, but I am *certain*
> that md_release() would get called providing md_open didn't return an error.

Here's the patch:

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 73aedcb..08ead8d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6703,6 +6703,8 @@ static int md_open(struct block_device *bdev,
fmode_t mode)
 	struct mddev *mddev = mddev_find(bdev->bd_dev);
 	int err;

+	printk("md_open(): opened by %s\n", current->comm);
+
 	if (!mddev)
 		return -ENODEV;

@@ -6735,6 +6737,8 @@ static void md_release(struct gendisk *disk,
fmode_t mode)
 {
  	struct mddev *mddev = disk->private_data;

+	printk("md_release(): released by %s\n", current->comm);
+
 	BUG_ON(!mddev);
 	atomic_dec(&mddev->openers);
 	mddev_put(mddev);

> 
> It might be helpful to print out the pid and the md device number too
>  task_tgid_vnr(current)
> will give you the pid.
>   mdname(mddev)
> give the name of the device.
> 

Here's the new trace, this time md_release() was called, so I probably
did something wrong the first time, sorry for that.

[    1.470744] md_open(): md127 opened by mdadm [388]
[    1.485437] md_release(): md127 released by mdadm [388]
[    1.486888] md_open(): md126 opened by mdadm [381]
[    1.487468] md_release(): md126 released by mdadm [381]
[    1.488646] md_open(): md125 opened by mdadm [383]
[    1.489074] md_release(): md125 released by mdadm [383]
[    1.490555] md_open(): md127 opened by mdadm [385]
[    1.512556] md_release(): md127 released by mdadm [385]
[    1.512582] md_open(): md127 opened by mdadm [385]
[    1.512682] md_open(): md126 opened by mdadm [384]
[    1.553414] md_release(): md126 released by mdadm [384]
[    1.553442] md_open(): md126 opened by mdadm [384]
[    1.553549] md_open(): md125 opened by mdadm [382]
[    1.573263] md_release(): md125 released by mdadm [382]
[    1.573288] md_open(): md125 opened by mdadm [382]
[    1.601034] md_open(): md125 opened by mdadm [459]
[    1.601041] md_release(): md125 released by mdadm [459]
[    1.601065] md_open(): md126 opened by mdadm [459]
[    1.601067] md_release(): md126 released by mdadm [459]
[    1.601090] md_open(): md127 opened by mdadm [459]
[    1.601092] md_release(): md127 released by mdadm [459]
[    1.601130] md_open(): md127 opened by mdadm [459]
[    1.601220] md_release(): md127 released by mdadm [459]
[    1.601633] md_open(): md126 opened by mdadm [459]
[    1.601661] md_release(): md126 released by mdadm [459]
[    1.601673] md_open(): md125 opened by mdadm [459]
[    1.601695] md_release(): md125 released by mdadm [459]
[    1.606127] md_open(): md125 opened by mdadm [454]
[    1.608682] md_open(): md126 opened by mdadm [453]
[    1.609514] md_open(): md127 opened by mdadm [448]
[    1.622512] md_release(): md126 released by mdadm [453]
[    1.623028] md_release(): md127 released by mdadm [448]
[    1.625288] md_open(): md126 opened by systemd-udevd [363]
[    1.625391] md_release(): md125 released by mdadm [454]
[    1.625619] md_open(): md127 opened by systemd-udevd [368]
[    1.625737] md_open(): md125 opened by systemd-udevd [366]
[    1.637137] md_release(): md125 released by systemd-udevd [366]
[    1.643982] md_open(): md125 opened by mdadm [476]
[    1.644071] md_release(): md127 released by systemd-udevd [368]
[    1.647787] md_release(): md125 released by mdadm [382]
[    1.648171] md_release(): md126 released by systemd-udevd [363]
[    1.651629] md_open(): md126 opened by mdadm [479]
[    1.656666] md_open(): md127 opened by mdadm [480]
[    1.657771] md_release(): md125 released by mdadm [476]
[    1.659312] md_open(): md125 opened by systemd-udevd [365]
[    1.663193] md_release(): md127 released by mdadm [385]
[    1.673669] md_release(): md125 released by systemd-udevd [365]
[    1.685527] md_release(): md127 released by mdadm [480]
[    1.685599] md_release(): md126 released by mdadm [479]
[    1.686058] md_open(): md126 opened by systemd-udevd [366]
[    1.686282] md_release(): md126 released by systemd-udevd [366]
[    1.691024] md_open(): md127 opened by systemd-udevd [363]
[    1.695415] md_release(): md126 released by mdadm [384]
[    1.707163] md_release(): md127 released by systemd-udevd [363]

>>> mdadm --stop --scan <<<

[   89.975162] md_open(): md125 opened by mdadm [930]
[   89.975305] md_release(): md125 released by mdadm [930]
[   89.977434] md_open(): md125 opened by mdadm [932]
[   89.978813] md_open(): md125 opened by mdadm [930]
[   89.979365] md_release(): md125 released by mdadm [932]
[   89.979693] md_open(): md125 opened by systemd-udevd [931]
[   89.985790] md_release(): md125 released by systemd-udevd [931]
[   90.179911] md_release(): md125 released by mdadm [930]
[   90.180168] md_open(): md127 opened by mdadm [459]
[   90.180187] md_release(): md127 released by mdadm [459]
[   90.180199] md_open(): md126 opened by mdadm [459]
[   90.180205] md_release(): md126 released by mdadm [459]
[   90.180556] md_open(): md126 opened by mdadm [930]
[   90.180653] md_release(): md126 released by mdadm [930]
[   90.180690] md_open(): md126 opened by mdadm [930]
[   90.180758] md_open(): mdX opened by mdadm [459]
[   90.180995] md_open(): md125 opened by mdadm [459]
[   90.181056] md_release(): md125 released by mdadm [459]
[   90.182717] md_open(): md127 opened by mdadm [459]
[   90.182725] md_release(): md127 released by mdadm [459]
[   90.182732] md_open(): md126 opened by mdadm [459]
[   90.182761] md_release(): md126 released by mdadm [459]
[   90.182770] md_open(): md125 opened by mdadm [459]
[   90.182775] md_release(): md125 released by mdadm [459]
[   90.182940] md_release(): md126 released by mdadm [930]
[   90.183167] md_open(): md127 opened by mdadm [930]
[   90.183257] md_release(): md127 released by mdadm [930]
[   90.183288] md_open(): md127 opened by mdadm [930]
[   90.183461] md_open(): md127 opened by mdadm [459]
[   90.183488] md_release(): md127 released by mdadm [459]
[   90.183499] md_open(): md125 opened by mdadm [459]
[   90.183505] md_release(): md125 released by mdadm [459]
[   90.183686] md_release(): md127 released by mdadm [930]


> Probably there is a 'change' event happening just before the 'remove' event,
> and udev runs "mdadm" on the 'change' event, and that ends up happening after
> the device has been removed.
> 
> Is this really a problem?  Can't you just ignore it and pretend it isn't
> there?

Well, if you list the block devices that the kernel detected in order to
operate on them, it could. I don't know exactly what would be the result
to use it but it could confuse some tools.

Is there a way to check that the 'ghost' device has been removed by
poking sysfs ?

Thanks
