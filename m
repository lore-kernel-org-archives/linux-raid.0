From: "Labun, Marcin" <Marcin.Labun@intel.com>
Subject: RE: More Hot Unplug/Plug work
Date: Thu, 29 Apr 2010 19:22:23 +0100
Message-ID: <905EDD02F158D948B186911EB64DB3D11C9A5A2D@irsmsx503.ger.corp.intel.com>
References: <4BD714A3.9020801@redhat.com>
	<905EDD02F158D948B186911EB64DB3D11C954788@irsmsx503.ger.corp.intel.com>
	<4BD874CB.5040803@redhat.com>
	<905EDD02F158D948B186911EB64DB3D11C95485F@irsmsx503.ger.corp.intel.com>
	<4BD8A336.7080309@redhat.com>	<20100429110153.7148bb9b@notabene.brown>
	<4BD8DEB1.40801@intel.com> <20100429123717.2144a341@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100429123717.2144a341@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Doug Ledford <dledford@redhat.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
List-Id: linux-raid.ids

> Maybe we want to extend the 'auto' line.  It gives policy on a per-
> metadata
> basis. Maybe:
> 
>   POLICY auto-assemble  +1.x -all
>   POLICY same-group  imsm
So, the policy would be global for all arrays of some metadata type.
For sure, we want "controller spanning disable" to be default policy for imsm, so this line would be used rather in 
situation when user would like to change it to a non-default one.
Where for instance native metadata would have default  policy "spanning enabled".

Another metadata internal domain example is a new field "pool id" that creates spare sharing domain and stores it in metadata.
