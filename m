From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: mdadm remove old md details reassemble working drives
Date: Thu, 26 May 2016 13:41:24 +0200
Message-ID: <20160526114124.GA4028@metamorpher.de>
References: <DB5PR07MB1287BD3F72D4FA302118C075D5410@DB5PR07MB1287.eurprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <DB5PR07MB1287BD3F72D4FA302118C075D5410@DB5PR07MB1287.eurprd07.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bryan Hepworth <bryan.hepworth@newcastle.ac.uk>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, May 26, 2016 at 09:56:24AM +0000, Bryan Hepworth wrote:
> /etc/mdadm.conf
> 
> [root@inscribe5 etc]# cat mdadm.conf
> ARRAY /dev/md/inscribe5.ncl.ac.uk:130 level=raid5 num-devices=12 metadata=1.2 name=inscribe5.ncl.ac.uk:130 UUID=cb850648:d5b35007:dc6000f0:b48ab578
>    devices=/dev/sdb,/dev/sdc,/dev/sdd,/dev/sde,/dev/sdf,/dev/sdg,/dev/sdh,/dev/sdi,/dev/sdj,/dev/sdk,/dev/sdl,/dev/sdm
> ARRAY /dev/md/igmimager.ncl.ac.uk:136 level=raid5 num-devices=12 metadata=1.2 name=igmimager.ncl.ac.uk:136 UUID=b4cb3aaf:e09885cb:6c0ea8bf:a4118a61
>    devices=/dev/sdn,/dev/sdo,/dev/sdp,/dev/sdq,/dev/sdr,/dev/sds,/dev/sdt,/dev/sdu,/dev/sdv,/dev/sdw,/dev/sdx,/dev/sdy

That looks a bit overengineered...

You can reduce the mdadm.conf to just use UUID and nothing else

ARRAY /dev/md0 UUID=cb850648:d5b35007:dc6000f0:b48ab578

Keep the /dev/md/name if you need it but everything else 
(num-devices, metadata, devices, level, ...) is part 
of the metadata, no need to duplicate it in the conf.

There doesn't seem to be a problem with the metadata itself 
(all clean, same update time, same event count) so unless 
the devices get detected late or something it should just work 
when assembling by UUID...

Regards
Andreas Klauer
