From: Harald Hoyer <harald@redhat.com>
Subject: Re: [PATCH 1/1] prevent double open(O_RDWR) on raid creation
Date: Mon, 29 Apr 2013 07:33:21 +0200
Message-ID: <517E0621.5030700@redhat.com>
References: <1365686313-30833-1-git-send-email-Jes.Sorensen@redhat.com> <1365686313-30833-2-git-send-email-Jes.Sorensen@redhat.com> <20130429105720.593fe99b@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130429105720.593fe99b@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jes.Sorensen@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/29/2013 02:57 AM, NeilBrown wrote:
> On Thu, 11 Apr 2013 15:18:33 +0200 Jes.Sorensen@redhat.com wrote:
> 
>> From: Harald Hoyer <harald@redhat.com>
>> 
>> This does not trigger the udev inotify twice and saves a lot of blk I/O 
>> for the raid members.
>> 
>> Also fixes: https://bugzilla.redhat.com/show_bug.cgi?id=947815
>> 
>> Signed-off-by: Harald Hoyer <harald@redhat.com> Signed-off-by: Jes
>> Sorensen <Jes.Sorensen@redhat.com>
> 
> (Sorry for delays.  Thanks for reminders).
> 
> That patch seems to make sense, but the description above is awfully thin.
> 
> Why is double-open a problem exactly?  What does it make udev do?  And how 
> does that related to ID_FS_TYPE being wrong as mentioned in the bugzilla 
> entry.
> 
> NeilBrown
> 

udevd with watch enabled (inotify on /dev/sd*) gets triggered on close(), when
you opened it writeable. So, if you double open() and udev wakes up from the
first close(), not all information are written to disk yet, it will not get
the ID_FS_TYPE.

Seems like the second close() does not trigger an inotify sometimes, so it is
missing afterwards all the time.

Watch via inotify is just a lazy workaround, so we don't have to modify every
tool to emit a "change" uevent, after they changed the disk.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRfgYhAAoJEANOs3ABTfJw0uUQALrm0pEjlLd6XgojMTQ6xJGy
y98MVcobi10O/WJyg3HV1RqjnYNu7wfpp+lFIzKRmE/sxIBj8X9ATFfjaopCGWYC
/MPGsdehrCpGPPOZBlt47vTdoaKWB5meKsBm3X1I0AhA+uOxgeV2qfaijoOkHeim
a4RbIUoOJIjIyvbdKCuVbs8mqcr62eMUiZBDPv/b3FcBtOOjYkWVZU14ylqujNtM
WzE+soKyd6L70DvPWVY2KzJ4/5bg/fRuvFcc464k88hAqa8U36FU6MzfTuT4K+ZH
a4FYJtpdrggL+IZuG5XToNR5lpR/YW/B1UBhfCjItXbr1dhX3alk+Y3xZCWvpbRF
FFwAA1GJfcB8UmKp3loBX0YH4gJ8h8d6EITE0Quj38VqG4MlCl89J6ClQZYgXsf8
ZCVDX+lomiQkEp5xYyC85hmwfwepibncqfqKef8+4ABc5xWswQr89gDFPVsFZUE/
PbHzCUlAkz8lvuRSNH6k54b7nFeGn116eJgO7sKESt4uygP0o1A6WpWZI+YAMMg5
CBkxrLYM/iERP7sf8kHr3Wd5EWJNTYm6UsJjVtWStGHuB7LNDo6qPBXxzf84Mkek
1fnIqBfl6QDQBcYb+02p2vGhcTA+P/byi+j+eFQmwV8g2gbkwxhV6/t0Sizj57tC
SlUZAaWHeeNK9HDgoNJ0
=zkJO
-----END PGP SIGNATURE-----
