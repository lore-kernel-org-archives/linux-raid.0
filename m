From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: Best configuration for bcache/md cache or other cache using ssd
Date: Tue, 24 Sep 2013 02:06:02 -0300
Message-ID: <CAH3kUhH1FqvQX=Sx0s16AtYyOXUJky1p6kWAGQrbukFyUhJT1g@mail.gmail.com>
References: <CAH3kUhHrK-TKJD1s_7SvtOz=YnpO82EvMGPv0X8rVAaDcuTO0Q@mail.gmail.com>
	<CACJz6QtVzR1bED939ZkesyXMWjv-2DmxZSrGH_enKX5dCuNEJw@mail.gmail.com>
	<CAH3kUhHin5PfjDCNFjD8eypNML=0YrkQp14DrCADc2StcODdaw@mail.gmail.com>
	<CAH3kUhFf11O8a-y5W40ogrKu_XsjGfmi6R4YUmxbYw-McrEvyA@mail.gmail.com>
	<CACJz6QtDt-5mgtpHr092AyFOxoSoY+V7F8QbiUcDuD5JN7TsMA@mail.gmail.com>
	<CAH3kUhGNeXbmR+2zk+3KCDSaBfsjLuZQA89tG_C776emw0nSSQ@mail.gmail.com>
	<523A60DF.5040702@hardwarefreak.com>
	<CAH3kUhFaXEwR8ym8Vvf3yEODLf6mXOWnCQbk4qgLk7bnaepV3g@mail.gmail.com>
	<523AAC1F.6050006@hardwarefreak.com>
	<CAH3kUhG8cKsuG=-aJOuzJOV+5fe46E+QdCMczxghuL-MbWK95Q@mail.gmail.com>
	<523B1D1C.2070807@mpstor.com>
	<CAH3kUhF26nE7cro_Kkod6uZzLeEkhLtpDpbtF3ts2_F9hb4bYQ@mail.gmail.com>
	<523B26E9.30608@mpstor.com>
	<CAH3kUhE33h=7D6r7KO9VvQRN5qrZS+cadKUBQW8POFYvyGsS3w@mail.gmail.com>
	<523B3185.3020309@mpstor.com>
	<523B874D.4050904@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <523B874D.4050904@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Stan,Benjamin, Drew and others guys!
Well i read many things about raid cards now =) thanks stan! i'm not a
expert but at least somethings i understood...

i was thinking about BBU at raid cards...
it's something like bcache with the 'ssd' part as the raid card, and
the hdd part as the raid disks.... different from ssd the raid card
use ram memory (probably) + batery

well now my question is...
there's a memory + bbu 'hard drive'?
i want to use it as the ssd part of the bcache, and use the hdd as my
motherboard hdd connections
in other words... i want the raid card goals with a memory hard drive

any ideas? anyone know anything about it?

thanks guys!

2013/9/19 Stan Hoeppner <stan@hardwarefreak.com>:
> On 9/19/2013 12:16 PM, Benjamin ESTRABAUD wrote:
>
>> MegaRAID is the LSI RAID controller's driver/management software name.
>
> For the young pups here, MegaRAID was the brand name for the hardware
> RAID products sold by American Megatrends Incorporated, AMI, in the
> 1990s.  You just might recognize that name, since most PCs ship with AMI
> BIOS.  AMI sold their RAID division to LSI more than 10 years ago.  They
> also sold their motherboard division though I can't recall to whom.
>
> LSI also purchased Mylex Corp around the same time frame.  Together, AMI
> and Mylex owned over ~70% of the US RAID card market, a large percent of
> the worldwide RAID card market, and had OEM contracts with all of the
> major hardware vendors, including Bull, Data General, DEC, Dell,
> Fujitsu/Siemens, HP, IBM, SGI, SUN, Unisys, etc.  Sometime later they
> also acquired 3Ware, pretty well sewing up the market.
>
> Mylex didn't use any branding, simply model numbers, such as DAC960,
> DAC1100, etc.  So LSI retained the MegaRAID brand and has used it for
> all RAID products to date, as it had wide recognition and is catchy as
> far as branding goes.
>
> --
> Stan
>



-- 
Roberto Spadim
