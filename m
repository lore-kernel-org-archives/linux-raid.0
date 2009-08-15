From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [mdadm git pull] pending fixes for mdadm 3.0.1
Date: Fri, 14 Aug 2009 17:53:01 -0700
Message-ID: <e9c3a7c20908141753q130e0860kf620af62252f789b@mail.gmail.com>
References: <1249412514.19218.37.camel@dwillia2-linux.ch.intel.com>
	 <19067.42820.630060.102559@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19067.42820.630060.102559@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Jacek Danecki <jacek.danecki@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Hans de Goede <hdegoede@redhat.com>, Doug Ledford <dledford@redhat.com>
List-Id: linux-raid.ids

On Thu, Aug 6, 2009 at 9:02 PM, Neil Brown<neilb@suse.de> wrote:
> On Tuesday August 4, dan.j.williams@intel.com wrote:
>> The following changes since commit fa09d4961e5c72da3c7f78d53a7d64f51=
96110a3:
>> =A0 NeilBrown (1):
>> =A0 =A0 =A0 =A0 Examine: fix --examine --brief --verbose on containe=
rs.
>>
>> are available in the git repository at:
>>
>> =A0 git://github.com/djbw/mdadm.git master
>>
>> Dan Williams (10):
>> =A0 =A0 =A0 teach imsm and ddf what st->subarray means at load_super=
 time
>> =A0 =A0 =A0 fix RebuildMap() to retrieve 'subarray' info
>
> Thanks. =A0I've pulled and pushed them all, but I'm not quite sure of
> this one.
> What metadata information do we want to have in the map file?
> The main use of the map file is for incremental assembly. =A0When we
> find a device, the map file tells us which array/container to attach
> the device to.
> So subarrays probably aren't important in the map file and maybe
> shouldn't be stored there at all???
>
> What was the context where the current behaviour became an issue?

This was noticed when debugging why udev sometimes did not create a
device node for an imsm container.  The fix for that was to update the
container UUID after adding a subarray.  It was during this debug that
I noticed that -Ir would not recreate the same map file as -C, so I
fixed it for consistency.  Now that I look, we are currently using the
mapfile to look up the user-friendly device name for "--detail
--export".  So it is currently needed until we can transition to the
named device support you added in 2.6.29.

>>
>> Hi Neil,
>>
>> This is the same queue that was sent previously [1], but with a few
>> additions:
>
> Sorry I didn't respond to that - late June was a bad time for me :-(

Not a problem.

>>
>>
>> Lastly, I notice that there is a regression of sorts since commit
>> fa09d496 "Examine: fix --examine --brief --verbose on containers".
>> Changing the order of containers and members confuses mdadm -Asc, or=
 -As
>> when /etc/mdadm.conf is present. =A0We now only get the container, a=
nd no
>> members in the multiple container case. =A0Unintended consequence?
>
> Certainly unintended. =A0I guess I had forgotten that the order of
> things in mdadm.conf is important.
> Maybe the best approach would be for Examine.c to call in to the
> metadata handler a second time to get the subarrays.
>
> What would you think of something like the following?

Works for me, and you already committed it because I was too slow to
respond, sorry about that.

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
