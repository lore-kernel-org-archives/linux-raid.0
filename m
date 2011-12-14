From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/3] Create: Allow to create two volumes of different
 sizes within one container
Date: Wed, 14 Dec 2011 10:15:38 -0800
Message-ID: <CAA9_cmfp3i6yUptDT4=afuj3hfUPkwDhtjKGoF=-xo+TUi2Vqw@mail.gmail.com>
References: <20110919165220.9239.2939.stgit@gklab-128-192.igk.intel.com>
	<20110919165230.9239.4775.stgit@gklab-128-192.igk.intel.com>
	<20110921133123.05d03613@notabene.brown>
	<CAA9_cmdkRFqUzj3rdOmNWhTBg=8Wk+LEoaPozawdjQvF0YGb7g@mail.gmail.com>
	<20110921165500.2df0b15e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110921165500.2df0b15e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Lukasz Orlowski <lukasz.orlowski@intel.com>, linux-raid@vger.kernel.org, "Kwolek, Adam" <adam.kwolek@intel.com>
List-Id: linux-raid.ids

[ reviving old thread given the recent patch from Adam [1]]

On Tue, Sep 20, 2011 at 11:55 PM, NeilBrown <neilb@suse.de> wrote:
>> Yeah, the changelog is backwards, and this breaks tests/08imsm-overl=
ap
>> because it does not honor IMSM_NO_PLATFORM. =A0How about the attache=
d?
>
> Better (though text/plain attachments are preferred over
> application/octet-stream....)

Yeah, gmail picked that unfortunately... need to get my evolution
setup going again.

> However there still seems to be confusion over num_disks versus num_m=
embers.
>
> You compare num_disks to raiddisks but my understanding is that num_d=
isks can
> include spares while raiddisks definitely doesn't. =A0Am I confused o=
r are you?

Unfortunately the metadata has no knowledge of how many spares there
should be.  num_disks is always the current container membership as
and spare disks have a metadata record with num_disks =3D=3D 1.

[1]: http://marc.info/?l=3Dlinux-raid&m=3D132387896006974&w=3D2
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
