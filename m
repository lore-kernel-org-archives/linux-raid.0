From: =?UTF-8?B?QXJrYWRpdXN6IEJ1YmHFgmE=?= <arkadiusz.bubala@open-e.com>
Subject: Re: Mdadm monitor sometimes doesn't send events.
Date: Thu, 02 May 2013 10:34:58 +0200
Message-ID: <51822532.2010500@open-e.com>
References: <517E34E9.3050602@open-e.com> <20130430114806.0f687c0f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130430114806.0f687c0f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30.04.2013 03:48, NeilBrown wrote:
> On Mon, 29 Apr 2013 10:52:57 +0200 Arkadiusz Buba=C5=82a
> <arkadiusz.bubala@open-e.com>  wrote:
>
>   =20
>> Hello,
>> We've got a problem that sometimes mdadm monitor doesn't send events=
=2E
>> Actions are as follows:
>>
>> start:
>> create new RAID 5 array
>> wait until it's rebuilding
>> stop created array
>> go to start
>>
>> Only first time we get "NewArray" event then when new array is creat=
ed
>> only "RebuildStarted" event appears. After our analysis we found out
>> that when we stop an array we get "DeviceDisapeared" event and when =
we
>> create a new array we get "RebuildFinished" and then "RebuildStarted=
"
>> event. Sometimes those two events don't show up.
>>     =20
> The missing NewArray messages was fixed in June last year by
> commit 0f760384ebc92d81a988c1501e4a493ef064ad66
>
> You are using a very old mdadm.  Maybe you should try 3.2.6
>
> I'm less sure about the RebuildStarted/RebuildFinished oddities but t=
here is
> a good chance they are fixed is the latest release too.
>
> NeilBrown
>
>   =20
Thank you,
I'm testing this on 3.2.6 and it seems to work well. Events don't=20
dissapear. We thought that lack of "NewArray" event may be intended.

Could you answer these questions, please:

Do we need to restart mdadm monitor when new disk is added to the syste=
m=20
(hotplug)?

Do we need to generate config file in such situation or running mdadm=20
with option --scan is sufficient?

--=20
Best regards
Arkadiusz Buba=C5=82a
Open-E Poland Sp. z o.o.
www.open-e.com

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
