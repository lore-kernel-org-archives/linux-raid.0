From: Larkin Lowrey <llowrey@gmail.com>
Subject: Re: RAID 5 array with journal device does not automatically assemble
 at boot
Date: Tue, 14 Nov 2017 17:49:08 -0500
Message-ID: <7c1129bf-22eb-dbb2-7f3b-d3b8844dc92d@gmail.com>
References: <23ACD985-211C-442C-AAE4-19F53F577849@tobx.de>
 <CAPhsuW6rtE6AcW2aVP6SLdBihrN=STmgiNg9qB5XJWCk8_rfUw@mail.gmail.com>
 <E972B38E-F9BD-4D8D-92EC-F7697EBC69AB@tobx.de>
 <fd434281-609c-4999-18e1-3401d48e1d50@grumpydevil.homelinux.org>
 <86F8F078-A7B4-4AF6-AE7B-6929161850FA@tobx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <86F8F078-A7B4-4AF6-AE7B-6929161850FA@tobx.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Tobx <net@tobx.de>, Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
Cc: Song Liu <liu.song.a23@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/14/2017 5:28 PM, Tobx wrote:
> Rudy Zijlstra wrote:
>> What is in your mdadm.conf? Usually found in either /etc/ or in /etc/mdadm/
> Created with /usr/share/mdadm/mkconf:
>
> HOMEHOST <system>
> MAILADDR root
> ARRAY /dev/md/test  metadata=1.2 UUID=d59de5cc:02f560ed:ebcb9400:491955d7 name=debian:test
>     spares=1
>

The "spares=1" is for the journal device. The "mdadm --examine --scan" 
command produced that for me as well but since it seemed odd I deleted 
that part. Since there isn't actually a spare it seems incorrect. I've 
never tried to boot with "spares=1" so I don't know if removing it will 
make any difference.

--Larkin
