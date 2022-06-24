Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C53C43334
	for <linux-raid@archiver.kernel.org>; Fri, 24 Jun 2022 14:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbiFXOyg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Jun 2022 10:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbiFXOyH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Jun 2022 10:54:07 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 953F681703
        for <linux-raid@vger.kernel.org>; Fri, 24 Jun 2022 07:49:55 -0700 (PDT)
Received: from host86-158-155-35.range86-158.btcentralplus.com ([86.158.155.35] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1o4kd7-00041J-DA;
        Fri, 24 Jun 2022 15:49:53 +0100
Message-ID: <92378403-adf6-dedb-828c-81b331c1d8c1@youngman.org.uk>
Date:   Fri, 24 Jun 2022 15:49:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: moving a working array
Content-Language: en-GB
To:     Wilson Jonathan <i400sjon@gmail.com>,
        o1bigtenor <o1bigtenor@gmail.com>,
        Linux-RAID <linux-raid@vger.kernel.org>
References: <CAPpdf595_7eW8amX8eueMxgjaWvLW-hWHh1SHHaGAt8YyP7yDw@mail.gmail.com>
 <7683b644cf076f8db06d60fdd3e4f88424f35bd2.camel@gmail.com>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <7683b644cf076f8db06d60fdd3e4f88424f35bd2.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 24/06/2022 15:09, Wilson Jonathan wrote:
> On Fri, 2022-06-24 at 08:38 -0500, o1bigtenor wrote:
>> Greetings
>>
>> I have a working (no issues) raid-10 array in one box.

Bummer. It's a raid-10. A raid-1 would have been easier.
>>
>> Want to move it to another (new) box.
>>
>> Please - - - a list of the software steps?
>>
>> (the physical moving is the easy part - - - the new box has room
>> for a lot of drives and is ready for these 4 easily)
>>
>> Just don't want a fubar situation because I've taken the wrong order
>> or even wrong steps.
> 
> First make a backup...
> 
> Second check the backup...
> 
> Third make another backup...
> 
> Fourth check that backup as well...

Seconded. And thirded and fourthed.

Actually, that might not be necessary ...
> 
> Move disks... (I personally have just amended the /etc/mdadm/mdadm.conf
> file to include the uuid prior to moving disks and been good to go. BUT
> if I'd have lost all the data, without backups, I'd not have been
> fussed as it could all have been recreated/downloaded so I guess it all
> depends on how important or unique the data is.)
> 
> But if you've got a new machine, why not get new disks and set up a
> nice new clean raid and then just rsync the data accross. That way your
> old disks become the backup, to the data you've newly transfered to
> clean a clean array.
> 
Yup. Do you need the old disks in your new system? If not, DON'T MOVE 
THEM and they'll be your backup.
>>
>> The section 'using the array' has information but I'm not sure how
>> that will work moving from one box to the other.
>>
>> (One question would be if the uuid of the array will remain the same
>> as that would make things easier - - - I could copy the uuid from the
>> existing and then just do the # mdadm --scan --assemble --uuid=
>> blahblah )
>>
Yup. If you move the disks, the UUID won't change.

What I went and did - which took some down-time because it was a pretty 
big array ... was to create my new array on new disks in the new system.

Then I can't remember the syntax - I looked it up on the web - but I 
just did a

cat //old-system/dev/old-array | network > //new-system/dev/newarray

So you're basically copying your filesystem across the network from the 
old "disk" (array, actually) to the new equivalent on the new system.

Worked a treat, apart from the time it took ...

A major reason I went that route, rather than an rsync or whatever, is 
that my system has hard-links all over the place, and while the various 
filesystem copying mechanisms CAN handle it, they don't like it ... a 
device copy simply doesn't need to know anything about it.

Cheers,
Wol
