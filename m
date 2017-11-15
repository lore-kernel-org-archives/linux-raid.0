From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: RAID 5 array with journal device does not automatically assemble
 at boot
Date: Tue, 14 Nov 2017 16:38:09 -0800
Message-ID: <CAPhsuW59ti8Sj+coZtsrZn0VRP-EEoTauxsmZnvBzV1tswcy3Q@mail.gmail.com>
References: <23ACD985-211C-442C-AAE4-19F53F577849@tobx.de> <CAPhsuW6rtE6AcW2aVP6SLdBihrN=STmgiNg9qB5XJWCk8_rfUw@mail.gmail.com>
 <E972B38E-F9BD-4D8D-92EC-F7697EBC69AB@tobx.de> <fd434281-609c-4999-18e1-3401d48e1d50@grumpydevil.homelinux.org>
 <86F8F078-A7B4-4AF6-AE7B-6929161850FA@tobx.de> <7c1129bf-22eb-dbb2-7f3b-d3b8844dc92d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7c1129bf-22eb-dbb2-7f3b-d3b8844dc92d@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Larkin Lowrey <llowrey@gmail.com>
Cc: Tobx <net@tobx.de>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tobi,

Your mdadm is a little old. Could you please try rebuild it from
latest source code?

Thanks,
Song

On Tue, Nov 14, 2017 at 2:49 PM, Larkin Lowrey <llowrey@gmail.com> wrote:
> On 11/14/2017 5:28 PM, Tobx wrote:
>>
>> Rudy Zijlstra wrote:
>>>
>>> What is in your mdadm.conf? Usually found in either /etc/ or in
>>> /etc/mdadm/
>>
>> Created with /usr/share/mdadm/mkconf:
>>
>> HOMEHOST <system>
>> MAILADDR root
>> ARRAY /dev/md/test  metadata=1.2 UUID=d59de5cc:02f560ed:ebcb9400:491955d7
>> name=debian:test
>>     spares=1
>>
>
> The "spares=1" is for the journal device. The "mdadm --examine --scan"
> command produced that for me as well but since it seemed odd I deleted that
> part. Since there isn't actually a spare it seems incorrect. I've never
> tried to boot with "spares=1" so I don't know if removing it will make any
> difference.
>
> --Larkin
