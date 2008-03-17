From: Luca Berra <bluca@comedia.it>
Subject: Re: software for making initrd's with raid support
Date: Mon, 17 Mar 2008 09:36:43 +0100
Message-ID: <20080317083643.GB13128@percy.comedia.it>
References: <20080312235641.GA7109@rap.rap.dk> <20080313111538.GB4229@percy.comedia.it> <20080313130042.GA11858@rap.rap.dk> <20080314081516.GB12274@percy.comedia.it> <20080314133045.GB13616@rap.rap.dk> <20080315114912.GA11426@percy.comedia.it> <20080315123806.GA20418@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080315123806.GA20418@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Mar 15, 2008 at 01:38:06PM +0100, Keld J=F8rn Simonsen wrote:
>> really?
>> if this is the case you should have submitted a bug report.
>
>It is possible that I do. I would like to find out what to do first,
>however.

in any case if i am to provide any support, i need more information on
the issue you experienced.

>Thanks for your answers.=20
>
>I filed a feature request for cooker on harddrake2 and drakx.
good,
could you send me (privately) the bugzilla number?
>I think mkinitrd is actually used by the kernel, with a make install.
this is because kernel "make install" command looks for a site specific
script called /sbin/installkernel.

>Is that true? Then mkinitrd is a general script that is used on almost
>all linux systems. So I can assume that this is available when I write=
 a
>howto.
afaik redhat, mandriva and turbolinux use a mkinitrd derived from
redhat

suse uses its own mkinitrd command

debian and derivatives use initramfs-tools, or yaird

other distributions i have no knowledge.

L.


--=20
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
