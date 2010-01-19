From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [[Patch mdadm] 1/5] Make the IMSM_DEVNAME_AS_SERIAL option work
	when creating containers. This allows a person to testing using loopback
	devices that don't support serial number queries.
Date: Mon, 18 Jan 2010 21:42:16 -0700
Message-ID: <e9c3a7c21001182042k1a88e21fpc64ff0bb75ff5854@mail.gmail.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>
	 <1263242294-5353-2-git-send-email-dledford@redhat.com>
	 <e9c3a7c21001181413p60e0322byd97844d3f30a0715@mail.gmail.com>
	 <4B55112F.4090403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B55112F.4090403@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 18, 2010 at 6:55 PM, Doug Ledford <dledford@redhat.com> wro=
te:
> On 01/18/2010 05:13 PM, Dan Williams wrote:
>> Hi Doug,
>>
>> On Mon, Jan 11, 2010 at 1:38 PM, Doug Ledford <dledford@redhat.com> =
wrote:
>>> Signed-off-by: Doug Ledford <dledford@redhat.com>
>>> ---
>>> =A0super-intel.c | =A0 =A05 ++++-
>>> =A01 files changed, 4 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/super-intel.c b/super-intel.c
>>> index d6951cc..fcf438c 100644
>>> --- a/super-intel.c
>>> +++ b/super-intel.c
>>> @@ -3208,7 +3208,10 @@ static int add_to_super_imsm(struct supertyp=
e *st, mdu_disk_info_t *dk,
>>> =A0 =A0 =A0 =A0dd->fd =3D fd;
>>> =A0 =A0 =A0 =A0dd->e =3D NULL;
>>> =A0 =A0 =A0 =A0rv =3D imsm_read_serial(fd, devname, dd->serial);
>>> - =A0 =A0 =A0 if (rv) {
>>> + =A0 =A0 =A0 if (rv && check_env("IMSM_DEVNAME_AS_SERIAL")) {
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(dd->serial, 0, MAX_RAID_SERIAL=
_LEN);
>>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fd2devname(fd, (char *) dd->serial);
>>> + =A0 =A0 =A0 } else if (rv) {
>>
>> This just duplicates the check already inside imsm_read_serial().
>> Containers on loopback devices worked before this patch, so I'll sen=
d
>> a revert.
>>
>> --
>> Dan
>
> Me thinks you didn't try it, because this does not duplicate the code=
 in
> imsm_read_serial(). =A0That code is needed to assemble an IMSM array =
that
> already exists on loopback devices. =A0This is needed to *create* an =
imsm
> container on fresh loopback devices. =A0I'm assuming your imsm contai=
ner
> superblocks already existed or some such.
>

Me thinks you did not try it either :-)

# export IMSM_DEVNAME_AS_SERIAL=3D1
# mdadm --zero-superblock /dev/loop[0-3]
# mdadm -Eb /dev/loop[0-4]
# mdadm -E /dev/loop0
mdadm: No md superblock detected on /dev/loop0.
# mdadm --create /dev/md/imsm /dev/loop[0-3] -n 4 -e imsm
mdadm: /dev/loop0 appears to contain an ext2fs file system
    size=3D306816K  mtime=3DSat Nov 21 10:54:51 2009
mdadm: /dev/loop1 appears to contain an ext2fs file system
    size=3D306816K  mtime=3DSat Nov 21 10:54:51 2009
mdadm: imsm unable to enumerate platform support
    array may not be compatible with hardware/firmware
Continue creating array? y
mdadm: container /dev/md/imsm prepared.
# mdadm -Eb /dev/loop[0-3]
ARRAY metadata=3Dimsm
   spares=3D4

# mdadm -E /dev/loop0
/dev/loop0:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.0.00
    Orig Family : 00000000
         Family : 697a43ec
     Generation : 00000001
           UUID : ffffffff:ffffffff:ffffffff:ffffffff
       Checksum : c3d8d367 correct
    MPB Sectors : 1
          Disks : 1
   RAID Devices : 0

  Disk00 Serial : /dev/loop0
          State : spare
             Id : 00000000
    Usable Size : 204382 (99.81 MiB 104.64 MB)

This is with:
commit 6acad4811b06335a2602fa1eeaec3a8f47f96591
Author: Michael Evan <mjevans1983@gmail.com>
Date:   Wed Dec 9 21:52:18 2009 -0800

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
