From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID MIA.  Again.  (Kinda.)
Date: Tue, 09 Mar 2010 16:29:12 +0000
Message-ID: <4B967758.60006@anonymous.org.uk>
References: <ef2f0a4210283390480f4adbd9a547de.squirrel@webmail.jots.org>    <20100305075016.51e98363@notabene.brown>    <b305ada429c44b2b62b03c101f7ecf0a.squirrel@webmail.jots.org>    <20100305123028.55a34c14@notabene.brown>    <a65d84c03d315f1aea40641238f25625.squirrel@webmail.jots.org>    <20100306073703.2e44d2f6@notabene.brown> <6efdda840bff85f8b8ec053808afa5dd.squirrel@webmail.jots.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6efdda840bff85f8b8ec053808afa5dd.squirrel@webmail.jots.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ken D'Ambrosio <ken@jots.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/03/2010 14:43, Ken D'Ambrosio wrote:
> On Fri, March 5, 2010 3:37 pm, Neil Brown wrote:
>> mount /dev/md0 /somewhere
>>
>> ??
> 
> Sorry this took so long; I've been busy dying from Martian Death Flu. 
> So... I tried what you suggested.
> 
> And it worked.
> 
> WTF?!
> 
> How can you mount something that doesn't show a partition in fdisk?  I'm
> -very-, -very- confused here.  Grateful, yes, but confused.  Is this
> something I'm just not "getting?"

Yes, I think so. You can potentially make and mount a filesystem on any 
block device. That could be a whole disc or a partition, or it could be 
something else. There are various tools for making new block devices 
over the top of others, for example you can use LVM, md or dm. Then 
there are yet more tools for making block devices out of other stuff, 
like loopback and nbd. All these new block devices may in turn be 
partitioned, but they don't have to be. In fact partitioning is just a 
simple way of splitting a block device up into other smaller block devices.

Cheers,

John.

