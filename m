From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 4/4] md: Enable takeover for external metadata
Date: Wed, 10 Feb 2010 10:36:25 -0700
Message-ID: <e9c3a7c21002100936p279cddbr1a3d478267e5589b@mail.gmail.com>
References: <F2A46F4A087B8547923AD59C289DC90E01D16228@irsmsx002.ger.corp.intel.com>
	 <20100201110829.5516c80e@notabene.brown>
	 <F2A46F4A087B8547923AD59C289DC90E01DCD389@irsmsx002.ger.corp.intel.com>
	 <20100210165710.11493bc5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100210165710.11493bc5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Trela, Maciej" <Maciej.Trela@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Tue, Feb 9, 2010 at 10:57 PM, Neil Brown <neilb@suse.de> wrote:
> On Wed, 3 Feb 2010 12:29:53 +0000
> "Trela, Maciej" <Maciej.Trela@intel.com> wrote:
>
>>
>> This is one more patch for md takeover that was accidentally skipped=
 while sending...
>> Please, apply it together with the rest of md takeover patches.
>>
>> Now md will notify mdmon about the level change.
>> Also sysfs redundancy_group specific to non-raid0 is now handled whe=
n switching personalities.
>>
>
>
> Thanks for these.
>
> You should get into the habit of checking your patches
> with ./scripts/checkpatch.pl. =A0There was lots of stray white space =
and
> various other issues. =A0I have fixed them. =A0You can find the curre=
nt patches
> in my "md-scatch" branch:
> =A0http://neil.brown.name/git?p=3Dmd;a=3Dshortlog;h=3Drefs/heads/md-s=
cratch
>
> I also fixed some other little issues like the fact that you don't wa=
nt to
> set ->delta_disks when converting between RAID0 and RAID5.
>
> I think there are still some issues with error handling if kzalloc fa=
ils
> while allocating the new 'private' structures. =A0 I'll have another =
run
> through the patches in a few days and see what else I can fix it.
>
> I seem to have misplaced the mdadm patches. =A0If you would like to s=
end those
> again I will have a look and possibly apply them.

I believe one thing that still needs investigation, before turning on
the mdadm imsm support, is to see if we need superblock specific
migration strategies in the kernel.  Unless we are incredibly lucky I
do not think the native migration strategy will line up with what the
option-rom expects from a checkpoint interpretation standpoint.
Maciej, any comments on this aspect of the compatibility?

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
