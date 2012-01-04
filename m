From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: Install grub2 to /dev/md126 fails
Date: Tue, 3 Jan 2012 21:24:56 -0500
Message-ID: <CALJXSJrbFXQijWjmGs=tJcOZ7o4+BR=RGoWejq+hifgzTaGAXA@mail.gmail.com>
References: <4F02DEA3.4050901@redhat.com>
	<2012259890.359354.1325640910810.JavaMail.root@sz0019a.westchester.pa.mail.comcast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2012259890.359354.1325640910810.JavaMail.root@sz0019a.westchester.pa.mail.comcast.net>
Sender: linux-raid-owner@vger.kernel.org
To: jlcenter@comcast.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm pretty sure this is the same problem I had with GRUB which
probably wasn't fixed, GRUB detects the whole device instead of a
single partition with metadata at the end of the disk because of wrong
detection order. See this thread:
http://lists.gnu.org/archive/html/grub-devel/2011-01/msg00057.html

On Tue, Jan 3, 2012 at 8:35 PM, <jlcenter@comcast.net> wrote:
>
> From: "Jes Sorensen" <Jes.Sorensen@redhat.com>
>
> Did your raid device(s) get added to /boot/grub2/device.map correctly=
?
> If not, does it install properly if you add the devices there manuall=
y?
>
> I've had a pile of problems with grub2 on Fedora, including something
> like this.
>
>
> Hi Jes,
>
> When I tried to create the device.map file, it only added the individ=
ual disks, not the raid devices. =C2=A0I then tried to add them by hand=
, but I kept getting an error whenever it hit the raid1 volume. =C2=A0W=
hat did you see & how did you resolve it?
>
> Thanks.
>
> =C2=A0 =C2=A0-John
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
