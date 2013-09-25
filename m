From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Best configuration for bcache/md cache or other cache using ssd
Date: Tue, 24 Sep 2013 21:44:45 -0500
Message-ID: <52424E1D.5050007@hardwarefreak.com>
References: <CAH3kUhHrK-TKJD1s_7SvtOz=YnpO82EvMGPv0X8rVAaDcuTO0Q@mail.gmail.com> <CAH3kUhFf11O8a-y5W40ogrKu_XsjGfmi6R4YUmxbYw-McrEvyA@mail.gmail.com> <CACJz6QtDt-5mgtpHr092AyFOxoSoY+V7F8QbiUcDuD5JN7TsMA@mail.gmail.com> <CAH3kUhGNeXbmR+2zk+3KCDSaBfsjLuZQA89tG_C776emw0nSSQ@mail.gmail.com> <523A60DF.5040702@hardwarefreak.com> <CAH3kUhFaXEwR8ym8Vvf3yEODLf6mXOWnCQbk4qgLk7bnaepV3g@mail.gmail.com> <523AAC1F.6050006@hardwarefreak.com> <CAH3kUhG8cKsuG=-aJOuzJOV+5fe46E+QdCMczxghuL-MbWK95Q@mail.gmail.com> <523B1D1C.2070807@mpstor.com> <CAH3kUhF26nE7cro_Kkod6uZzLeEkhLtpDpbtF3ts2_F9hb4bYQ@mail.gmail.com> <523B26E9.30608@mpstor.com> <CAH3kUhE33h=7D6r7KO9VvQRN5qrZS+cadKUBQW8POFYvyGsS3w@mail.gmail.com> <523B3185.3020309@mpstor.com> <523B874D.4050904@hardwarefreak.com> <CAH3kUhH1FqvQX=Sx0s16AtYyOXUJky1p6kW
 AGQrbukFyUhJT1g@mail.gmail.com> <52414D81.4010104@hardwarefreak.com> <524181A6.6050303@NorthTech.US> <52424B46.6000107@hardwarefreak.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52424B46.6000107@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: "Bradley D. Thornton" <Bradley@NorthTech.US>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/24/2013 9:32 PM, Stan Hoeppner wrote:

> This mangled header caused TBird's reply-all to do the following:
> 
> To: Roberto Spadim <rspadim@gmail.com>
> CC: unlisted-recipients:;, Linux-RAID <linux-raid@vger.kernel.org>
> 
> 
> I've never used the feature, but AIUI, this "unlisted-recipients"
> directive in TBird turns all subsequent CCs into BCCs.

Actually, upon further inspection, a BCC header isn't the issue, because
there's not one, just the mangled CC:

Illegal-Object:	Syntax error in CC: address found on vger.kernel.org:
	CC:	unlisted-recipients:;Linux-RAID <linux-raid@vger.kernel.org>
					     ^-missing end of address

vger simply replaced the broken CC header with a syntax error message.
Thus a reply-all to this message will simply go to the sender and the
non-broken CC list, i.e. to me and to Roberto, not the list.

Regardless, the root of the problem lay with Roberto or his MUA for the
original mangled header.

-- 
Stan

