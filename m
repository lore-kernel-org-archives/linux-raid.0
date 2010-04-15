From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] imsm: assign UUID of spare device based on ARRAY *device*
	keyword in mdadm configuration file.
Date: Thu, 15 Apr 2010 09:37:26 -0700
Message-ID: <i2le9c3a7c21004150937qe1d0a43buab5020282c22801e@mail.gmail.com>
References: <66C59AD0932712458090B447266D638CD3DBE917@irsmsx504.ger.corp.intel.com>
	 <p2ke9c3a7c21004141515kd565d755z1a522de001b9722f@mail.gmail.com>
	 <66C59AD0932712458090B447266D638CD3F05943@irsmsx504.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <66C59AD0932712458090B447266D638CD3F05943@irsmsx504.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

>>On Thu, Apr 8, 2010 at 7:48 AM, Hawrylewicz Czarnowski, Przemyslaw
>><przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:
>>> If config has list of devices associated with container and it comp=
rises
>>given spare drive, UUID is set apporopriately to this container.
>>> It allows to assign spare with proper container according
>>> to content in devices parameter in configuration file.
>>>
>>
>>I guess it would be nice if a user could direct spares via the
>>configuration file, but what gets honored in the future when this
>>value conflicts with a container group id in the metadata? =A0Especia=
lly
> You are right, but at this moment it is *always* first container. Thi=
s proposal gives a way how user can point out the right one.

We are already fixing this problem in a more comprehensive way with
the spare migration and DOMAIN code.  This 'devices' option will be
deprecated in short order, and its presence would just complicate the
policy decisions.  For example, what takes precedence the DOMAIN
keyword, 'devices' list, or at a future date a spare pool id in the
metadata?  What would you rather write a DOMAIN line to specify the
hardware port ranges or a 'devices' line to identify individual disk
devices and update the configuration file on an ongoing basis?

>>when the actual device associated with a given name /dev/sda changes
>>from one boot to the next, potentially even across controllers, or th=
e
>>admin moves the drive and forgets to update the configuration file.
> but it will need to rewrite this part of config to respect eg. /dev/d=
isk/by-id patterns which are constant, which is far beyond this patch.

=2E..but now you have hard coded something that would be better to floa=
t
between containers on an automatic as needed basis.  The only degree
of freedom I see missing in the current proposals is to have the
ability to disable spare migration to a given container.  That may be
some nice icing to allow some containers/arrays to have higher rebuild
priority, but let's finish the cake first :-).

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
