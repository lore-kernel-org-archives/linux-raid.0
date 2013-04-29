From: Harald Hoyer <harald@redhat.com>
Subject: Re: [PATCH 1/1] prevent double open(O_RDWR) on raid creation
Date: Mon, 29 Apr 2013 08:32:31 +0200
Message-ID: <517E13FF.6050308@redhat.com>
References: <1365686313-30833-1-git-send-email-Jes.Sorensen@redhat.com> <1365686313-30833-2-git-send-email-Jes.Sorensen@redhat.com> <20130429105720.593fe99b@notabene.brown> <517E0621.5030700@redhat.com> <20130429161124.454e2fc9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130429161124.454e2fc9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jes.Sorensen@redhat.com, linux-raid@vger.kernel.org, Kay Sievers <kay@vrfy.org>
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 04/29/2013 08:11 AM, NeilBrown wrote:
> On Mon, 29 Apr 2013 07:33:21 +0200 Harald Hoyer <harald@redhat.com> wrote:
> 
>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
> 
>> On 04/29/2013 02:57 AM, NeilBrown wrote:
>>> On Thu, 11 Apr 2013 15:18:33 +0200 Jes.Sorensen@redhat.com wrote:
>>> 
>>>> From: Harald Hoyer <harald@redhat.com>
>>>> 
>>>> This does not trigger the udev inotify twice and saves a lot of blk
>>>> I/O for the raid members.
>>>> 
>>>> Also fixes: https://bugzilla.redhat.com/show_bug.cgi?id=947815
>>>> 
>>>> Signed-off-by: Harald Hoyer <harald@redhat.com> Signed-off-by: Jes 
>>>> Sorensen <Jes.Sorensen@redhat.com>
>>> 
>>> (Sorry for delays.  Thanks for reminders).
>>> 
>>> That patch seems to make sense, but the description above is awfully
>>> thin.
>>> 
>>> Why is double-open a problem exactly?  What does it make udev do?  And
>>> how does that related to ID_FS_TYPE being wrong as mentioned in the
>>> bugzilla entry.
>>> 
>>> NeilBrown
>>> 
> 
>> udevd with watch enabled (inotify on /dev/sd*) gets triggered on close(),
>> when you opened it writeable. So, if you double open() and udev wakes up
>> from the first close(), not all information are written to disk yet, it
>> will not get the ID_FS_TYPE.
> 
>> Seems like the second close() does not trigger an inotify sometimes, so
>> it is missing afterwards all the time.
> 
>> Watch via inotify is just a lazy workaround, so we don't have to modify
>> every tool to emit a "change" uevent, after they changed the disk.
> 
> So udev have a "lazy workaround" so that other programs don't need to
> trigger a change, and as a result, I need to add some special code to
> mdadm. Doesn't seem like I'm getting any advantage out of this laziness.
> 
> How about when udev gets an inotify for a block device, it first checks 
> that it can open it O_EXCL.  If not, it doesn't generate the change event. 
> That seems like the laziest option to me :-)

We cannot open with O_EXCL, because the device can be mounted, and O_EXCL
would fail there.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRfhP+AAoJEANOs3ABTfJwONcP+gOzhDDvWFG0AZdocgttk04o
oV4mr2sde+NtuQMB8ac9v4Y0XP2HnpAYOVAJP7LALpkNHwUYGxtDDbqwWLGQWfPy
xXt6Zq9jE/srwmbBTmCB5sROS5lw6c+M2ft4kza2PDDY+9xyTjxVqVf2tcRGa3Fh
LIFNnKGk58qrgAI/46Muw0rbfMZOpOPuLNrI2aYwl/xmrXmQVXfGLIb+Rms9cdsY
Duk/U05t/DxYupic/fAvkuDmuUzsyBAhpuixL/774m7J3yzf6sNIadtZgy3rMiym
WNz+C8Ltx4d2H1nGmjkw9rKbmnWye15lLfsJGZQxvtt9LkWCPu6L9KbLKQyjjnc9
DBIj/6vID3JhxoLRE7H+zQXk7b9VX6sWAKPo6iFC4LcD8tESs01Jz0bV2kyMcUsZ
1HucYgcd2yzaaMBdEB9LleXd7SCtiBW74qTa/WgFK26notiyIGVWnfBdr9TYi1cB
UJLbsa9XHadq/OW4qVEBWbDbkM6Wpwkc2W7oosh3klauifbn2PXguwp5oeT/CQ1y
HORW36Xt9myAcZWY9iBjFRMwxJNztF89XYWOIzZ5j9fV1wHvCqYqNN+gtyt5vq97
N+Pn4pJ2Nuyygxu++aSv271JBga0YZCIGlIE38J1mJVgZlNAFXIGELs30NhYNhI2
GZ3eOMhawdR9k3NkQbMM
=hDz6
-----END PGP SIGNATURE-----
