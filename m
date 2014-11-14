From: DeadManMoving <sequel@neofreak.org>
Subject: Re: failed RAID 5 array
Date: Fri, 14 Nov 2014 10:53:34 -0500
Message-ID: <1415980414.4241.49.camel@lappy.neofreak.org>
References: <1415807882.4241.36.camel@lappy.neofreak.org>
	 <54653735.90007@turmel.org> <1415971164.4241.38.camel@lappy.neofreak.org>
	 <546606D4.5070406@turmel.org> <1415974131.4241.41.camel@lappy.neofreak.org>
	 <5466173F.2060007@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5466173F.2060007@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, DeadManMoving <sequel@neofreak.org>
List-Id: linux-raid.ids

Hi Phil,

On Fri, 2014-11-14 at 09:52 -0500, Phil Turmel wrote:
> Hi Tony,
> 
> {Convention on kernel.org is to trim posts & bottom or interleave posts}
> 

Thanks a lot for the advice.

> 
> Indeed.
> 
> At this point, I would use --create --assume-clean, along with
> "missing".  You have a recent enough mdadm to specify
> --data-offset=2048, which you definitely need.  Something like:
> 
> mdadm --create /dev/mdX --assume-clean --data-offset=2048 \
> 	--level=5 --raid-devices=4 --chunk=512 \
> 	missing /dev/sd{f,i,h}
> 
> You should verify the Device Role numbers with mdadm -E again, as your
> drive letters have changed from the initial report.  To be absolutely
> sure, I suggest you record drive serial numbers for each role #.  Also
> note the use of braces instead of square brackets--bash re-orders the
> latter, and that would break your array.  For this type of recovery, it
> is vital that the devices be listed precisely in device role order,
> starting with zero.
> 
> After creation, verify that the space before and space after stats for
> each device match the original report, before fsck or mount.
> (--data-offset controls space before, that plus --size controls space
> after.)


That is my plan to closely look at devices role to ensure proper order
in array creation. To avoid any mistake, i was planning to
use /dev/sda /dev/sdb /dev/sdc syntax instead of /dev/sd{a,b,c}, it's
probably the same, is it not?

Like said in my original post, i am making duplicate copies of each
disk, just to be extra safe. I already did it for two disks i have on
hands. I have ordered and waiting for two other drives to come in. As
soon as the copies will be done for the two other disks, i will try that
procedure. I will use the --data-offset parameter as you suggest.


Thank you so much for your help!

Tony


