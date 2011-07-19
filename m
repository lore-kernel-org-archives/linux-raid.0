From: "Tyler J. Wagner" <tyler@tolaris.com>
Subject: Re: how to recover filesystem after clobbering array?
Date: Tue, 19 Jul 2011 11:43:45 +0100
Message-ID: <4E255FE1.2060006@tolaris.com>
References: <20110719104325.16112cl7f4lrzkjh@mail.sapo.pt> <j03lp4$h72$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j03lp4$h72$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2011-07-19 11:17, David Brown wrote:
> Once you have got image files for each of your disks, make copies of
> these image files to another spare disk. Keep careful notes of exactl=
y
> what you have done here, and which files are which. And put your
> original disks, carefully labelled, on a shelf somewhere.
>
> Now you are in a position to attempt data recovery on your copied
> files. If you do something wrong, you can simply re-copy the image
> files and try again. You still have absolutely no guarantees that
> you'll get anything back - but at least you can be sure you are not
> going to make anything worse.

=46ollow David's advice.

What was the filesystem on the array?

Now, use testdisk, photorec, and foremost to seek through the raw image=
s
and extract files. The good news is, most video formats are detectable
by these tools. All can be installed with your package manager.

Regards,
Tyler

--=20
"Offending fundamentalists isn't my goal =E2=80=93 but if it is an inev=
itable
side-effect of defending human rights, so be it."
   -- Johann Hari

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
