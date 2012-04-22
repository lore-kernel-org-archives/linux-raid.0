From: Alex <creamyfish@gmail.com>
Subject: Re: Is this enough for us to have triple-parity RAID?
Date: Sun, 22 Apr 2012 11:14:16 +0800
Message-ID: <CAMqP1GXvGdC_Ff7+tpSqvppfTgQU-2cTdzrcaeqqeDUsRMj81w@mail.gmail.com>
References: <4F8DD02F.1060504@westcontrol.com>
	<4F905690.3060301@zytor.com>
	<CAMqP1GVjqBMTiM9Yb+PxQLULWDnG8x3uvzuLFKya3NXsTPt_hg@mail.gmail.com>
	<067e21e2-6f21-48a7-93a8-bb2249534155@email.android.com>
	<CAMqP1GXaqtxrSviV1ZhBXopt82ZprjzPFppXvLK36yLkptmXQw@mail.gmail.com>
	<4F91B1C4.5080205@hesbynett.no>
	<20120420210106.GA2432@lazy.lzy>
	<20369.54567.60804.896644@tree.ty.sabi.co.UK>
	<20120420223138.GA11308@lazy.lzy>
	<20370.33554.998900.245328@tree.ty.sabi.co.UK>
	<20120421111848.GA28576@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120421111848.GA28576@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Piergiorgio,

Just being curious, any mathematical improvement in Reed-Solomon's
code like the
RS(96,64) you mentioned? The calculation of RS involves arbitrary
multiplication in a
Galois field and table look-up has to be used. Has that already changed=
?

Cheers,
Alex
On Sat, Apr 21, 2012 at 7:18 PM, Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:
> Hi Peter,
>
>> Perhaps it was not clear that "use self repairing coding
>> similarly to Parchive" does not mean the same as "use Parchive".
>
> sorry, I understood you meant storing somewhere
> files with parities.
>
>> Applying self repairing coding to RAID might be easier to
>> imagine considering of a RAID volume as a directory of
>> stripe-sized files.
>
> Exactly, but as far as I know this is the same as
> any N parities RAID.
>
> I mean, the mathematics and algorithm behind should
> be exactly the same...
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
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
