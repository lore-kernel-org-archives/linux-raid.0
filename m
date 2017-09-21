From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Data recovery
Date: Thu, 21 Sep 2017 16:15:53 +0100
Message-ID: <59C3D7A9.708@youngman.org.uk>
References: <CAEmSg0_=5ni2mA1Q_A1DjZmvjG9u8tKXOQHmnmT33=12yJwYqA@mail.gmail.com>
 <59C309C7.9030300@youngman.org.uk>
 <CAEmSg0-AD09KM=S21a-EVGQEEE0=em-PCpb9LAAbd8cP2+ysBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEmSg0-AD09KM=S21a-EVGQEEE0=em-PCpb9LAAbd8cP2+ysBA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?Vm9qdMSbY2ggS2xldGXEjWth?= <vojta.kletecka@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 21/09/17 09:33, Vojtěch Kletečka wrote:
>> Why are they connected over USB?

> Because the disks are WD Elements Desktop - 2TB, without
> dissassembling connecteable only via usb. Also we thought it might be
> good if we are able to mount them on multiple computers so hence usb.
> Terrible mistake I know..
> 
>> > Raid doesn't like USB. Because USB likes dropping disks and then raid
>> > wonders where the disk has gone - sounds exactly like what's happened to
>> > you!

> I see that now, guess it would be best to either dissassemble the
> disks and put them to computer or use them as regular disks without
> raid.
> 
Another option that might help with what Phil has been suggesting ... if
you want to keep them as portable backup drives (not a bad idea) get a
couple of new drives to stick in a computer, dd or ddrescue the
partitions across, and fix it on the computer in order to do your
recovery (I note that USB seems to have been shuffling your drive order,
making re-assembling the array difficult!).

Amazon have been pushing the Hitachi 7K4000 drive at me, which is a 4TB
drive apparently certified for raid, for only £70! Two of those will
enable you to recover your array, back it up, and then you can decide
what sort of raid or whatever you want to make from those drives. Four
of them would give you a lovely 8TB raid-6 as a store for whatever you
want ... drooolll....

Cheers,
Wol
