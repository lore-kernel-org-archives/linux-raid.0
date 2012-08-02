From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Subject: Re: OT: silent data corruption reading from hard drives
Date: Thu, 02 Aug 2012 10:13:55 -0700
Message-ID: <501AB553.2030003@aeoncomputing.com>
References: <50191ADE.10809@fastmail.fm> <5019D052.4000409@hardwarefreak.com> <20120802091917.32fb0ca5@natsu> <501A316C.3020305@hardwarefreak.com> <20120802140634.6f729d07@natsu> <1343926790.28421.140661109896017.1A222237@webmail.messagingengine.com> <CABYL=TpDU0YD4orJqyZzeYPtUJ+vBEeM=CWhFxa4GWGj8SjGMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABYL=TpDU0YD4orJqyZzeYPtUJ+vBEeM=CWhFxa4GWGj8SjGMQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The only ways I know of to currently detect/repair silent data=20
corruption are via the use of T10-DIF on SAS drives with 520-byte=20
sectors and embedded per block CRCs (bytes 513-520) or via a patented=20
algorithm used in a commercial Linux software RAID product=20
(www.streamscale.com).

Neither approach is cost effective for small or personal use RAID=20
applications.


On 8/2/12 10:04 AM, Roberto Spadim wrote:
> well i think the integrity is know, but it=B4s not fully needed since
> the security isn=B4t a problem we can buy secure sata/sas
> controlers/disks
> the main problem will be in some days when we are using SoC systems
> and we only have USB to connect a harddrive... maybe when this become
> more popular we will see a development of a module to have data
> integrity (silient corruption detection and maybe repair)
>

--=20
------------------------------
Jeff Johnson
Manager
Aeon Computing

jeff.johnson@aeoncomputing.com
www.aeoncomputing.com
t: 858-412-3810 x101   f: 858-412-3845
m: 619-204-9061

/* New Address */
4170 Morena Boulevard, Suite D - San Diego, CA 92117

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
