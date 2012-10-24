From: "Johnson Yan" <johnson_yan@usish.com>
Subject: RE: RAID0 DeviceDisappeared event happen when restart mdmonitor service
Date: Wed, 24 Oct 2012 12:29:11 +0800
Message-ID: <000301cdb1a0$20996560$61cc3020$@com>
References: <012401cd9260$141ca630$3c55f290$@com>	<CA+res+TafD=pdpX-8bz8M4keGDO45Jd=W9VGSY+=douiqGPy5w@mail.gmail.com>	<20120917124813.0bd260c3@notabene.brown>	<CA+res+RvgxtHmYHw3DMCm7La9AFoCzxM93YLKJYvYy7EwBYyfw@mail.gmail.com>	<016e01cd9483$d5690a70$803b1f50$@com> <20121024131040.406ff1b9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121024131040.406ff1b9@notabene.brown>
Content-Language: zh-cn
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.de>
Cc: 'Jack Wang' <jack.wang.usish@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,
Got it, thank you for the patch.

Best Regards
Johnson


> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Wednesday, October 24, 2012 10:11 AM
> To: Johnson Yan
> Cc: 'Jack Wang'; linux-raid@vger.kernel.org
> Subject: Re: RAID0 DeviceDisappeared event happen when restart mdmonitor
> service
> 
> On Mon, 17 Sep 2012 11:23:40 +0800 "Johnson Yan"
> <johnson_yan@usish.com>
> wrote:
> 
> > Hi Neil,
> > Thank you for the clarification.
> > I can remove the RAID0 MD's information from /etc/mdadm.conf to omit the
> monitor for RAID0, then so such event occurred when restart mdmonitor
> service, but the system won't re-assemble these RAID0 MD after every
system
> reboot.
> > Do you have any good advice?
> 
> I do now...
> I've just committed the following patch which should suppress the message.
> It will be in mdadm-3.2.6 to be released soon.
> 
> NeilBrown
> 
> 
> 
> 
> 
> From f1661bd71bec6a8ae1919dc32a227c6fb37843f2 Mon Sep 17 00:00:00
> 2001
> From: NeilBrown <neilb@suse.de>
> Date: Wed, 24 Oct 2012 13:09:09 +1100
> Subject: [PATCH] Monitor: don't complain about non-monitorable arrays in
> mdadm.conf
> 
> If we are asked to monitor a RAID0 or Linear - which cannot be monitored -
we
> complain with "Device Disappeared .... Wrong-Level".
> 
> However if the RAID0 or Linear is being requested because it is in
mdadm.conf
> then the message is inappropriate and confusing.
> 
> So track which arrays are added from the config file, and suppress that
> message in that case.
> 
> Reported-by: "Johnson Yan" <johnson_yan@usish.com>
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/Monitor.c b/Monitor.c
> index 69cd8e0..c4d57c3 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -37,6 +37,7 @@ struct state {
>  	int err;
>  	char *spare_group;
>  	int active, working, failed, spare, raid;
> +	int from_config;
>  	int expected_spares;
>  	int devstate[MAX_DISKS];
>  	dev_t devid[MAX_DISKS];
> @@ -178,6 +179,7 @@ int Monitor(struct mddev_dev *devlist,
>  			st->next = statelist;
>  			st->devnum = INT_MAX;
>  			st->percent = RESYNC_UNKNOWN;
> +			st->from_config = 1;
>  			st->expected_spares = mdlist->spare_disks;
>  			if (mdlist->spare_group)
>  				st->spare_group =
xstrdup(mdlist->spare_group); @@
> -475,7 +477,7 @@ static int check_array(struct state *st, struct
mdstat_ent
> *mdstat,
>  	 * have a device disappear than all of them that can
>  	 */
>  	if (array.level == 0 || array.level == -1) {
> -		if (!st->err)
> +		if (!st->err && !st->from_config)
>  			alert("DeviceDisappeared", dev, "Wrong-Level",
ainfo);
>  		st->err = 1;
>  		close(fd);
> 


