From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Proper partition type for components with V1.x superblocks?
Date: Mon, 07 Jul 2008 10:32:02 -0700
Message-ID: <48725312.6090201@zytor.com>
References: <484F9A3E.7020709@rabbit.us>	<18512.25940.653867.623185@notabene.brown>	<486BFB03.7060100@zytor.com>	<1215062276.14196.6.camel@firewall.xsintricity.com> <18545.35548.800516.532854@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18545.35548.800516.532854@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Thursday July 3, dledford@redhat.com wrote:
>> On Wed, 2008-07-02 at 15:02 -0700, H. Peter Anvin wrote:
>>> Why 0xDA?
>>>
>>> As far as I know, the closest thing there is to a registry is the list 
>>> that aeb at least used to maintain.
> 
> Yes. 
> http://www.win.tue.nl/~aeb/partitions/partition_types-1.html
> lists 0xDA as
> 
>     da Non-FS Data
> 
>         Added on request of John Hardin (johnh@aproposretail.com).
> 
> which is the closest we could come to "you won't want to look at
> or do anything to this partition".
> 

But that's not really what it is, either.  The best would be to pick a 
new partition identifier entirely.

	-hpa
