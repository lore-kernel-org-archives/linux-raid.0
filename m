From: Luca Berra <bluca@comedia.it>
Subject: Re: RAID 1 resync with both members good.
Date: Fri, 8 May 2009 08:07:33 +0200
Message-ID: <20090508060733.GA7759@maude.comedia.it>
References: <3D76E016F4A2A749A1EB1A3FD83E22BC02783863@uk-email.terastack.bluearc.com> <a93e6da36d0a72953e6a2cce74323e2d.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a93e6da36d0a72953e6a2cce74323e2d.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 08, 2009 at 10:32:01AM +1000, NeilBrown wrote:
>On Thu, May 7, 2009 6:08 pm, Simon Jackson wrote:
>> Could someone help me understand why I am seeing the following
>> behaviour?
>>
>> We use a pair of disks with 3 RAID1 partitions inside an appliance
>> system.
>>
>> During testing we have seen some instances of the RAID devices resyncing
>> even though both members are marked as good in the output of
>> /proc/mdstat.
>
>That is exactly as expectedc.
>If one of the devices had failed and was being replaced by a spare, you
>would see "recovery" not "resync".
>
>Resync happens after an unclean shutdown.
>In that case, both drives have good data, but they might not be the same.
>The resync makes sure that all copies have exactly the same data.
>
>So you there must have been an unclean shutdown before the most recent
>restart.

or a stupid udev rule that gets incremental assembly wrong

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
