From: Dawning Sky <the.dawning.sky@gmail.com>
Subject: Re: Disk I/O error while rebuilding an md raid-5 array
Date: Mon, 8 Feb 2010 16:45:31 -0800
Message-ID: <adf93d751002081645o2906c43fnc8468c81747fdd3c@mail.gmail.com>
References: <adf93d751002081523y1b9de656kdbba276b3dbc6af4@mail.gmail.com>
	 <87f94c371002081604g37984161h2ba65bd193714780@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c371002081604g37984161h2ba65bd193714780@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 8, 2010 at 4:04 PM, Greg Freemyer <greg.freemyer@gmail.com>=
 wrote:
>>
>> PS, if in the end I have to build a new array, I'll probably go with=
 a
>> raid 6 instead.
>
> Agreed, someone recently posted that for a raid-5 composed of 1TB
> drives the odds of a rebuild failure are 1 in 67 even if the remainin=
g
> drives are within spec. =A0(ie. the unrecoverable bit error rate is
> slowing succumbing to the ever increasing size of drives.)

Has anyone done similar calculation for raid-6?

>
> Greg
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
