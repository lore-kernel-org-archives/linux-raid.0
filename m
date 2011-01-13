From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: open_dev_excl in reshape_container() fails
Date: Thu, 13 Jan 2011 15:40:32 +0000
Message-ID: <905EDD02F158D948B186911EB64DB3D176E5A1BC@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Hi,

I've got a problem using open_dev_excl() in reshape_container(), it fai=
ls. This functions goes down
and calls open() with flags O_DIRECT| O_RDWR| O_EXCL.
It fails in reshape_container(), ealier in Grow_reshape() exactly the s=
ame test call to open_dev_excl() succeed.=20
Between test open and open in reshape_container() there is no other ope=
n() performed (or other i/o operation that can cause problem).
It not depends on mdmon action because it is the same for raid5 and rai=
d0.
=46unction open_dev() works, and I'm using it as workaround.

In man pages for open() is told that O_EXCL flag should be used with O_=
CREAT flag only.
I've read in manual for open() also: "If O_EXCL is set and O_CREAT is n=
ot set, the result is undefined"
This can explain my experiences, about open_dev_excl() results.

Please let me know if above is right? What tell you your tests?

If mdadm needs some locking mechanism, probably we should use F_SETLK/F=
_GETLK i.e.:
    int fd =3D open("/dev/name", <flags>);

   /* To lock the file/device */
  =20
    struct flock fl =3D { F_WRLCK, SEEK_SET, 0, 0, 0 };
    fl.l_pid =3D getpid();
    fcntl(ld, F_SETLK, &fl);

    ...

    / * To unlock the file/device */

    struct flock fl =3D { F_UNLCK, SEEK_SET, 0, 0, 0 };
    fl.l_pid =3D getpid();
    fcntl(ld, F_SETLK, &fl);
   =20
    ...

    close(fd);

Please tell me your opinion, because I think we have got a problem.

BR
Adam


-------------------------------------------------------------
Intel Technology Poland Sp. z o.o.
email: adam.kwolek@intel.com=A0=A0=A0=20
phone: +48 58 766 1773


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
