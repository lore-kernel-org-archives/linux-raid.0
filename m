From: Can Jeuleers <can.jeuleers@gmail.com>
Subject: Re: Which physical device failed?
Date: Wed, 27 May 2015 20:19:12 +0200
Message-ID: <55660AA0.4030308@gmail.com>
References: <5565B2BB.5090701@gmail.com>	<5565B41B.8040104@aei.mpg.de>	<20150527172701.1090e525@natsu>	<55660373.3030700@youngman.org.uk> <20150527230223.4ef48749@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150527230223.4ef48749@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>, Wols Lists <antlists@youngman.org.uk>
Cc: Carsten Aulbert <Carsten.Aulbert@aei.mpg.de>, Michael Munger <michael.munger@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/05/15 20:02, Roman Mamedov wrote:
>> ata-ST3000DM001-1CH166_W1F4JWRP -> ../../sdb
>> ata-ST3000DM001-1CH166_W1F50K0F -> ../../sda
> 
> From a picture of this model's top side
> http://www.nix.ru/autocatalog/hdd_seagate/126689_2245_draft_large.jpg
> the serial number on this model is 8 alphanumeric characters, so in your case
> W1F4JWRP and W1F50K0F are the serial numbers.

Indeed, and hdparm -i will also tell you.
