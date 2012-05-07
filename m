From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: Reason for md raid1 max_sectors_kb limited to 127?
Date: Mon, 07 May 2012 16:47:49 +0200
Message-ID: <4FA7E095.7080909@itwm.fraunhofer.de>
References: <4FA798D7.4070506@profitbricks.com> <20120507211846.789d5808@notabene.brown> <4FA7B337.7040408@profitbricks.com> <4FA7D678.4080106@itwm.fraunhofer.de> <4FA7D8D2.8030906@profitbricks.com> <CABYL=ToyVwRGOkVs63iBgfWeTsjDQ=ofsYC4hgAVpABrWbHUjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABYL=ToyVwRGOkVs63iBgfWeTsjDQ=ofsYC4hgAVpABrWbHUjA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Sebastian Riemer <sebastian.riemer@profitbricks.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/07/2012 04:44 PM, Roberto Spadim wrote:
> could check if it have any performace increase? maybe i consider
> upgrading my kernel to get more performace inn raid1
>

Depends on your hardware. Hardware that can handle small IO sizes, such 
as common hard disks usually don't have problems with 512KB IOs. But if 
you should use software on top of hardware raid large IOs might be very 
important (again depends on the hw-raid vendor then).


Cheers,
Bernd
