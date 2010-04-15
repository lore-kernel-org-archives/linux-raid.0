From: "Hawrylewicz Czarnowski, Przemyslaw"
	<przemyslaw.hawrylewicz.czarnowski@intel.com>
Subject: RE: [PATCH] imsm: assign UUID of spare device based on ARRAY
 *device* keyword in mdadm configuration file.
Date: Thu, 15 Apr 2010 11:36:19 +0100
Message-ID: <66C59AD0932712458090B447266D638CD3F05943@irsmsx504.ger.corp.intel.com>
References: <66C59AD0932712458090B447266D638CD3DBE917@irsmsx504.ger.corp.intel.com>
 <p2ke9c3a7c21004141515kd565d755z1a522de001b9722f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <p2ke9c3a7c21004141515kd565d755z1a522de001b9722f@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

>-----Original Message-----
>From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On Be=
half
>Of Dan Williams
>Sent: Thursday, April 15, 2010 12:15 AM
>To: Hawrylewicz Czarnowski, Przemyslaw
>Cc: Neil Brown; linux-raid@vger.kernel.org; Ciechanowski, Ed
>Subject: Re: [PATCH] imsm: assign UUID of spare device based on ARRAY
>*device* keyword in mdadm configuration file.
>
>On Thu, Apr 8, 2010 at 7:48 AM, Hawrylewicz Czarnowski, Przemyslaw
><przemyslaw.hawrylewicz.czarnowski@intel.com> wrote:
>> If config has list of devices associated with container and it compr=
ises
>given spare drive, UUID is set apporopriately to this container.
>> It allows to assign spare with proper container according
>> to content in devices parameter in configuration file.
>>
>
>I guess it would be nice if a user could direct spares via the
>configuration file, but what gets honored in the future when this
>value conflicts with a container group id in the metadata?  Especially
You are right, but at this moment it is *always* first container. This =
proposal gives a way how user can point out the right one.

>when the actual device associated with a given name /dev/sda changes
>from one boot to the next, potentially even across controllers, or the
>admin moves the drive and forgets to update the configuration file.
but it will need to rewrite this part of config to respect eg. /dev/dis=
k/by-id patterns which are constant, which is far beyond this patch.

>As much as possible I would like everything to be determined from the
>platform / metadata and discourage using the 'devices' line in the
>configuration file.
As I have written above, the solution available now generates more oppo=
rtunities to make a mistake.

>
>So, I'm on the fence with this one.
>
>A couple technical comments below:
>
>> Signed-off-by: Przemyslaw Czarnowski
><przemyslaw.hawrylewicz.czarnowski@intel.com>
>> ---
>> =A0super-intel.c | =A0 48 ++++++++++++++++++++++++++++++++++++++++++=
+-----

[cut]

>> +
>> =A0/* check the config file to see if we can return a real uuid for =
this
>spare */
>> -static void fixup_container_spare_uuid(struct mdinfo *inf)
>> +static void fixup_container_spare_uuid(struct mdinfo *inf, struct d=
l
>*disk)
>> =A0{
>> - =A0 =A0 =A0 struct mddev_ident_s *array_list;
>> + =A0 =A0 =A0 struct mddev_ident_s *array_list, *first_match =3D NUL=
L;
>>
>> =A0 =A0 =A0 =A0if (inf->array.level !=3D LEVEL_CONTAINER ||
>> =A0 =A0 =A0 =A0 =A0 =A0memcmp(inf->uuid, uuid_match_any, sizeof(int[=
4])) !=3D 0)
>> @@ -1520,12 +1529,41 @@ static void fixup_container_spare_uuid(struc=
t
>mdinfo *inf)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0_sst =
=3D NULL;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (_sst) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy=
(inf->uuid, array_list->uuid,
>sizeof(int[4]));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 char *=
devices =3D array_list->devices;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!f=
irst_match)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 first_match =3D array_list;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 while =
(disk && devices && *devices) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 char path[PATH_MAX];
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 char *p =3D devices;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 int fd;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 devices =3D strchr(devices, ',');
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 if (!devices)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 devices =3D p + strlen(p);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 if (devices-p < PATH_MAX) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 strncpy(path, p, devices
>- p);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 if ((fd =3D open(path,
>O_RDONLY)) >=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if
>(matchfd2devnum(fd, disk->major, disk->minor)) {
>> +
>free(_sst);
>> +
>close(fd);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto
>match;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 close(fd);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 if (*devices =3D=3D ',')
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 devices++;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>
>This routine is already available: match_oneof() in config.c
This one is more specific, but you right, it may be generalized and reu=
sed.

>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0free(=
_sst);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>> =A0 =A0 =A0 =A0}
>> +match:;
>
>Don't need a semicolon after a label.
It had left from the previous version of code when compiler complained =
that there is no semicolon.

>
>--
>Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
