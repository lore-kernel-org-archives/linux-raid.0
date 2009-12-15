From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [GIT PATCH 0/2] external-metadata recovery checkpointing for
	2.6.33
Date: Mon, 14 Dec 2009 21:19:38 -0700
Message-ID: <e9c3a7c20912142019j280a243csf8c39a73fc3d0b06@mail.gmail.com>
References: <20091213041123.12532.15225.stgit@dwillia2-linux.ch.intel.com>
	 <20091214150725.49de72f1@notabene.brown>
	 <1260837478.23193.33.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1260837478.23193.33.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Dec 14, 2009 at 5:37 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> On Sun, 2009-12-13 at 21:07 -0700, Neil Brown wrote:
>> +static ssize_t recovery_start_store(mdk_rdev_t *rdev, const char *b=
uf, size_t len)
>> +{
>> + =A0 =A0 unsigned long long recovery_start;
>> +
>> + =A0 =A0 if (cmd_match(buf, "none"))
>> + =A0 =A0 =A0 =A0 =A0 =A0 recovery_start =3D MaxSector;
>> + =A0 =A0 else if (strict_strtoull(buf, 10, &recovery_start))
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> +
>> + =A0 =A0 if (rdev->mddev->pers &&
>> + =A0 =A0 =A0 =A0 rdev->raid_disk >=3D 0)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -EBUSY;
>
> Ok, I had a chance to test this out and have a question about how you
> envisioned mdmon handling this restriction which is a bit tighter tha=
n
> what I had before. =A0The prior version allowed updates as long as th=
e
> array was read-only. =A0This version forces recovery_start to be writ=
ten
> at sysfs_add_disk() time (before 'slot' is written). The conceptual
> problem I ran into was a race between ->activate_spare() determining =
the
> last valid checkpoint and the monitor thread starting up the array:
>
> ->activate_spare(): read recovery checkpoint
> ( array becomes read/write )
> ( array becomes dirty, checkpoint invalidated )
> sysfs_add_disk(): write invalid recovery checkpoint
> ( recovery starts from the wrong location )

On second thought, if we get to activate_spare() it's already too
late.  Moving this to mdadm at assembly time (prior to setting
readonly) is a better approach.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
