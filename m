From: David Greaves <david@dgreaves.com>
Subject: [Fwd: Re: [Evms-devel] md raid5 expand possible yet?]
Date: Mon, 04 Apr 2005 09:07:12 +0100
Message-ID: <4250F5B0.9040700@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is just a potentially interesting forwarded mail from the EVMS 
mailing list to illustrate the kind of issues/responses to the raid5 
resize questions...

David

>
> osni@kiruna.se wrote on 03/01/2005 09:16:51 AM:
>
>> I read in the evms user guide that it should be possible but I can't
>> seem
>> to find where to "add one object to the region". I'm using evms 2.5.2
>> gui...
>>
>> /Oscar
>
> Hi, Oscar.
>
> If you are using evmsn or evmsgui you have to start the expand on the top
> level volume, object, or container that consumes the raid5 region.  For
> example, if raid5 region md/md1 is made into EVMS volume /dev/evms/mydata,
> then you would start by expanding /dev/evms/mydata.  The UI will ask you
> for an "expansion point" which is the object in the volume's stack that
> you
> want to expand.  You should see md/md1 in the list of possible expansion
> points provided there is a free object with enough space that can be added
> to the array.  Select the md/md1 regino to exapnd.  You should then get a
> prompt for the object to be added to md/md1.
>
> Similarly, if md/md1 is consumed by an LVM container you would start by
> expanding the LVM container.  That operation, too, should give you a list
> of possible expansion points.  In this case you will usually see two
> expansion points -- one for the container (you can expand a container by
> adding another object to it) and one for the raid5 region.
>
> If you are using the "evms" command line interface (CLI) you can use a
> command like "expand:md/md1,sdc5".  (I haven't tested that command.  I
> wrote it based on the help.)
>
> Steve D.
>
>
Hi again and thanks for the answer.

It's resizeing now so I hope it works :) But someone should change in the
user guide where it says
"Like RAID-0, RAID-4/5 regions must be deactivated before they are resized."
That was the reason to why I couln't get it to work at first, if it's not
active it can't be resized.

/Oscar


