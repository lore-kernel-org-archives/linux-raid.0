From: "David Lethe" <david@santools.com>
Subject: RE: managing raid on Linux
Date: Wed, 23 Apr 2008 13:17:19 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C1964CC@34093-C3-EVS3.exchange.rackspace.com>
References: <247041911@web.de> <480F4EF6.1000103@tmr.com> <480F5BE6.7070908@nrel.colostate.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <480F5BE6.7070908@nrel.colostate.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Ty! Boyack <ty@nrel.colostate.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here are the dirty-little-secret reasons why an uber-manager does not,
and will not exist. (including reason why SMI-S basically limited to the
big-box high-dollar external RAID)

* Several such products were proposed an died either early or deep into
development.  DDF, for example, was to be a common API and Disk Data
Format (hence DDF) that a large number of vendors, including myself when
I was with another company Adaptec, and several other vendors, including
me, got into.  We recognized that you couldn't have consistent
monitoring/diags without a common layout.  DDF would have let you take
disks with live data and RAID5/RAID6 structures and plug them into a
DDF-compliant adapter. It was a failure, in my opinion, due to politics
from the manufacturers.  Not even Dell & Intel, who were the biggest
proponents, could entice the RAID manufacturers to come together.

* There are some ANSI specs on the T10.org site related to common APIs,
as well as vendors such as Chaparral (now dot hill) which published
extremely open APIs.  No other vendors adopted them.  (I can't comment
on whether reasons were political or engineering .. but as an engineer
who has been involved with controller development and analyzing
suitability of the published APIs, I speak for myself when I say they
were unsuitable for the controller architecture I was working on at the
time)

* SMI-s is a huge pig from perspective of PC-based RAID controllers, and
it adds a significant cost to the controllers in terms of necessary CPU
power, memory, more sophisticated threading, and all the integration
costs.  That is why you'll likely never see SMI-S embedded in anything
that physically plugs into a PCI slot that doesn't cost thousands of
dollars.  Aside from the increased hardware costs, consider the
additional RFI, BTUs, and real-estate on the board.   It isn't
practical.

* One *could* write a general SMI-S agent, but that has a whole other
set of problems I don't need to go into. That's why you don't see SMI-S
agents for all or perhaps any of the RAID controllers the OP has. 

* As for an ubermanager that does the common internal cards, i.e.,
Adaptec, LSI, Infortrend, HP, Dell, AMCC/3WARE, Promise, Highpoint,
Intel RAID, etc ... then  I am aware of one, but it will only support a
subset of these cards.  As my company does just what the OP asked for,
here re some reasons why WE don't support everything:
 - APIs for all of these are closed source, so you are limited to
compiled software, which necessitates limitations on kernels, platforms,
32/64bit, etc.  A vendor who goes down this path also has to be a
software-only vendor and go through NDA.  Manufacturer "A" isn't going
to give an API to a vendor that potentially sells product from one of
their competitors, so even obtaining APIs can be difficult.
 - Some of the vendor APIs provide source code, others provide object
code and headers that have to be linked into executables.  This
necessitates additional constraints.

  - Firmware, driver, API updates can break the management software, so
it is a constant battle ... an don't get me started on some changes to
the Linux kernel that people reading the list have made which breaks
RAID drivers/management software :)

  - Some management functions can block the RAID controller, or can
conflict with any currently-installed management daemons, drivers, or
application software.  The 3rd-party developer and manufacturer have to
have clear understanding on rules of conflict.

  - Some HBAs (surprisingly) have incredibly weak/limited APIs, and
there isn't much you can do with them.  Also you have to be really
careful not to use the API to send code that could either break the API,
crash the system, or lock up the RAID.

  - Sometimes the RAID vendor doesn't have a published API, or
documentation is wrong, so the manufacturer has to burn engineering and
FAE time to work with the software vendor.  Let alone the extra work
for the software vendor.

  - Most of these manufacturers have "specials" for OEMs where they
tweak the firmware, or change the identification strings, so that there
are multiple flavors of the same thing.  The API may or may not work, or
have bugs related to this.  Sometimes the OEM doesn't even know about
the API or compatibility issues, or they farmed out software, so this
makes it difficult and sometimes not-worth-the-effort for a software
vendor to bother with particular controller.

   Well, this is the norm. While some APIs are well done, the other
extreme is that vendor xyz farmed out the API/drivers to another
company, and the hardware vendor doesn't have the resources, knowledge
or experience to provide the information necessary to bring a 3rd-party
management tool to market.   I will certainly not reveal anything about
the companies that did farm out the software/firmware to 3rd parties,
and will not tell you if their names were mentioned in this post.
Suffice to say that this is a real problem with SOME controllers that
people reading this post have installed in their computers.

  - The economics of developing support for a particular controller is a
severe constraint.  Consider the reasons above, and then add simple
equipment costs for development/testing, and then support.  I'm not
going to add support for product xyz unless I know it will be
profitable, and even a hundred end-user requests won't begin to pay for
such an effort.

  - I for one certainly can't keep up with all the new things coming
out, so we choose our battles wisely based on the market opportunity,
longevity of the controller platform, safety/robustness of the API, and
development/ongoing support expense.

So there are the reasons why the OP can't find anything that supports
everything he has.

Suggestions for the OP
 - awk, /proc, vendor-specific command-line utilities, and a big fat
shell or perl script.  

David @ SANtools ^ com


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Ty! Boyack
Sent: Wednesday, April 23, 2008 10:55 AM
To: linux-raid@vger.kernel.org
Subject: Re: managing raid on linux

I'm not quite "hardware flavor of the month" but I still feel like I've 
got all 31 flavors around the shop.

Something you might look into is SMI-S (Storage Management Initiative - 
Specification), which is being promoted by SNIA (Storage Network 
Industry Association):

http://www.snia.org/tech_activities/standards/curr_standards/smi/

The goal is to provide a single management protocol/API for any 
traditional storage hardware (including arrays, switches, NAS devices, 
tape libraies, etc.).  As I understand it, there are hooks for the 
standard operations and monitoring, and extensibility for specialized 
devices.

While it has been targeted at SAN hardware, it would seem that the array

management features could be used on their own in your case, if your 
arrays support this.  There are some open source projects working on 
providing a management tool for these devices.  It's been on my horizon 
for a while, but I have not had the chance to really look into it from a

practical sense.  So I don't know if it is exactly what you might need, 
but it could be worth exploring.

(I know it's WAY outside of the kernel space tools you mentioned, but it

is a mature option)

-Ty!



Bill Davidsen wrote:
> devzero@web.de wrote:
>> Hello !
>>
>> since we use lots of servers with raid where i work, for every system

>> i need to go trough that hassle to find out, how to monitor the state

>> of the raid array.
>>
>> if you you have more than one brand of raid controller, you really 
>> need a large amount of time to find the proper tool for this, if you 
>> think you found it, then you have a broken link or the wrong version,

>> the tool is outdated, doesn`t work with recent controller versions, 
>> is tricky to setup or difficult to use.
>>
>> this takes a lot of time and is a major annoyance.
>>
>> isn`t there a linux project which is adressing this?
>> some site for the sysadmin to consult?
>> i have raid controller xyz, what do i need to monitor the arrays 
>> state....?
>>
>> i would expect, that the linux kernel would provide sort of a 
>> standardized way to check the health state of a raid array - i.e. 
>> this should be completely done in kernel space, as some raid drivers
do.
>>
>> instead i need to use a dozen different tools, which are often closed

>> source, too.
>>
>> anybody suffer from that headaches, too ?
>>   
>
> You have that option, set your controllers to JBOD and use software 
> raid. Most people don't play "flavor of the month" with hardware, and 
> those of us who let purchasing alter hardware specs to "save money" 
> use software raid.
>


-- 
-===========================-
  Ty! Boyack
  NREL Unix Network Manager
  ty@nrel.colostate.edu
  (970) 491-1186
-===========================-

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


