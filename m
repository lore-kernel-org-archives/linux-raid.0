From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: More Hot Unplug/Plug work
Date: Thu, 29 Apr 2010 14:55:23 -0700
Message-ID: <l2he9c3a7c21004291455w936bab77gea816e681f72a943@mail.gmail.com>
References: <4BD714A3.9020801@redhat.com>
	 <905EDD02F158D948B186911EB64DB3D11C954788@irsmsx503.ger.corp.intel.com>
	 <4BD874CB.5040803@redhat.com>
	 <905EDD02F158D948B186911EB64DB3D11C95485F@irsmsx503.ger.corp.intel.com>
	 <4BD8A336.7080309@redhat.com> <20100429110153.7148bb9b@notabene.brown>
	 <4BD8DEB1.40801@intel.com> <20100429123717.2144a341@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100429123717.2144a341@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

On Wed, Apr 28, 2010 at 7:37 PM, Neil Brown <neilb@suse.de> wrote:
>> So something like DOMAIN spanning=3Dimsm, to tell mdadm to follow im=
sm
>> rules for this domain. =A0Where 'spanning' is policy tag??
>>
>
> Thanks.
>
> So we have two different ideas here.
>
> 1/ A given set of devices (paths) are all attached to the one control=
ler.
> 2/ A given array is not allowed to span controllers
>
> The first statement is somewhat similar to a statement about sparegro=
ups.
> It groups devices together is some way.
>
> The second is a policy statement, and is metadata specific to some ex=
tent.
> If I create a native-metadata array using the controller, then adding=
 other
> devices from a different controller is a non-issue. =A0It is only whe=
n an
> IMSM array is created that it is an issue (and then - only if the arr=
ay is to
> be used for boot for for multi-boot).
>
> So the ARRAY line could have "exclusive-group=3Dfoo" where 'foo' is a=
 group
> name similar to those used for 'spare-group=3D'
> But that isn't much fun for auto-detect and auto-assembly.
>
> Maybe we want to extend the 'auto' line. =A0It gives policy on a per-=
metadata
> basis. Maybe:
>
> =A0POLICY auto-assemble =A0+1.x -all
> =A0POLICY same-group =A0imsm
>
> where 'same-group' means that all the devices in an array must be in =
the
> same spare-group. =A0The 'domain' lines assign spare-groups to device=
s.
>
> Maybe "same-group" could be "same-$tag" so we could have different ta=
gs
> for different metadatas....
>
> Is this working for anyone else, or have I lost the plot??
>

I am not grokking the separate POLICY line, especially for defining
the spare-migration border because that is already what DOMAIN is
specifying.

Here is what I think we need to allow for simple honoring of platform
constraints but without needing to expose all the nuances of those
constraints in config-file syntax... yet.

1/ Allow path=3D to take a metadata name this allows the handler to
identify its known controller ports, alleviating the user from needing
to track which ports are allowed, especially as it may change over
time.  If someone really wants to see which ports a metadata handler
cares about we could have a DOMAIN line dumped by --detail-platform
--brief -e imsm.  However for simplicity I would rather just dump:

DOMAIN path=3Dimsm action=3Dspare-same-port spare-migration=3Dimsm

2/ I think we should always block configurations that cross domain
boundaries.  One can always append more path=3D lines to override this.

3/ The metadata handler may want to restrict/control where spares are
placed in a domain.  To enable interaction with CIM we are looking to
add a storage-pool id to the metadata.  The primary usage of this will
be to essentially encode a spare-group number in the metadata.  This
seems to require a spare-migration=3D option to the DOMAIN line.  By
default it is 'all' but it can be set to a metadata-name to let the
handler apply its internal migration policy.

That should cover everything I would like to expose  Comments?

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
