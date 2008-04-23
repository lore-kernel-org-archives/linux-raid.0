From: "Ty! Boyack" <ty@nrel.colostate.edu>
Subject: Re: managing raid on linux
Date: Wed, 23 Apr 2008 09:55:18 -0600
Message-ID: <480F5BE6.7070908@nrel.colostate.edu>
References: <247041911@web.de> <480F4EF6.1000103@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <480F4EF6.1000103@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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
>> this should be completely done in kernel space, as some raid drivers do.
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

