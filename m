From: CoolCold <coolthecold@gmail.com>
Subject: Re: possible bug - bitmap dirty pages status
Date: Thu, 1 Sep 2011 00:16:36 +0400
Message-ID: <CAGqmV7qKjV1QL_GgxGqmLL2BSui+HVxRo=82KHuW0oLONH1D_A@mail.gmail.com>
References: <CAGqmV7oKNSj2UjEKyqwE2qKrTj9Gj5-OZxwUAVw+uMh1TTRXuA@mail.gmail.com>
	<CAGqmV7pjvEHaNWjuZzt+tSsUJOM28ZqDY6qUROzz8GtMGCxDow@mail.gmail.com>
	<CAECXXi5eo3J8PPXP5xTm-PrqazC_fkwNnjtiAGM4NtsGBMahHA@mail.gmail.com>
	<4E5E2F7D.1010306@anonymous.org.uk>
	<CAGqmV7p=oM_TJoBC-=he3TnJwcmbZBekq14yjiba_p90RC+0BQ@mail.gmail.com>
	<CAECXXi7Ui6T2kti1JjA6Txft7LXR_sM1QbUkmgXj92kSXPrfCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAECXXi7Ui6T2kti1JjA6Txft7LXR_sM1QbUkmgXj92kSXPrfCg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@us.sios.com>
Cc: John Robinson <john.robinson@anonymous.org.uk>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Aug 31, 2011 at 6:08 PM, Paul Clements
<paul.clements@us.sios.com> wrote:
> On Wed, Aug 31, 2011 at 9:16 AM, CoolCold <coolthecold@gmail.com> wro=
te:
>
>> =A0 =A0 =A0 =A0 =A0Bitmap : 44054 bits (chunks), 189 dirty (0.4%)
>>
>> And 16/22 lasts for 4 days.
>
> So if you force another resync, does it change/clear up?
>
> If you unmount/stop all activity does it change?
Well, this server is in production now, may be i'll be able to do
array stop/start later..right now i've set "cat /proc/mdstat" every
minute, and bitmap examine every minute, will see later is it changing
or not.

>
> --
> Paul
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
