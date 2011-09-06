From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 5/9] imsm: fix reserved sectors for spares
Date: Tue, 6 Sep 2011 13:42:45 -0700
Message-ID: <CABE8wwv3Uk1pY_D5aAh49+aaoKi9cwwqv6YoqSHGgjw30iQbOg@mail.gmail.com>
References: <20110826020908.28015.52384.stgit@localhost6.localdomain6>
	<20110826021424.28015.2342.stgit@localhost6.localdomain6>
	<CABE8wwv08oPwU4maaBULCoy993v=uhGny0_gTWFdYHDsoYLvEg@mail.gmail.com>
	<20110830122036.357e63f0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110830122036.357e63f0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Anna Czarnowska <anna.czarnowska@intel.com>, marcin.labun@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

On Mon, Aug 29, 2011 at 7:20 PM, NeilBrown <neilb@suse.de> wrote:
>> Anna rightly points out that this could probably be safely made
>> bigger. =A0As it stands this applies to too broad an array of disks.=
 =A0I
>> think a happy medium (until we can nail down the forward compatibili=
ty
>> of older oroms, v8 in this case) is to detect the case where the dis=
k
>> is being activated for rebuild and if it is at least as large as one
>> of the existing members truncate the reserved region to the same siz=
e
>> as the other member. =A0That way we are at least compatible with
>> whatever agent created the array in the first instance.
>>
>
> I think you are saying that I can go ahead and apply this patch, but =
that it
> might get improved upon in the future .... I hope that is right ?

Yes, this may have corrected things too far in the other direction,
but is less surprising than what we had before.

>> But this also comes back to the problem of duplicating the array
>> configuration. =A0It becomes difficult to make things the same size
>> unless the orom version (reserved region layout) is specified.
>
> Yes, that is occasionally a serious problem. =A0As metadata becomes m=
ore
> flexible it become harder to reproduce exact configuration.
>
> Maybe I need a --no-default option to --create to ensure no defaults =
are used.
> Then some sort of generic
> =A0 =A0--config-param foo=3Dbar
> which creates a dictionary of foo=3Dbar assignments which are used by=
 the
> metadata to fill in any detail that they would normally fill from def=
aults.
>
> Sounds a bit heavy-weight though...

I think having a metadata dump facility covers most the need for
duplicating a configuration.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
