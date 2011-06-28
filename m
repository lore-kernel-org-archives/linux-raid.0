From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Software RAID and TRIM
Date: Tue, 28 Jun 2011 17:11:04 +0100
Message-ID: <BANLkTimswAVra6qnMS4g8WRzs=dhi_f7OQ@mail.gmail.com>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Tom De Mulder <tdm27@cam.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28 June 2011 16:31, Tom De Mulder <tdm27@cam.ac.uk> wrote:
> Hi,
>
>
> I'm investigating SSD performance on Linux, in particular for RAID de=
vices.
>
> As I understand it=E2=80=94and please correct me if I'm wrong=E2=80=94=
currently software
> RAID does not pass through TRIM to the underlying devices. TRIM is es=
sential
> for the continued high performance of SSDs, which otherwise degrade o=
ver
> time.
>
> I don't think there would be any harm in this command being passed th=
rough
> to underlying devices if they don't support it (they would just ignor=
e it),
> and if they do it would make high-performance software RAID of SSDs a
> possibility.
>
>
> Is this something that's in the works?
>
>
>
> Many thanks,
>
> --
> Tom De Mulder <tdm27@cam.ac.uk> - Cambridge University Computing Serv=
ice
> +44 1223 3 31843 - New Museums Site, Pembroke Street, Cambridge CB2 3=
QH
> -> 28/06/2011 : The Moon is Waning Crescent (22% of Full)


IIRC md can already pass TRIM down, but I think the filesystem needs
to know about the underlying architecture, or something, for TRIM to
work in RAID. There's numerous discussions on this in the archives of
this mailing list.

/M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
