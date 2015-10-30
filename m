From: Anugraha Sinha <asinha.mailinglist@gmail.com>
Subject: Re: Raid array name by mdadm
Date: Fri, 30 Oct 2015 21:32:50 +0900
Message-ID: <56336372.2060105@gmail.com>
References: <CA+2rt40JQcxv8CTw-+bpXDGFNorgS53B+thrkNeGN6B2JRQmBw@mail.gmail.com>
 <CALtW_agEVF9x83WP6GO0mJ9zjggS_7_9TJ5dJEdijmR8wHf49A@mail.gmail.com>
 <CA+2rt40zrLoUuGhVcq2DxLiX39PRryeygFN=AZEu_5g0TwR=pQ@mail.gmail.com>
 <CA+2rt40+GxLeSUaQYouHjg=1pC8tJFJrEZFj5ZV0cm03hOJb5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+2rt40+GxLeSUaQYouHjg=1pC8tJFJrEZFj5ZV0cm03hOJb5g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sheng Yang <sheng@yasker.org>, =?UTF-8?Q?Dragan_Milivojevi=c4=87?= <galileo@pkm-inc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Sheng,

On 10/29/2015 7:01 AM, Sheng Yang wrote:
> On Wed, Oct 28, 2015 at 2:40 PM, Sheng Yang <sheng@yasker.org> wrote:
>> On Wed, Oct 28, 2015 at 12:56 PM, Dragan Milivojevi=C4=87
>> <galileo@pkm-inc.com> wrote:
>>> mdadm --create /dev/md/device-123 --verbose --level=3Dmirror
>>> --raid-devices=3D2 /dev/loop0 /dev/loop1
>>>
>>> [root@eos ~]# ll /dev/md/device-123
>>> lrwxrwxrwx 1 root root 8 Oct 28 20:53 /dev/md/device-123 -> ../md12=
7
>>>
>>> [root@eos ~]# mdadm --detail --scan
>>> ARRAY /dev/md/device-123 metadata=3D1.2 name=3Ddevice-123
>>> UUID=3D03ba5df7:7c5cc933:367e19ef:384665c5
>>
>> Thank Dragan! It works!
>>
>> Seems it's mdadm itself create the link rather than do through kerne=
l,
>> which gave me a little trouble. :D
>
> Hi Dragan,
>
> One more question if you don't mind:
>
> When you do
>
> mdadm --stop /dev/md/device-123
>
> Would mdadm remove the broken link file /dev/md/device-123 automatica=
lly?
>
> I found I have to remove the link file manually later...
>

You stopped the array. You might want to assemble it once again saying
mdadm --assemble /dev/md/device-123 /dev/loop0 /dev/loop1
Then, it would just create a new /dev/md*number* and create the link=20
with /dev/md/device-123.

This is my logical thought, havent looked at the mdadm code though to=20
confirm this.

Regards
Anugraha
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
