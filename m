From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Which physical device failed?
Date: Wed, 27 May 2015 19:38:53 +0100
Message-ID: <55660F3D.7020708@youngman.org.uk>
References: <5565B2BB.5090701@gmail.com>	<5565B41B.8040104@aei.mpg.de>	<20150527172701.1090e525@natsu>	<55660373.3030700@youngman.org.uk> <20150527230223.4ef48749@natsu> <55660AA0.4030308@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55660AA0.4030308@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Can Jeuleers <can.jeuleers@gmail.com>, Roman Mamedov <rm@romanrm.net>
Cc: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>, Michael Munger <michael.munger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/05/15 19:19, Can Jeuleers wrote:
> On 27/05/15 20:02, Roman Mamedov wrote:
>>> ata-ST3000DM001-1CH166_W1F4JWRP -> ../../sdb
>>> ata-ST3000DM001-1CH166_W1F50K0F -> ../../sda
>>
>> From a picture of this model's top side
>> http://www.nix.ru/autocatalog/hdd_seagate/126689_2245_draft_large.jpg
>> the serial number on this model is 8 alphanumeric characters, so in your case
>> W1F4JWRP and W1F50K0F are the serial numbers.
> 
> Indeed, and hdparm -i will also tell you.
> 
ashdown by-id # hdparm -i /dev/sda
bash: hdparm: command not found

:-)

Just emerged it and yes, lots of useful info thanks.

Cheers,
Wol
