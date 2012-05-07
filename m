From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: Reason for md raid1 max_sectors_kb limited to 127?
Date: Mon, 07 May 2012 17:33:40 +0200
Message-ID: <4FA7EB54.60305@profitbricks.com>
References: <4FA798D7.4070506@profitbricks.com> <20120507211846.789d5808@notabene.brown> <4FA7B337.7040408@profitbricks.com> <4FA7D678.4080106@itwm.fraunhofer.de> <4FA7D8D2.8030906@profitbricks.com> <CABYL=ToyVwRGOkVs63iBgfWeTsjDQ=ofsYC4hgAVpABrWbHUjA@mail.gmail.com> <4FA7E095.7080909@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FA7E095.7080909@itwm.fraunhofer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: Roberto Spadim <roberto@spadim.com.br>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/05/12 16:47, Bernd Schubert wrote:
> On 05/07/2012 04:44 PM, Roberto Spadim wrote:
>> could check if it have any performace increase? maybe i consider
>> upgrading my kernel to get more performace inn raid1
>>
> 
> Depends on your hardware. Hardware that can handle small IO sizes, such
> as common hard disks usually don't have problems with 512KB IOs. But if
> you should use software on top of hardware raid large IOs might be very
> important (again depends on the hw-raid vendor then).
> 
> 
> Cheers,
> Bernd

O.K., I've also tested 3.2.16 and there the problem still exists.
Bernd pinpointed me to commit b1bd055d397e09f99dcef9b138ed104ff1812fcb
(block: Introduce blk_set_stacking_limits function).

After cherry-picking it on 3.2.16 it worked. Tomorrow I'll test the
performance impact and verify it by block tracing.

Cheers,
Sebastian
