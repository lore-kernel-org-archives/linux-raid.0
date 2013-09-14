From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: Inoperative array shown as "active"
Date: Sat, 14 Sep 2013 01:25:11 -0500
Message-ID: <52340147.9090600@gmail.com>
References: <l10sq0$e24$1@ger.gmane.org> <20130914155912.5ba135d9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130914155912.5ba135d9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/14/2013 12:59 AM, NeilBrown wrote:
> On Sat, 14 Sep 2013 00:39:20 -0500 Ian Pilcher <arequipeno@gmail.com> wrote:
>> AFAICT, this means that there is no single item in either /proc/mdstat
>> or sysfs that indicates that an array such as the example above has
>> failed.  My program will have to parse the RAID level, calculated the
>> number of failed members (if any), and determine whether that RAID level
>> can survive that number of failures.  Is this correct?
> 
> Yes.
> 
>>
>> Anything I'm missing?
> 
> mdadm already does this for you. "mdadm --detail /dev/md0".
> 

Yeah, I haven't yet ruled out calling out to mdadm.  I'm already doing
that with hddtemp and smartctl.  It just seems a bit inefficient to do
so when all of the information is sitting right there in /proc/mdstat.

A quick test reveals that running "mdadm --detail /dev/md?*" takes
around 2 seconds on the NAS and produces about 20KB of output.  (I have
20 RAID devices -- hooray GPT! -- and an Atom processor.)  Hmmm.

Thanks for the very quick response!

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
Sometimes there's nothing left to do but crash and burn...or die trying.
========================================================================
