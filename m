From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Mounting array at boot - works with some kernels but not others
Date: Sun, 3 Apr 2011 21:20:33 +0100
Message-ID: <BANLkTikykzE1CYQXmK06nR8f37ozxDARKA@mail.gmail.com>
References: <BANLkTinSwLgNze-EdRB6wu1o5QYApHbLXQ@mail.gmail.com>
	<4D98AAD3.2050700@turmel.org>
	<BANLkTimogoGPhRCq-+aT=TobByyp4fdfAA@mail.gmail.com>
	<4D98B136.1010803@turmel.org>
	<BANLkTikoDDFtD+cQ=mJJbiLzCi4jnUsqdA@mail.gmail.com>
	<4D98D3E1.5000107@turmel.org>
	<BANLkTimuMUWJUBmW58L7BmvhtaG4rc6jdQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimuMUWJUBmW58L7BmvhtaG4rc6jdQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dennis Grant <reccedg@gmail.com>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3 April 2011 21:17, Dennis Grant <reccedg@gmail.com> wrote:
>> I don't think you have any array problem. =C2=A0You are suffering fr=
om one of the asynchronous device probing problems that have cropped up=
 from time to time. =C2=A0I think they've since been solved. =C2=A0Plea=
se try some newer kernels.
>
> Is there a way to definitively prove if that's the case?
>
> The 32-30 is the newest kernel pushed out by Ubuntu. :(
>
> DG
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Kernel ppa to the rescue. http://kernel.ubuntu.com/~kernel-ppa/mainline=
/

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
