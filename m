From: Phil Turmel <philip@turmel.org>
Subject: Re: Storage device enumeration script
Date: Thu, 26 May 2011 14:02:41 -0400
Message-ID: <4DDE95C1.5030401@turmel.org>
References: <4DDDC301.7090608@turmel.org>	<1306403130.9437.109.camel@torbjorn>	<4DDE3BF1.7030105@turmel.org>	<4DDE9213.2070508@turmel.org> <20110526235415.584ae2e2@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110526235415.584ae2e2@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: =?ISO-8859-1?Q?Torbj=F8rn_Skagestad?= <torbjorn@itpas.no>, linux-raid@vger.kernel.org, Roman Mamedov <roman@rm.pp.ru>, John Robinson <john.robinson@anonymous.org.uk>, CoolCold <coolthecold@gmail.com>, =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
List-Id: linux-raid.ids

Hi Roman,

On 05/26/2011 01:54 PM, Roman Mamedov wrote:
> On Thu, 26 May 2011 13:46:59 -0400
> Phil Turmel <philip@turmel.org> wrote:
> 
>> if you just want the latest script:
>>
>> https://github.com/pturmel/lsdrv/raw/HEAD/lsdrv
> 
> I already reported this earlier, but still in this version:
> 
> Traceback (most recent call last):
>   File "./lsdrv", line 274, in <module>
>     probe_block('/sys/block/'+x)
>   File "./lsdrv", line 226, in probe_block
>     dev.phy = probe_device(blkpath+'/device', nodestr)
>   File "./lsdrv", line 193, in probe_device
>     vendor=fileline1(devpath+'/vendor'),
>   File "./lsdrv", line 49, in fileline1
>     fh = open(filename, 'r')
> IOError: [Errno 2] No such file or directory:
> '/sys/devices/platform/floppy.0/vendor'

I used the wrong exception type.  Fix pushed.  Try again?

Phil
