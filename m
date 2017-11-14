From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Subject: Re: RAID 5 array with journal device does not automatically assemble
 at boot
Date: Tue, 14 Nov 2017 21:05:47 +0100
Message-ID: <fd434281-609c-4999-18e1-3401d48e1d50@grumpydevil.homelinux.org>
References: <23ACD985-211C-442C-AAE4-19F53F577849@tobx.de>
 <CAPhsuW6rtE6AcW2aVP6SLdBihrN=STmgiNg9qB5XJWCk8_rfUw@mail.gmail.com>
 <E972B38E-F9BD-4D8D-92EC-F7697EBC69AB@tobx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E972B38E-F9BD-4D8D-92EC-F7697EBC69AB@tobx.de>
Content-Language: nl
Sender: linux-raid-owner@vger.kernel.org
To: Tobx <net@tobx.de>, Song Liu <liu.song.a23@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Op 14/11/2017 om 20:06 schreef Tobx:
> Song Liu wrote:
>> What the version of mdadm in the test? Could you please help get the output of:
>>
>> mdadm -E /dev/sd[bcde]1
>
What is in your mdadm.conf? Usually found in either /etc/ or in /etc/mdadm/

Cheers

Rudy
