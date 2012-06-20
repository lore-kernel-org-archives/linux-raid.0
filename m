From: freeone3000 <freeone3000@gmail.com>
Subject: Re: Data Offset
Date: Tue, 19 Jun 2012 22:56:48 -0500
Message-ID: <CAFhY2ChB03GWOSWjX=YAEkZSLiqQp6LZUhqcnPVfpbpeL3iJ0w@mail.gmail.com>
References: <CAFhY2CjQAutSxzJ-7e+G-1Jw-U6JsFjBBHOmiqOxkhkZy6kd9g@mail.gmail.com>
 <20120605154427.192566af@notabene.brown> <CAFhY2CiDTMRSV2wFCMhT9ZstUkHkJS7E0p7SP-ssfqwaquo+0w@mail.gmail.com>
 <20120610074531.65eaed81@notabene.brown> <CAFhY2CgxkjH6JvJzvQt9XT0oawntK7YoTFqnXQJGzvqthD8XpQ@mail.gmail.com>
 <4FD86179.1080209@pierre-beck.de> <4FD88C50.1000104@turmel.org>
 <4FD8D439.10406@pierre-beck.de> <4FD8D7EE.5000805@turmel.org>
 <4FD8DA4A.8030800@pierre-beck.de> <20120613184945.GA7307@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120613184945.GA7307@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Pierre Beck <mail@pierre-beck.de>, Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks a lot for your help. I have my data back! Played a few movie
files off of the mounted drive, and they all worked perfect. Sorry for
being such a dunce with the block sizes.

`/dev/sdc3:2048s /dev/sdb3:2048s /dev/sde:2048s /dev/sdd3:1024s
missing` mounted the drive successfully. Now, is there a way to
"normalize" my drives so I can mount it without running through this
guesswork again? Or that I can re-create my array using a standard
mdadm?

On Wed, Jun 13, 2012 at 1:49 PM, Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:
>
> Hi all,
>
> On Wed, Jun 13, 2012 at 08:22:02PM +0200, Pierre Beck wrote:
> > I wonder if LVM activation can be done without writing to the array=
?
> > IIRC it updates at least some timestamp ...
>
> we tried setting the array itself read only,
> which prevent (or it should) anybody above,
> filesystem or LVM, to perform writes...
>
> Neveretheless, the result was a bit "strange",
> namely a kernel BUG() or similar, we had to
> reset the PC.
>
> I'm not sure if this was caused by other issue,
> since the PC was in a not really healty state,
> or a direct consequence of md device in r/o.
>
> bye,
>
> --
>
> piergiorgio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml




--
James Moore
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
