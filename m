From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [mdadm git pull] Intel metadata and mapfile fixes for mdadm-3.0.1
Date: Mon, 29 Jun 2009 10:34:21 -0700
Message-ID: <e9c3a7c20906291034h14bebc9cwb479e2634850ccc4@mail.gmail.com>
References: <1245203203.3668.13.camel@dwillia2-linux.ch.intel.com>
	 <19001.55121.865711.172936@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19001.55121.865711.172936@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Ed Ciechanowski <ed.ciechanowski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Jun 17, 2009 at 10:57 PM, Neil Brown<neilb@suse.de> wrote:
> On Tuesday June 16, dan.j.williams@intel.com wrote:
>> Hi Neil,
>>
>> The following changes since commit 6e92d480f765dc22a5abaa5658ad60335=
3648c1c:
>> =A0 NeilBrown (1):
>> =A0 =A0 =A0 =A0 Release mdadm-3.0
>>
>> are available in the git repository at:
>>
>> =A0 git://github.com/djbw/mdadm.git master
>>
>
> Thanks. =A0However.....
>
>> Dan Williams (6):
>> =A0 =A0 =A0 fix RebuildMap() to retrieve 'subarray' info
>
> This hides two totally different changes in the one patch, which is
> never a good idea.

Yes.  I removed the second fix.  Also, validation found a bug in
set_member_info so I needed to respin this patch.

> I'm not at all convinced about the
>
> =A0 =A0For imsm we need an additional fixup to force local naming oth=
erwise
> =A0 =A0RebuildMap() will always choose foreign names.
>
> bit. =A0Maybe if you could explain that.

I took a second look and have decided to drop this hack in favor of
requiring a configuration file in order to get local naming with Intel
metadata.  This patch would have degraded the protection afforded by
explicitly naming arrays in mdadm.conf.  The end result being that you
will see the following result if the configuration file and the
symlink created at Assemble() or Create() are removed:

# cat /var/run/mdadm/map
md127 imsm 53d6f8b1:7a783f24:f30483c5:705c48c7 /dev/md/imsm0
md126 /md127/0 aba8e22d:83f5033c:32ca5b1e:9579732d /dev/md/vol0
# rm /dev/md/vol0
# rm /etc/mdadm.conf
# mdadm -Ir
# cat /var/run/mdadm/map
md127 imsm 53d6f8b1:7a783f24:f30483c5:705c48c7 /dev/md/imsm0
md126 /md127/0 aba8e22d:83f5033c:32ca5b1e:9579732d /dev/md/vol0_0

>> =A0 =A0 =A0 teach imsm and ddf what st->subarray means at load_super=
 time
>> =A0 =A0 =A0 fix examine_brief segfault
>> =A0 =A0 =A0 imsm: fixup examine_brief to be more descriptive in the =
container only case
>
> Those seem OK.
>
>> =A0 =A0 =A0 fixup map file after Create
>
> This one bothers me too. =A0If there is a need to update the mapfile,
> then we should perform the required update, e.g. with map_update.
> What exactly is needed here?

I overlooked map_update.

What is needed here is a refresh of the map_file after adding the
first member array to an Intel metadata container.  The uuid for an
imsm container uses the ->family_num field of the metadata.  This
field is static, but is only set after the first member array has been
created.  Prior to this all devices are free floating spares and do
not have any information that can identify specific container
membership.  At Create() time we take the uninitialized uuid from
->get_info_super() prior to updating the metadata.  So the current
result is:

# mdadm --create /dev/md/imsm /dev/sd[b-e] -n 4 -e imsm
# mdadm --create /dev/md/vol0 /dev/md/imsm -n 4 -l 0
# cat /var/run/mdadm/map
md126 /md127/0 3e03aee2:78c3c593:1e8ecaf0:eefb53ed /dev/md/vol0
md127 imsm 53d6f8b1:7a783f24:f30483c5:705c48c7 /dev/md/imsm
# mdadm -Ebs
ARRAY metadata=3Dimsm UUID=3D589d2d2c:4221a54d:acb63c06:c3907f52
ARRAY /dev/md/vol0 container=3D589d2d2c:4221a54d:acb63c06:c3907f52
member=3D0 UUID=3D57b89b63:5cd0eae1:17dd26b3:51cc78d4

RebuildMap() is a big hammer, but it has the nice side effect of
updating the member array uuid and the container.  I can use
map_update(), but I will probably also need to call ->load_super()
again so I can update the container uuid.

>
>
>> =A0 =A0 =A0 imsm: fix activate_spare off-by-one
>
> I would have fixed this by simply changing the '<' to '<=3D', but you=
r
> fix is OK, and esize can certainly go.
>
> So for now I haven't pulled any of this.

Ok, I will rework the map fixup patch then we can see if we are on the
same page.

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
