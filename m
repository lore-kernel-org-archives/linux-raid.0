From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 11/11] async_tx: raid6 recovery self test
Date: Wed, 3 Jun 2009 14:42:17 -0700
Message-ID: <e9c3a7c20906031442y487ad504t1bce8976aad90b42@mail.gmail.com>
References: <20090519005647.4104.81119.stgit@dwillia2-linux.ch.intel.com>
	 <20090519010022.4104.8698.stgit@dwillia2-linux.ch.intel.com>
	 <20090522082923.GO11504@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090522082923.GO11504@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 22, 2009 at 1:29 AM, Andre Noll <maan@systemlinux.org> wrot=
e:
> On Mon, May 18, 2009 at 06:00:22PM -0700, Dan Williams wrote:
>> +static char disk_type(int d)
>> +{
>> + =A0 =A0 switch (d) {
>> + =A0 =A0 case NDISKS-2:
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 'P';
>> + =A0 =A0 case NDISKS-1:
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 'Q';
>> + =A0 =A0 default:
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 'D';
>> + =A0 =A0 }
>> +}
>
> I like this function very much because "if (disk_type(faila) =3D=3D '=
Q')"
> is so much more readable than "if (faila =3D=3D num_disks - 1)". It's=
 a
> pity that we only have it in this test module ;)

I do not see too many places outside this file where it would be
helpful... but an incremental patch for this cleanup would be welcome.
 In general this code tries to duplicate the look of
drivers/md/raid6test/test.c, so any cleanups would be applicable in
both locations.

> How hard would it be to also test the fallback code for the synchrono=
us
> paths? AFAICS this test module wouldn't notice errors in the fallback
> logic.

It does.  Simply omit loading an offload driver and the api will by
necessity fallback to the synchronous path.

Thanks,
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
